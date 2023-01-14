defmodule Pinata.Promo.Recipient do
  defstruct [:first_name, :email]
  @types %{first_name: :string, email: :string}

  import Ecto.Changeset
  import Pow.Ecto.Schema.Changeset

  def changeset(%__MODULE__{} = user, attrs) do
    {user, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:first_name, :email])
    |> validate_change(:email, fn _, email ->
      case validate_email(email) do
        :ok -> []
        {:error, any} -> [email: any]
      end
    end)
  end
end
