defmodule PinataWeb.PromoLive do
  use PinataWeb, :live_view
  alias Pinata.Promo
  alias Pinata.Promo.Recipient

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_recipient()
     |> assign_changeset()}
  end

  def assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  def assign_changeset(%{assigns: %{recipient: recipient}} = socket) do
    socket
    |> assign(:changeset, Promo.change_recipient(recipient))
  end

  def handle_event(
        "validate",
        %{"recipient" => recipient_params},
        %{assigns: %{recipient: recipient}} = socket
      ) do
    changeset =
      recipient
      |> Promo.change_recipient(recipient_params)
      |> Map.put(:action, :validate)

    {
      :noreply,
      socket
      |> assign(:changeset, changeset)
    }
  end

  def handle_event("save", %{"recipient" => recipient_params}, socket) do
    case Promo.send_promo(socket.assigns.recipient, recipient_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "The promo has been sent")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
