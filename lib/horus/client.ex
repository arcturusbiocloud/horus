defmodule Horus.Client do
  
  def exec(exe, args, host \\ node()) do
    GenServer.cast({:horusserver, host}, {:exec, exe, args})
  end
  
  def stop(proc, host \\ node()) do
    GenServer.cast({:horusserver, host}, {:stop, proc})
  end
  
  def procs() do
    GenServer.multi_call(:horusserver, :procs)
  end
  
  def alive?(proc, host \\ node()) do
    GenServer.call({:horusserver, host}, {:alive, proc})
  end
  
  def save_file(file, content, host \\ node()) do
    GenServer.cast({:horusserver, host}, {:save_file, file, content})
  end
  
end