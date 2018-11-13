defmodule Anta.CLI do
  require Logger

  @default_count 6

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  list with the last _n_ news published
  """

  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  @doc """
  Method that exposes @default_count (used in tests)
  """
  def default_count, do: @default_count

  @doc """
  `argv` can be -h or --help, which returns :help

  Otherwise it is a page number, and (optionally) the number of
  entries to format (defaults to @default_count)

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
                                                 @default_count }
      _ -> :help
    end
  end


  @doc """
  Returns the `--help` text that will be printed in scree
  """
  def process(:help) do
    IO.puts """
    usage: anta <page_number> [ <news_count> | #{@default_count} ]
    """
    System.stop(0)
  end

  @doc """
  _Maestro_ method of the system.

  * Fetches the news list
  * Decodes the response (halts if invalid)
  * Parses the news list
  * Fill each news item with its content
  * Formats and display on the screen
  """
  def process({ page_number, count }) do
    Logger.info "OAntagnoista2 fetching page #{page_number}"
    { page_number, count }
      |> Anta.Fetcher.fetch_news_list
      |> decode_response
      |> Anta.Parser.parse_news_list
      |> pmap(&fill_article_with_content/1)
      |> Anta.Formatter.to_screen
  end

  @doc """
  Fill each article data structure with the content of the individual news

  * Fetches a single news page
  * Decodes the response (halts if invalid)
  * Parses the single news ang extracts the content
  * Update the article map with its content
  """
  def fill_article_with_content(article) do
    content = article[:local_path]
      |> Anta.Fetcher.fetch_single_news
      |> decode_response
      |> Anta.Parser.parse_single_news
    Map.put(article, :content, content)
  end

  @doc """
  Halts the system if response not `:ok`
  """
  def decode_response({ :ok, body }), do: body
  def decode_response({ :error, error }) do
    {_, message} = List.keyfind(error, "message", 0)
    Logger.error "Error fetching from AntaNews: #{message}"
    System.stop(0)
  end

  # Parallel map to fetch data simultaneously
  defp pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end

end
