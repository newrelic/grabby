# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/rpm/blob/master/LICENSE for complete details.

DependencyDetection.defer do
  @name = :grabby_controller

  depends_on do
    defined?(::Rails) && defined?(::ActionController::Base)
  end

  module NewRelic::Grabby
    module ControllerInstrumentation
      protected

      def newrelic_grab_custom_attributes
        NewRelic::Grabby.after_filter(self)
      end
    end
  end

  executes do
    NewRelic::Grabby.debug "Installing Grabby Instrumentation"
    NewRelic::Agent.logger.info 'Installing Grabby Controller instrumentation'
    ActionController::Base.class_eval do
      def newrelic_grab_custom_attributes
        NewRelic::Grabby.after_filter(self)
      end

      after_filter :newrelic_grab_custom_attributes
    end
  end

end