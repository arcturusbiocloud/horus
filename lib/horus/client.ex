defmodule Horus.Client do
  
  def exec(exe, args, host \\ node()) do
    GenServer.cast({:horusserver, host}, {:exec, exe, args})
  end
  
  def shell(cmd, host \\ node()) do
    GenServer.cast({:horusserver, host}, {:shell, cmd})
  end
  
  def stop(proc, host \\ node()) do
    GenServer.cast({:horusserver, host}, {:stop, proc})
  end
  
  def stop_shell(cmd, host \\ node()) do
    GenServer.cast({:horusserver, host}, {:stop_shell, cmd})
  end
    
  def procs() do
    GenServer.multi_call(:horusserver, :procs)
  end
  
  def alive?(proc, host \\ node()) do
    GenServer.call({:horusserver, host}, {:alive, proc})
  end
  
  def get_shell(cmd, host \\ node()) do
    GenServer.call({:horusserver, host}, {:get_shell, cmd})
  end
  
  def save_file(file, content, host \\ node()) do
    GenServer.cast({:horusserver, host}, {:save_file, file, content})
  end
  
  def camera_streaming(action, host \\ node()) do
    GenServer.call({:horusserver, host}, {:camera_streaming, action})
  end
      
end