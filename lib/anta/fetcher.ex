defmodule Anta.Fetcher do
  require Logger

  @headers [
    {'User-agent',   'Elixir dave@pragprog.com'},
    {'Content-type', 'text/html; charset=UTF-8'}
  ]
  @hostname Application.get_env(:oantagonista2, :anta_url)
  @options  [{:body_format, :binary}]  # needed for ISO-8859-1 chars!


  @moduledoc """
  Uses erlang :httpc to fetch the html data from the website
  """

  @doc """
  Fetch news page (for now, `news_count` will be ignored...)
  and transforms into a list of news
  """
  def fetch_news_list({ page_number, _news_count }) do
    page_number
      |> to_news_list_url
      |> request
      |> handle_response
  end

  @doc """
  Fetch single news page and transforms into a string with the content (in html)
  """
  def fetch_single_news(path) do
    [category, unique_name] = String.split(path, "/", trim: true)
    [category, unique_name]
      |> to_single_news_url
      |> request
      |> handle_response
  end


  @doc """
  Returns the url to the news list

  ## Example
      iex> Anta.Fetcher.to_news_list_url()
      "https://www.oantagonista.com/pagina/1"

      iex> Anta.Fetcher.to_news_list_url(8)
      "https://www.oantagonista.com/pagina/8"
  """
  def to_news_list_url(page_number \\ 1) when is_integer(page_number) do
    "#{@hostname}/pagina/#{page_number}"
  end

  @doc """
  Returns the url of the single news

  ## Example
      iex> Anta.Fetcher.to_single_news_url(["brasil", "eleicao-2018"])
      "https://www.oantagonista.com/brasil/eleicao-2018"
  """
  def to_single_news_url([category, unique_name]) do
    "#{@hostname}/#{category}/#{unique_name}"
  end


  @doc """
  We should start `inets` application - `httpc` is part of it;
  We should start `ssl` also, if we want to make secure requests (https):
      Application.ensure_all_started(:inets)
      Application.ensure_all_started(:ssl)

  Sample code:
      link = 'https://www.oantagonista.com/brasil/primo-de-richa-pede-liberdade-gilmar/'
      request = {link, @headers}

      # options NECESSARY because :body_format defaults to :string = DO NOT WORK WITH CP1252
      options = [{:body_format, :binary}]

      Example:
      {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}} = :httpc.request(:get, request, [], [])
  """
  def request(url) when is_binary(url), do: url |> String.to_charlist |> request
  def request(url) when is_list(url) do
    :httpc.request(:get, {url, @headers}, [], @options)
  end


  def handle_response({:ok, {{'HTTP/1.1', 200, 'OK'}, _, body}}) do
    Logger.info "Sucessful response..."
    {:ok, body}
  end
  def handle_response({:error, {_, _, body}}) do
    Logger.error "Network error response..."
    {:error, body}
  end

end