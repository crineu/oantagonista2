defmodule CliTest do
  use ExUnit.Case
  doctest Anta.CLI

  import Anta.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",     "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end
  
  test "test two values returned if two given" do
    assert parse_args(["10", "7"]) == { 10, 7 }
  end

  test "news_count is defaulted if one value given" do
    assert parse_args(["2"]) == { 2, Anta.CLI.default_count }
  end

end