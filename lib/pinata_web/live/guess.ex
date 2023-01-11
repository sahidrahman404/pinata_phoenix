defmodule PinataWeb.Guess do
  alias Pinata.Accounts
  use Phoenix.LiveView, layout: {PinataWeb.LayoutView, "live.html"}

  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     assign(socket,
       score: 0,
       message: "Make a guess:",
       generated_num: :rand.uniform(10),
       color: "",
       session_id: session["live_socket_id"],
       current_user: user
     )}
  end

  def render(assigns) do
    ~H"""
    <%= if @score >= 0 do %>
      <h1>Your score: <%= @score %></h1>
      <h2>
        <p style={"color:#{@color}"}><%= @message %></p>
        <p>It's <span><%= time() %></span></p>
      </h2>
      <h2>
        <%= for n <- 1..10 do %>
          <a href="#" phx-click="guess" phx-value-number={n}><%= n %></a>
        <% end %>
      </h2>
      <p>hint: <%= @generated_num %></p>
      <p><%= @current_user.email %></p>
      <p><%= @session_id %></p>
    <% else %>
      <h1 style="color: orange;text-align: center">GAME OVER !!!</h1>
      <a data-phx-link="patch" data-phx-link-state="push" href="/">
        Try Again!!!
      </a>
    <% end %>
    """
  end

  def time() do
    DateTime.utc_now() |> to_string
  end

  def handle_event("guess", %{"number" => guess} = data, socket) do
    {guess, _} = Integer.parse(Map.get(data, "number"))
    num = socket.assigns.generated_num
    score = socket.assigns.score

    cond do
      num == guess ->
        message = "Your guess #{guess}. Right. Guess again."
        score = score + 1
        generated_num = :rand.uniform(10)
        color = "green"

        {:noreply,
         assign(socket,
           message: message,
           score: score,
           generated_num: generated_num,
           color: color
         )}

      num != guess ->
        message = "Your guess: #{guess}. Wrong. Guess again."
        score = score - 1
        color = "red"
        {:noreply, assign(socket, message: message, score: score, color: color)}
    end
  end
end
