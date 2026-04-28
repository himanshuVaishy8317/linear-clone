defmodule LinearClone.Repo do
  use Ecto.Repo,
    otp_app: :linear_clone,
    adapter: Ecto.Adapters.Postgres
end
