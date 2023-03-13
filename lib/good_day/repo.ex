defmodule GoodDay.Repo do
  use Ecto.Repo,
    otp_app: :good_day,
    adapter: Ecto.Adapters.Postgres
end
