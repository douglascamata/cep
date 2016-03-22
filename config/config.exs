use Mix.Config

config :codepagex, :encodings, [
      :ascii,
      ~r[iso8859]i,
    ]

config :cep, pool: [size: 5, overflow: 5]
config :cep, sources: [:correios, :viacep, :postmon]

import_config "#{Mix.env}.exs"
