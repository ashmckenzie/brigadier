module Brigadier
  module Validators
    module Base
      def initialize(obj)
        @obj = obj
      end

      def validate!
        raise Brigadier::Exceptions::Base.new(obj), failure_message unless valid?
        true
      end

      private

        attr_reader :obj

        def value
          @value ||= obj.value
        end
    end
  end
end
