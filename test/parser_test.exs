defmodule ParserTest do
  use ExUnit.Case
  # doctest Anta.Parser

  test 'shows list of news for page 10' do
    sample_1 = %{
      full_path:  "https://www.oantagonista.com/brasil/manter-lula-nas-pesquisas-e-estrategia-ou-estelionato/",
      local_path: "/brasil/manter-lula-nas-pesquisas-e-estrategia-ou-estelionato/",
      title:      "Manter Lula nas pesquisas é estratégia ou estelionato?",
      date:       "2018-06-11 15:08:32"
    }

    sample_2 = %{
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
    assert Enum.member? news, sample_1
    assert Enum.member? news, sample_2
  end


  describe "single news parser" do

    test "clean notícia jucá" do
      output = "<p>É balela que Romero Jucá, quando disse a Sérgio Machado sobre a necessidade de estancar" <>
               " a “sangria”, se referia à crise econômica e política.</p><p>Ele claramente falou da Lava " <>
               "Jato, da necessidade de parar a operação. </p><p></p>"

      text = "test/brasil__a-balela-de-juca.html"
        |> File.read!
        |> Anta.Parser.parse_single_news

      assert text == output
    end

    test "clean notícia lula preso" do
      output = "<p>O Antagonista acaba de confirmar com fontes do TRF-4 que o desembargador Gebran Neto"   <>
               " colocará o último recurso de Lula em julgamento na segunda-feira 26.</p><p>Como os"       <>
               " embargos de declaração não alteram a sentença, a prisão do ex-presidente será confirmada" <>
               " e caberá a Sergio Moro a ordem final – que poderá sair no mesmo dia.</p>"

      text = "test/brasil__confirmado-lula-sera-preso-na-segunda-feira-26.html"
        |> File.read!
        |> Anta.Parser.parse_single_news

      assert text == output
    end

    test "clean notícia com vídeo youtube" do
      text = "test/tv__resumao-antagonista-pimenta-na-lava-jato.html"
        |> File.read!
        |> Anta.Parser.parse_single_news

      assert text == []
    end

  end


end