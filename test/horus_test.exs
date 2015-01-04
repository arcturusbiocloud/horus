defmodule HorusTest do
  use ExUnit.Case, async: true
  
  setup do
    Application.stop :horus
    Application.start :horus
  end
  
  test "get an empty processes list" do
    Horus.Server.start_link
    {[h|_],b} = Horus.Client.procs
    assert h == {node(), []}
    assert b == []
  end
  
  test "execute an process" do
    Horus.Client.exec("echo", ["helloworld"])
    {[h|_],_} = Horus.Client.procs
    {_, [proc|_]} = h
    assert proc.err == nil
  end
  
  test "check if a short process is alive" do
    Horus.Client.exec("ls", ["-la"])
    :timer.sleep(100)
    {[h|_],_} = Horus.Client.procs
    {_, [proc|_]} = h
    assert Horus.Client.alive?(proc) == false
  end
  
  test "stop a long process" do
    Horus.Client.exec("ping", ["www.google.com"])
    {[h|_],_} = Horus.Client.procs
    {_, [proc|_]} = h
    assert Horus.Client.alive?(proc) == true
    Horus.Client.stop(proc)
    assert Horus.Client.alive?(proc) == false
  end
  
  test "check the output of a process" do
    Horus.Client.exec("echo", ["helloworld"])
    {[h|_],_} = Horus.Client.procs
    {_, [proc|_]} = h
    
    # Enum.fetch(proc.out, 0)
    # Enum.into(proc.out, "")
    # Enum.into(proc.out, IO.stream(:stdio, :line))
    assert Enum.into(proc.out, "") == "helloworld\n"
  end
  
end
