
module Kernel
  #
  # Adds an event handler. The method can be invoked with an implicit target (defatuls to self)
  #   object.event_name += handle :method_name
  # or with an explicit target object
  #   object.event_name += handle instance, :method_name
  #
  private
  def handle( *args )
    if args.length == 1 
      Eventorz::InvocationWrapper.new self,    args[0]
    elsif args.length == 2
      Eventorz::InvocationWrapper.new args[0], args[1]
    end
  end
end
