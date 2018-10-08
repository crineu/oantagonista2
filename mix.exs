defmodule Oantagonista2.MixProject do
  use Mix.Project

  def project do
    [
      app:  :oantagonista2,
      version: "0.1.0",
      elixir:  "~> 1.7",

      escript: escript_config(),
      deps: deps(),
      start_permanent: Mix.env() == :prod,

      # Docs
      name: "O Antagonista 2",
      source_url: "https://github.com/crineu/oantagonista2",
      homepage_url: "https://github.com/crineu/oantagonista2",
      docs: [
        # main: "MainPage", # The main page in the docs
        # logo: "path/to/logo.png",
        extras: ["README.md"]
      ]
    ]
  end


  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
      # extra_applications: [:logger, :inets, :ssl]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:floki,  "~> 0.20.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp escript_config do
    [ main_module: Anta.CLI ]
  end
end
