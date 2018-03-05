defmodule Cep.Sources.Correios.ResultFormatter do
  import SweetXml

  @translation_map %{
    "bairro" => "neighborhood",
    "cep" => "cep",
    "cidade" => "city",
    "complemento" => "complement",
    "end" => "street",
    "uf" => "state"
  }

  def format(result) do
    result_map =
      for {tag, translated_tag} <- @translation_map, into: %{} do
        element = xpath(result, ~x"//return/#{tag}/text()")
        {translated_tag, to_string(element)}
      end

    Cep.Address.new(result_map)
  end
end
