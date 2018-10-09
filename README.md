# Oantagonista2

Same as `oantagonista`, but now in Elixir

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `oantagonista2` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:oantagonista2, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/oantagonista2](https://hexdocs.pm/oantagonista2).

## Command line help

Generate docs
    
```bash
mix docs
firefox docs/index.html
```

Generates code coverage on screen / html file

```bash
mix coveralls

mix coveralls.html
firefox cover/excoveralls.html
```

Xref module for unreachable and deprecated code

```bash
mix xref unreachable
mix xref deprecated
```

Generating a dependency graph on screen / .png file

```bash
mix xref graph
mix xref graph --format dot
dot -Tpng xref_graph.dot -o xref_graph.png
```

