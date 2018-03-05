defmodule Cep.Sources.Base do
  def translate_keys(result) do
    key_map = %{
      "localidade" => "city",
      "cidade" => "city",
      "estado" => "state",
      "uf" => "state",
      "nome" => "name",
      "bairro" => "neighborhood",
      "complemento" => "complement",
      "logradouro" => "street"
    }

    for {key, value} <- result, into: %{} do
      {Map.get(key_map, key, key), value}
    end
  end

  def cep_not_found_error do
    {:not_found, "CEP not found."}
  end

  def unknown_error(body) do
    {:unknown_error, body}
  end
end
