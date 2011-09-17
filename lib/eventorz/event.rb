module Eventorz
  class Event
  
    public
    def +(handler)
      handlers << handler
    end

    def -(handler)
      handlers.delete(handler)
      handlers.compact!
    end

    def fire(source, parameters)
      @handlers.each do |handler|
        handler.fire( source, parameters)
        nil
      end
    end

    private
    def handlers
      @handlers ||= []
    end
  end
end