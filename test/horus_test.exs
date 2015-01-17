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
  
  test "save a file on the server" do
    file_path = "./test/horus_test.txt"
    File.rm(file_path)
    Horus.Client.save_file(file_path, "line1\nline2\nline3")
    :timer.sleep(100)
    assert File.read(file_path) == {:ok, "line1\nline2\nline3"}
    File.rm(file_path)
  end
  
  test "execute and stop a shell script using shell" do
    Horus.Client.shell("/bin/bash #{System.cwd()}/test/sample_shell.sh")
    {[{_, [proc|_]}|_],_} = Horus.Client.procs
    assert Horus.Client.alive?(proc.proc) == true
    Horus.Client.stop(proc.proc)
    assert Horus.Client.alive?(proc.proc) == false
  end
  
  test "avoid double execution with the same process using shell" do
    Horus.Client.shell("ls -la")
    Horus.Client.shell("ls -la")
    {[{_, procs}|_],_} = Horus.Client.procs
    assert Enum.count(procs) == 1
  end
  
  test "remove process from state list using stop_shell" do
    Horus.Client.shell("ls -la")
    :timer.sleep(100)
    {[{_, procs}|_],_} = Horus.Client.procs
    assert Enum.count(procs) == 1
    {[{_, [proc|_]}|_],_} = Horus.Client.procs
    assert Horus.Client.alive?(proc.proc) == false
    Horus.Client.stop_shell("ls -la")
    {[{_, procs}|_],_} = Horus.Client.procs
    assert Enum.count(procs) == 0
  end
  
  test "get process by cmd using get_shell" do
    Horus.Client.shell("echo aa")
    Horus.Client.shell("echo bb")
    Horus.Client.shell("echo cc")
    
    proc_aa = Horus.Client.get_shell("echo aa")
    proc_bb = Horus.Client.get_shell("echo bb")
    proc_cc = Horus.Client.get_shell("echo cc")
    proc_dd = Horus.Client.get_shell("xpto")
    
    assert Enum.into(proc_aa.proc.out, "") == "aa\n"
    assert Enum.into(proc_bb.proc.out, "") == "bb\n"
    assert Enum.into(proc_cc.proc.out, "") == "cc\n"
    assert proc_dd == nil

    {[{_, procs}|_],_} = Horus.Client.procs
    assert Enum.count(procs) == 3
    
    Horus.Client.stop_shell("echo aa")
    {[{_, procs}|_],_} = Horus.Client.procs
    assert Enum.count(procs) == 2
    
    Horus.Client.stop_shell("echo bb")
    {[{_, procs}|_],_} = Horus.Client.procs
    assert Enum.count(procs) == 1
    
    Horus.Client.stop_shell("echo cc")
    {[{_, procs}|_],_} = Horus.Client.procs
    assert Enum.count(procs) == 0
    
  end
    
end
