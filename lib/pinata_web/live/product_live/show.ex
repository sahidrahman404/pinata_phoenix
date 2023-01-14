defmodule PinataWeb.ProductLive.Show do
  use PinataWeb, :live_view

  alias Pinata.Catalog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :show, "Show Product")}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, Catalog.get_product!(id))}
  end

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
