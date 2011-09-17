module Eventorz
  class ProcHandler
    def initialize(proc)
      @proc = proc
    end

    def fire(source, parameters)
      @proc.call source, parameters
    end

    def ==(other)
      return false unless other.respond_to?(:proc)
      self.proc == other.proc
    end

    protected
    attr_accessor :proc

    public 
    def to_s
      "#{self.class}:proc=#{self.proc}"
    end
  end
end