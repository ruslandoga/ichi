defmodule Ichi.Repo do
  use Ecto.Repo,
    otp_app: :ichi,
    adapter: Ecto.Adapters.Postgres
end
