defmodule Anta.Formatter do

  @moduledoc """
  Turns map into screen text
  """

  @doc """
  Parses the news_list map and prints into screen
  """
  def to_screen(news_list) when is_list(news_list) do
    IO.inspect(news_list)
  end


end