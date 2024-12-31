# lib/trivia_game_web/channels/room_channel.ex

defmodule TriviaGameWeb.RoomChannel do
  use TriviaGameWeb, :channel

  def join("room:" <> room_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("vote", %{"room_id" => room_id, "answer" => answer}, socket) do
    # Implement logic to handle votes
    broadcast_from(socket, "vote:results", %{room_id: room_id, correct_answer: 1}) # Example broadcast
    {:noreply, socket}
  end

  def handle_info(:timeout, socket) do
    # Handle timeouts for game questions
    {:noreply, socket}
  end
end
