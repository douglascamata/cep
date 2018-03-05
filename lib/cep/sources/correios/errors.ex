defmodule Cep.Sources.Correios.Errors do
  def cep_not_found?(body) do
    import SweetXml
    message = xpath(body, ~x"//faultstring/text()")
    to_string(message) == "CEP NAO ENCONTRADO"
  end
end
