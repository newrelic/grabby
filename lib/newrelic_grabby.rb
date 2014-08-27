# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/rpm/blob/master/LICENSE for complete details.

require "newrelic_grabby/version"
require "newrelic_grabby/controller_instrumentation"
require "newrelic_grabby/discovery_session"

# Prototype for automatic instrumentation, grabbing attributes
# from the current controller instance after it has executed but
# before rendering.  Grabby can start a discovery session, which will
# report every new attribute it discovers across all controller actions
# until a time limit expires or a max number of potential attributes
# are recorded.
#
# Those attributes are reported as AppAttribute events,
# which the Insights UI can use to help the user specify which of all
# the discovered attributes should be captured.  That set of attributes
# selected by the user become rules, which Grabby uses on every controller
# action to look for and report actual attribute values as custom parameters.
# Voila: custom attributes, no coding.
#
# Grabby takes a list of rules as its configuration
# each rule specifies:
#     an instance varibable name
#     (optional) an attribute name
#     the reported attribute name.
#
# When a controller action is executed, Grabby iterates each rule and lookst
# for an instance variable of the specifed name.  If an attribute name is
# specified, then grabby also looks for an attribute of the attribute name. If
# both are present, then Grabby records a custom attribute of the specified
# attribute name.
#
# If no attribute name is specified and the instance variable is a string or
# number, then the instance variable is recorded as-is.
#
# Example rule: {
#   instance_variable: 'user',
#   attribute: 'name',
#   attribute_name: 'user_name'
# }
#
# if a controller action has an instance variable called @user and @user has a
# "name" attribute (either member variable or ActiveRecord attribute) and that
# attribute is a simple String or Number, then Insights will record the custom
# attribute as "user_name"
#
module NewRelic
  module Grabby
    class << self
      attr_reader :discovery_session, :rules
      attr_accessor :enabled

      def debug(message)
        ::NewRelic::Agent.logger.info("[grabby] #{message}")
      end

      #
      # this is the main entry point for Grabby, invoked after a controller
      # action has executed (but before rendering content).
      #
      def after_filter(controller)
        return unless @enabled

        @error_count ||= 0
        @rules ||= {}

        if(controller.params[:grabby_start])
          discovery_session.stop if discovery_session
          @discovery_session = NewRelic::Grabby::DiscoverySession.new
        end

        if(controller.params[:grabby_stop] && @discovery_session)
          discovery_session.stop
          @discovery_session = nil
        end

        if discovery_session && discovery_session.is_running?
          discovery_session.inspect_controller(controller)
        end

        capture_custom_params(controller)
      rescue => e
        debug "Error in controller filter: #{e.message}"
        debug e.backtrace.join("\n")
        @error_count += 1

        if @error_count > 5
          debug "Disabling Grabby due to excessive error count"
          @enabled = false
        end
      end

      def update_rules(rules)
        @rules = {}
        (rules || []).each do |rule|
          add_rule rule['variable_name'], rule['attribute_name'], rule['reporting_name']
        end
      end

      #
      # THIS IS A TOTAL HACK until we have true custom event support
      # in the agent protocol, get undocumented access to the
      # New Relic Agent's request sampler, which will gather and
      # harvest Transaction events (yuck).
      #
      # At least they show up as the specified eventType, and not
      # as Transaction events.
      def send_analytic_event(eventType, event)
        agent = NewRelic::Agent.instance
        request_sampler = agent.instance_variable_get(:@request_sampler)
        event = [{type: eventType}, event]

        request_sampler.synchronize do
          samples = request_sampler.instance_variable_get(:@samples)
          samples.append(event)
        end
      end

      def is_sensitive?(name)
        FORBIDDEN_NAMES.each do |forbidden|
          return true if forbidden.match(name)
        end

        false
      end

      private

      # we store rules in a hash of hashes to reduce the number of times
      # we have to grab an attribute from a controller action via
      # introspection.
      # @rules = {
      #     #{instance_variable_name}: {
      #       #{attribute_name}: #{reported_name},
      #        ...
      #     },
      #     ...
      # }
      def add_rule(instance_variable, attribute, name = nil)
        if is_sensitive?(instance_variable) || is_sensitive?(attribute)
          debug("will not collect #{instance_variable}_#{attribute}: this is potentially sensitive data")
          return
        end

        # determine a default name if none is specified
        if name.nil?
          name = instance_variable
          name += "_" + attribute if attribute
        end

        rules[instance_variable] ||= {}
        rules[instance_variable][attribute] = name
      end

      # based on the configuration rules, capture parameter values
      # and report them as custom attributes
      def capture_custom_params(controller)
        params = {}

        rules.each do |attribute, values|
          instance_var = controller.instance_variable_get("@#{attribute}")
          if instance_var
            values.each do |attr, name|
              value = nil
              if attr == nil
                value = instance_var
              elsif instance_var.respond_to? :attributes
                attributes = instance_var.attributes      # on the off chance this isn't a Hash
                value = attributes[attr] if attributes.is_a?(Hash)
              else
                value = instance_var.instance_variable_get("@#{attr}")
              end

              # only capture Strings or Numbers.  (nil is neither)
              if value.is_a?(String) || value.is_a?(Numeric)
                params[name] = value
              end
            end
          end
        end

        debug "capturing: #{params}" unless params.empty?
        NewRelic::Agent.add_custom_parameters(params) unless params.empty?
      end

      # even though we mask out most of the contents of a given sample
      # value, there are some attributes that we don't even want
      # to report for consideration.
      FORBIDDEN_NAMES = [
          /password/i,
          /passwd/i,
          /ssn/i,
          /secret/i,
          /social.*security/i,
          /token/i,
          /auth/i,
          /salt/i,
          /crypt/i,
          /credit_card/i
      ]
    end

    NewRelic::Agent.config.register_callback(:'grabby.enabled') do |value|
      Grabby.enabled = value

      if Grabby.enabled
        Grabby.debug "Grabby enabled."
      else
        Grabby.debug "Grabby disabled."
      end
    end

    NewRelic::Agent.config.register_callback(:'grabby.rules') do |rules|
      if rules && !rules.empty?
        Grabby.debug "Received configuration: #{rules}"
      end

      # FIXME think about thread safety.
      enabled = Grabby.enabled
      Grabby.enabled = false
      Grabby.update_rules(rules || [])
      Grabby.enabled = enabled
    end

  end
end

