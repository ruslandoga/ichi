import Config

config :i, ecto_repos: [I.Repo]

import_config "#{config_env()}.exs"
