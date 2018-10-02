defmodule Anta.Parser do

  @moduledoc """
  Uses elixir libraty Floki to parse the html data from the website
  """

  @doc """
  Parses the news_list page into a list of news

  Ruby example:
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
    map = html_page
      |> Floki.parse
      |> Floki.find("article")
      |> Enum.map(&to_map/1)
    require IEx
    IEx.pry
  end

  def to_map(article) do
    [path]  = Floki.attribute(article, "div a",           "data-link")
    [title] = Floki.attribute(article, "div a",           "data-title")
    [date]  = Floki.attribute(article, "div a span time", "datetime")
    [_, local_path] = path |> String.split("gonista.com")
    %{
      full_path:  path,
      local_path: local_path,
      title:      title,
      date:       date
    }
  end


  @doc """
  Parses the news page extracting only the content

    bloated_html
      .at_xpath('//div[@id="entry-text-post"]')             # carrega conteúdo da notícia
      .children.select { |c| c.class == Oga::XML::Element } # filtra apenas os elementos
      .map(&:to_xml)                                        # transforma em xml
      .join
  """
  def parse_news_single(html_page) do

  end


end