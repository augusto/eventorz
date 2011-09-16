module Eventorz
  class EventHandler
  
    public
    def +(handler)
      handlers << handler
    end

    def fire(source, parameters)
      @handlers.each do |handler|
        handler.fire( source, parameters)
      end
    end

    private
    def handlers
      @handlers ||= []
    end
  end
end