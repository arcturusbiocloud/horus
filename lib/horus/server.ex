defmodule Horus.Server do
  alias Porcelain.Process, as: Proc
  use GenServer
  
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts ++ [name: :horusserver])
  end
  
  def init(opts) do
    # node monitoring and connection
    IO.puts "Horus.Server init opts=#{inspect(opts)}"
    url = Application.get_env(:horus, :master_node)[:url]
    if url do
      IO.puts "Horus.Server connecting to the master_node #{url}"
      Node.set_cookie(Application.get_env(:horus, :master_node)[:cookie])
      Node.monitor(url, true)
    end
    {:ok, []}
  end
  
  def handle_cast({:exec, exe, args}, state) do
    proc = Porcelain.spawn(exe, args, out: :stream)
    {:noreply, [proc|state]}
  end
  
  def handle_cast({:stop, proc}, state) do
    Proc.stop(proc)
    {:noreply, state}
  end
  
  def handle_cast({:save_file, file, content}, state) do
    {:ok, file} = File.open file, [:write]
    IO.binwrite file, content
    File.close file
    {:noreply, state}
  end
    
  def handle_cast(request, state) do
    # Call the default implementation from GenServer
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
  
  def handle_info({:nodedown, node}, state) do
    # wait 1 second to auto-reconnect to the node
    IO.puts "Horus.Server nodedown #{node}"
    :timer.sleep(1000)
    Node.monitor(node, true)
    {:noreply, state}
  end

  def handle_info(request, state) do
    # Call the default implementation from GenServer
    super(request, state)
  end
  
end
