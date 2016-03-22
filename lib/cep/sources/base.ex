defmodule Cep.Sources.Base do
  defmacro __using__(_) do
    quote do
      defp format_result_json(body_json) do
        key_map = %{
          "localidade" => "city",
          "cidade" => "city",
          "estado" => "state",
          "uf" => "state",
          "nome" => "name",
          "bairro" => "neighborhood",
          "complemento" => "complement",
          "logradouro" => "street",
        }
        for {key, value} <- body_json, into: %{} do
          {Map.get(key_map, key, key), value}
        end
      end

      defp cep_not_found do
        {:not_found, "CEP not found."}
      end
    end
  end
end
