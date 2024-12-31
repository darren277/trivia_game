defmodule TriviaGameWeb.RoomController do
  use TriviaGameWeb, :controller

  def show(conn, %{"id" => room_id}) do
    render(conn, "show.html", room_id: room_id)
  end
end
