defmodule CepSourcesBaseTest do
  use ExUnit.Case, async: true
  alias Cep.Sources.Base

  describe "to_address/1" do
    test "should infer city from localidade field" do
      api_call_result = %{"localidade" => "Araraquara"}
      assert %Cep.Address{city: "Araraquara"} = Base.to_address(api_call_result)
    end

    test "should infer city from cidade field" do
      api_call_result = %{"cidade" => "Toronto"}
      assert %Cep.Address{city: "Toronto"} = Base.to_address(api_call_result)
    end

    test "should infer state from estado field" do
      api_call_result = %{"estado" => "SP"}
      assert %Cep.Address{state: "SP"} = Base.to_address(api_call_result)
    end

    test "should infer state from uf field" do
      api_call_result = %{"uf" => "SP"}
      assert %Cep.Address{state: "SP"} = Base.to_address(api_call_result)
    end

    test "should be able to return a Cep.Address with all fields filled" do
      api_call_result = %{
        "uf" => "SP",
        "cidade" => "São Paulo",
        "cep" => "03042000",
        "complemento" => "lado par",
        "logradouro" => "Rua Piratininga",
        "bairro" => "Brás"
      }

      expected_address = %Cep.Address{
        street: "Rua Piratininga",
        neighborhood: "Brás",
        complement: "lado par",
        cep: "03042000",
        city: "São Paulo",
        state: "SP"
      }

      assert expected_address == Base.to_address(api_call_result)
    end
  end
end
