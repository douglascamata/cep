defmodule Cep.Sources.Base do
  defmacro __using__(_) do
    quote do
      defp translate_keys(result) do
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

        translated_map =
          for {key, value} <- result, into: %{} do
            {Map.get(key_map, key, key), value}
          end
      end

      defp cep_not_found do
        {:not_found, "CEP not found."}
      end
    end
  end
end
