use Mix.Config

config :codepagex, :encodings, [
      :ascii,
      ~r[iso8859]i,
    ]

import_config "#{Mix.env}.exs"
