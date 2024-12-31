
defmodule TriviaGame.Repo do
  use Ecto.Repo,
    otp_app: :trivia_game,
    adapter: Ecto.Adapters.Postgres
end
