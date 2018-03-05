defmodule Cep.Sources.Correios.Sanitizer do
  def sanitize(cep) do
    cep
    |> String.replace("-", "")
    |> String.replace(" ", "")
  end
end