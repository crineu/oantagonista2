defmodule Anta.Fetcher do
  @headers [
    {'User-agent',   'Elixir dave@pragprog.com'},
    {'Content-type', 'text/html; charset=UTF-8'}
  ]
  @url 'https://www.oantagonista.com/'


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
  def fetch_single_news({ category, unique_name }) do
    # to_do
  end

  @doc """
  Returns the url to the news list
  """
  def to_news_list_url(page_number \\ 1) when is_integer(page_number) do
    @url ++ 'pagina/' ++ Integer.to_charlist(page_number)
  end

  @doc """
  Returns the url of the single news
  """
  def to_singe_news_url(category, unique_name) do
    @url ++ category ++ '/' ++ unique_name
  end

  @doc """
  # First, we should start `inets` application - `httpc` is part of it:
  Application.ensure_all_started(:inets)
  # We should start `ssl` application also, if we want to make secure requests (https):
  Application.ensure_all_started(:ssl)

  link = 'https://www.oantagonista.com/brasil/primo-de-richa-pede-liberdade-gilmar/'
  request = {link, @headers}

  Example:
  {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}} = :httpc.request(:get, request, [], [])
  """
  def request(url) do
    Application.ensure_all_started(:inets)
    Application.ensure_all_started(:ssl)

    :httpc.request(:get, {url, @headers}, [], [])
  end


  def handle_response({:ok, {{'HTTP/1.1', 200, 'OK'}, _, body}}) do
    {:ok, body}
  end
  def handle_response({:error, {_, _, body}}) do
    {:error, body}
  end

end