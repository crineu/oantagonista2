defmodule ParserTest do
  use ExUnit.Case
  # doctest Anta.Parser

  import Anta.Parser

  test 'shows list of news for page 10' do
    # sample_element = %{
    #   full_path:  'https://www.oantagonista.com/brasil/manter-lula-nas-pesquisas-e-estrategia-ou-estelionato/',
    #   local_path: 'api/v1/brasil/manter-lula-nas-pesquisas-e-estrategia-ou-estelionato/',
    #   title:      'Manter Lula nas pesquisas é estratégia ou estelionato?',
    #   date:       '2018-06-11 15:08:32'
    # }

    sample_element = %{
      date:       "2018-06-11 14:31:29",
      full_path:  "https://www.oantagonista.com/brasil/o-economista-ruim-de-bola/",
      local_path: "/brasil/o-economista-ruim-de-bola/",
      title:      "O economista ruim de bola"
    }


    news = "test/pagina10.html"
            |> File.read!
            |> Anta.Parser.parse_news_list

    assert is_list(news)
    assert length(news) == 6
    assert Enum.member? news, sample_element
  end

end