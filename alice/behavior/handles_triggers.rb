module Behavior

  module HandlesTriggers

    def self.included(klass)
      klass.send(:attr_accessor, :message)
      klass.extend(ClassMethods)
    end

    def command_string
      @command_string ||= Message::CommandString.new(message.trigger)
    end

    def parser
      @parser ||= Parser::Mash.new(command_string)
    end

    module ClassMethods
      def process(message, command, method)
        method ||= :process
        handler = new(message: message)
        handler.public_send(method)
      end
    end

  end

end
