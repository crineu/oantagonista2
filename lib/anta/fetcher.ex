defmodule Anta.Site do
  @user_agent [{'User-agent', 'Elixir dave@pragprog.com'}]

  @moduledoc """
  Uses erlang :httpc to fetch the html data from the website
  """

  @doc """
  Fetch one page (for now, `news_count` will be ignored...)
  """
  def fetch({ page_number, _news_count }) do
    page_number
      |> to_website_url
      |> request
      |> handle_response
  end

  @doc """
  Returns the `--help` text that will be printed in scree
  """
  def to_website_url(page_number \\ 1) when is_integer(page_number) do
    'https://www.oantagonista.com/pagina/' ++ Integer.to_charlist(page_number)
  end

  @doc """
  # First, we should start `inets` application.  `httpc` is part of it:
  Application.ensure_all_started(:inets)
  # We should start `ssl` application also, if we want to make secure requests (https):
  Application.ensure_all_started(:ssl)

  link = 'https://www.oantagonista.com/brasil/primo-de-richa-pede-liberdade-gilmar/'
  request = {link, [{'User-agent', 'Elixir dave@pragprog.com'}]}

  Example:
  {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}} = :httpc.request(:get, request, [], [])
  """
  def request(url) do
    Application.ensure_all_started(:inets)
    Application.ensure_all_started(:ssl)

    :httpc.request(:get, {url, @user_agent}, [], [])
  end

  def handle_response({:ok, {{'HTTP/1.1', 200, 'OK'}, _, body}}) do
    {:ok, body}
  end
  def handle_response({:error, {_, _, body}}) do
    {:error, body}
  end

  @doc """
     articles = bloated_html.xpath('//article')
     articles.each do |article|
       next if article.at_xpath('./div/a/@data-link').nil?   # remove falsas notícias
       data = {}
       data[:full_path]  = article.at_xpath('./div/a/@data-link').value
       data[:local_path] = 'api/v1/' + data[:full_path].split('gonista.com/').last
       data[:title]      = article.at_xpath('./div/a/@data-title').value
       data[:date]       = article.at_xpath('./div/a/span/time/@datetime').value
       list << data
     end
     list.reverse  # older up, newer at bottom
  """
  def parse_news_list(html_page) do
    html_page
      |> Floki.parse
      |> Floki.find("article")
      |> Enum.map(&Floki.find(&1, "div a[data-link]"))
      |> Enum.map(&to_struct/1)
  end

  def to_struct(article) do
    # article
    IO.inspect(Floki.find(article, "data-link"))
    IO.inspect(Floki.find(article, "data-title"))

  end

  def parse_news_single(html_page) do

  end


end