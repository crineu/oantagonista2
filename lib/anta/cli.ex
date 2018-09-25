defmodule Anta.CLI do
  @default_news 6

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  list with the last _n_ news published
  """
  
  def run(argv) do
    parse_args(argv)
  end

  def default_news, do: @default_news

  @doc """
  `argv` can be -h or --help, which returns :help

  Otherwise it is a page number, and (optionally) the number of 
  entries to format (defaults to @default_news)

  Return a tuple `{ page_number, news_count }` or `:help`
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean ],
                                     aliases:  [ h:    :help    ])

    case parse do
      { [ help: true ], _, _ }  -> :help
      { _, [ page_number, news_count ], _ } -> { String.to_integer(page_number),
                                                 String.to_integer(news_count) }
      { _, [ page_number ], _ }             -> { String.to_integer(page_number),
                                                 @default_news }
      _ -> :help
    end
  end

end 