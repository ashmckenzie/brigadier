module Brigadier
  module Validators
    module Base
      def initialize(obj)
        @obj = obj
      end

      def validate!
        fail Brigadier::Exceptions::Base.new(obj), failure_message unless valid?
      end

      private

        attr_reader :obj

        def value
          @value ||= obj.value
        end

        def valid?
          !obj.value.match(/poop/i)
        end
    end
  end
end
