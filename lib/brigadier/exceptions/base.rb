module Brigadier
  module Exceptions
    class Base < StandardError
      attr_reader :obj

      def initialize(obj)
        @obj = obj
      end

      def as_str
        "%s '%s': %s" % [ parameter_type, obj.name, message ]
      end

      private

        def parameter_type
          obj.class.to_s.to_s.gsub(/^.*::/, '')
        end
    end
  end
end
