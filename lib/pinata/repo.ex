defmodule Pinata.Repo do
  use Ecto.Repo,
    otp_app: :pinata,
    adapter: Ecto.Adapters.Postgres
end
