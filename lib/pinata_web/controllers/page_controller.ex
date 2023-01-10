defmodule PinataWeb.PageController do
  use PinataWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
