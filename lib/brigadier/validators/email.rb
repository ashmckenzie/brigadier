module Brigadier
  module Validators
    class Email
      include Base

      def failure_message
        %('%s' is not a valid email address.) % [ value ]
      end

      def valid?
        value.match(/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      end
    end
  end
end
