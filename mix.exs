defmodule Cep.Mixfile do
  use Mix.Project

  def project do
    [app: :cep,
     name: "Cep",
     description: description(),
     package: package(),
     version: "0.0.2",
     elixir: "~> 1.5",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
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
      applications: [:logger, :httpoison]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.13.0"},
      {:poison, "~> 3.1.0"},
      {:sweet_xml, "~> 0.6.5"},
      {:exconstructor, "~> 1.1.0"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end
end
