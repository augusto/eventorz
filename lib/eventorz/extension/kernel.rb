
module Kernel
  #
  # Adds an event handler. The method can be invoked with an implicit target (defatuls to self)
  #   object.event_name += handle :method_name
  # or with an explicit target object
  #   object.event_name += handle instance, :method_name
  #
  private
  def handle( *args, &block)
    case
    when (args.length == 0 and block_given?)
      Eventorz::ProcHandler.new block
    when (args.length == 1 and args[0].kind_of? Proc)
      Eventorz::ProcHandler.new args[0]
    when (args.length == 1 and args[0].kind_of? Symbol)
      Eventorz::MethodHandler.new self,    args[0]
    when (args.length == 2 and args[1].kind_of? Symbol)
      Eventorz::MethodHandler.new args[0], args[1]
    else
      raise ArgumentError.new "usage: handle [:method | target, :method | &block | {block}]"
    end
  end
end
