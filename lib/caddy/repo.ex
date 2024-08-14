defmodule Caddy.Repo do
  use Ecto.Repo,
    otp_app: :caddy,
    adapter: Ecto.Adapters.Postgres
end
