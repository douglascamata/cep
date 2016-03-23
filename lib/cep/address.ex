defmodule Cep.Address do
  defstruct [:street, :neighborhood, :city, :state, :complement, :cep]
  use ExConstructor
end
