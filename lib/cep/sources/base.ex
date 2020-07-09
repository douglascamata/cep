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

  def to_address(result) do
    %Cep.Address{
      street: Map.get(result, "logradouro"),
      neighborhood: Map.get(result, "bairro"),
      complement: Map.get(result, "complemento"),
      cep: Map.get(result, "cep"),
      city: infer(:city, result),
      state: infer(:state, result)
    }
  end

  defp infer(:city, %{"localidade" => city}), do: city
  defp infer(:city, %{"cidade" => city}), do: city
  defp infer(:state, %{"estado" => state}), do: state
  defp infer(:state, %{"uf" => state}), do: state
  defp infer(_, _), do: nil

  def cep_not_found_error do
    {:not_found, "CEP not found."}
  end

  def unknown_error(body) do
    {:unknown_error, body}
  end
end
