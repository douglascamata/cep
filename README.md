# Cep

A package to query Brazilian CEP codes.

Has support for multiple source APIs (Correios, ViaCep, Postmon, etc).
It can query one specific source or query until one source returns a valid
result.

## Installation

It's is available as an [Hex](https://hex.pm) package and thus can be installed
as:

1. Add cep to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:cep, "~> 0.0.1"}]
end
```

2. Ensure cep is started before your application:

```elixir
def application do
  [applications: [:cep]]
end
```

## Usage

To query for the address of any given Brazilian CEP code:

```elixir
{:ok, address} = Cep.get_address("29375-000")
IO.inspect address
```

The default `Cep.get_address` will first try to access the official Brazilian
Post Office web service to get the information. If the web service is down,
timeout or doesn't have information about one specific CEP the next source will
be automatically and transparently used. If none of the sources give good reply
it will return a proper error, as in the following example:

```elixir
{status, reason} = Cep.get_address("00000-000")
IO.inspect status
IO.inspect reason
```

You can modify the sources that a query will use by using the `sources` keyword
argument and sending as its value any combination of the element from
`Cep.sources` as follows:

```elixir
available_sources = Keyword.delete(Cep.sources, :correios)
{:ok, address} = Cep.get_address("28016-811", sources: available_sources)
```

To query just one specific source there is a sugar: just send the `source` with
the desired source:

```elixir
Cep.get_address("28016-811", source: :viacep)
```

## Future

Future features that are planned:

1. Cep queries cache using `ets`
2. Add even more sources
3. Add policies to order the source list based on different criteria (average
  response time, for example)
4. Use an Agent to store the default source list
