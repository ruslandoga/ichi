import Config

config :i, I.Repo,
  url: "ecto://postgres:postgres@localhost:5432/ichi",
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10
