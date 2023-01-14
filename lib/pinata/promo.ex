defmodule Pinata.Promo do
  alias Pinata.Promo.Recipient

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(recipient, attrs) do
    recipient = Recipient.changeset(recipient, attrs)
    %Ecto.Changeset{valid?: valid} = recipient

    if valid do
      {:ok, recipient}
    else
      {:error, recipient}
    end
  end
end
