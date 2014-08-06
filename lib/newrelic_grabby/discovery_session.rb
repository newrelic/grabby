# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/rpm/blob/master/LICENSE for complete details.

#
# A discovery session is a special mode that Grabby runs in to discover all of the
# possible custom attributes that could be reported.  The session runs
# until a maxiumum number of possible attributes has been captured, or a time
# period has expired.
#
# Since some of these custom attributes could contain sensitive data, we mask out
# most of of the contents of example string values and trim them to a resonable length
#
module NewRelic::Grabby
  class DiscoverySession
    DEFAULT_DURATION = 1.hour
    DEFAULT_ATTRIBUTE_LIMIT = 100_000

    attr_reader :sent_attributes
    attr_reader :guid

    def initialize(duration = DEFAULT_DURATION, attribute_limit = DEFAULT_ATTRIBUTE_LIMIT)
      @sent_attributes = {}
      @is_running = true
      @start_time = Time.now
      @guid = SecureRandom.uuid
      @duration = duration
      @attribute_limit = attribute_limit
    end

    def is_running?
      @is_running
    end

    def stop
      @is_running = false
      @sent_attributes = {}
    end

    def inspect_controller(controller)
      return if stop_if_necessary

      each_instance_var(controller) do |instance_var, object|
        if object.is_a?(String) || object.is_a?(Numeric)
          discover_attribute(instance_var, object)
        elsif(object.respond_to?(:attributes))
          object.attributes.each do |attribute, value|
            discover_attribute(instance_var, object, attribute, value)
          end
        else
          each_instance_var(object) do |attr, value|
            discover_attribute(instance_var, object, attr, value)
          end
        end
      end
    end

    private

    # stop collecting if we have exceeded the specified time or reported
    # attribute limit.  Return true if stopped
    def stop_if_necessary
      if Time.now - @start_time > @duration || @sent_attributes.size > @attribute_limit
        stop
        return true
      end
      false
    end

    # iterate each instance variable in an object that does not
    # start with "@_", get its value and yield the attribute name
    # and value back to the caller
    def each_instance_var(object)
      instance_vars = object.instance_variables.select do |x|
        x.to_s[0..1] != '@_'
      end

      instance_vars.each do |instance_var|
        value = object.instance_variable_get(instance_var)
        yield instance_var, value
      end
    end

    def discover_attribute(instance_var, object, attribute = nil, value = nil)
      if(key = should_report(instance_var, attribute))
        value = scrub(value || object)
        name = suggested_name(instance_var, attribute)

        if value
          event = {
              controller: NewRelic::Agent.get_transaction_name,
              instance_variable: strip_at(instance_var),
              suggested_name: name,
              session_id: guid,
              sample_value: value
          }
          event[:attribute] = strip_at(attribute) if attribute

          @sent_attributes[key] = value
          ::NewRelic::Grabby.debug("discovered attribute: #{name}")
          ::NewRelic::Grabby.send_analytic_event('AppAttribute', event)
        end
      end
    end

    private

    def strip_at(s)
      s = s[1..-1] if s[0] == '@'
      s
    end

    def suggested_name(instance_var, attribute)
      name = strip_at(instance_var)
      name << "_" + strip_at(attribute) if attribute
      name
    end

    # prepare a value to deliver.  Stirngs should be masked out
    # to protect potentially sensitive data.  They should also
    # be trimmed to avoid memory problems.
    #
    # if the value isn't a string or a number, it shouldn't be sent (return nil)
    def scrub(value)
      if value.is_a? String
        chars_to_keep = [value.length / 2, 10].min
        scrubbed = value[0..chars_to_keep / 2-1]
        scrubbed << '*' * (value.length - chars_to_keep)
        scrubbed << value[-1*(value.length - scrubbed.length)..-1]

        # trim to a reasonable length
        if scrubbed.length > 70
          srubbed = scrubbed[0..66]+'...'
        end
        return scrubbed
      elsif value.is_a? Numeric
        return value
      else
        return nil
      end
    end

    # even though we mask out most of the contents of a given sample
    # value, there are some attributes that we don't even want
    # to report for consideration.
    FORBIDDEN_NAMES = [
        /password/i,
        /passwd/i,
        /ssn/i,
        /social.*security/i,
        /salt/i,
        /crypt/i,
        /credit_card/i
    ]

    # don't report the same data more than once per session (per process).
    # if it should report, return a key that can be used in a cache of
    # reported attributes
    def should_report(instance_var, attribute)
      tname = NewRelic::Agent.get_transaction_name
      return false unless tname


      key = "#{tname}::#{instance_var}"
      key << "::#{attribute}" if attribute

      if @sent_attributes[key]
        return nil
      end

      FORBIDDEN_NAMES.each do |forbidden_name|
        return false if forbidden_name.match(instance_var) || forbidden_name.match(attribute)
      end

      key
    end
  end
end
