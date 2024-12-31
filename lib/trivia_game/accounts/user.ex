# lib/trivia_game/accounts/user.ex

defmodule TriviaGame.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :password_hash, :string
    field :token, :string

    timestamps()
  end

  @required_fields ~w(username password_hash token)a
  @optional_fields ~w()a

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case get_field(changeset, :password) do
      nil -> changeset
      password ->
        put_change(changeset, :password_hash, Argon2.hash_password(password))
    end
  end
end
