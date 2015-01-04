defmodule Horus.Server do
  alias Porcelain.Process, as: Proc
  use GenServer
  
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts ++ [name: :horusserver])
  end
  
  def handle_cast({:exec, exe, args}, state) do
    proc = Porcelain.spawn(exe, args, out: :stream)
    {:noreply, [proc|state]}
  end
  
  def handle_cast({:stop, proc}, state) do
    Proc.stop(proc)
    {:noreply, state}
  end
    
  def handle_cast(request, state) do
    super(request, state)
  end
  
  def handle_call(:procs, _from, state) do
    {:reply, state, state}
  end
  
  def handle_call({:alive, proc}, _from, state) do
    {:reply, Proc.alive?(proc), state}
  end
      
  def handle_call(request, from, state) do
    # Call the default implementation from GenServer
    super(request, from, state)
  end

end
