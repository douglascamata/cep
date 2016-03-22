defmodule Cep.Mixfile do
  use Mix.Project

  def project do
    [app: :cep,
     name: "Cep",
     description: description,
     package: package,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     preferred_cli_env: [
      vcr: :test, "vcr.delete": :test, "vcr.check": :test, "vcr.show": :test,
     ]
   ]
  end

  defp description do
    """
    A package to query Brazilian CEP codes.

    Has support for multiple source APIs (Correios, ViaCep, Postmon, etc).
    It can query one specific source or query until one source returns a valid
    result.
    """
  end

  defp package do
    [
      maintainers: ["douglascamata"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/douglascamata/cep"}
    ]
  end

  def application do
    [
      mod: {Cep, []},
      applications: [:logger, :httpoison]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.8.0"},
      {:poison, "~> 2.0"},
      {:sweet_xml, "~> 0.6.1"},
      {:codepagex, "~> 0.1.2"},
      {:poolboy, "~> 1.5"},
      {:exvcr, "~> 0.7", only: :test},
      {:mock, "~> 0.1.3", only: :test},
    ]
  end
end
