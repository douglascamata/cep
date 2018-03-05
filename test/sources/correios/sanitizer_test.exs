defmodule CepSourcesCorreiosSanitizerTest do
  use ExUnit.Case, async: true

  describe "sanitize/1" do
    test "should clean up dashes" do
      sanitized = Cep.Sources.Correios.Sanitizer.sanitize("cep-with-dash")
      assert sanitized == "cepwithdash"
    end

    test "should clean up spaces" do
      sanitized = Cep.Sources.Correios.Sanitizer.sanitize(" cep  with spaces ")
      assert sanitized == "cepwithspaces"
    end
  end
end
