defmodule Cep.Sources.Correios.Errors do
  def cep_not_found?(body) do
    import SweetXml
    message = xpath(fix_xmerl_unicode(body), ~x"//faultstring/text()")
    to_string(message) == "CEP NAO ENCONTRADO"
  end

  def invalid_cep?(body) do
    import SweetXml
    message = xpath(fix_xmerl_unicode(body), ~x"//faultstring/text()")
    to_string(message) == "CEP INVÁLIDO"
  end

  defp fix_xmerl_unicode(text) do
    binary = :unicode.characters_to_binary(text, :latin1)
    :binary.bin_to_list(binary)
  end
end
