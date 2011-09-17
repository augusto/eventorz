module Eventorz
  class MethodHandler
    def initialize(target, method_name)
      @target = target
      @method_name = method_name
    end

    def fire(source, parameters)
      @target.send @method_name, source, parameters
      nil
    end

    def ==(other)
      return false unless other.respond_to?(:target) and other.respond_to?(:method_name)
      self.target == other.target and self.method_name == other.method_name
    end

    protected
    attr_accessor :target, :method_name;

    public 
    def to_s
      "#{self.class}:target=#{self.target};method=#{self.method_name}"
    end
  end
end