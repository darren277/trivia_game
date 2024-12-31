# lib/trivia_game_web/channels/room_channel.ex

defmodule TriviaGameWeb.RoomChannel do
  use TriviaGameWeb, :channel

  def join("room:" <> room_id, _params, socket) do
    # Ensure the GameServer exists for this room
    case TriviaGame.GameServer.start_link(room_id) do
      {:ok, _pid} -> {:ok, socket}
      {:error, {:already_started, _pid}} -> {:ok, socket}
      {:error, reason} -> {:error, reason}
    end
  end

  def handle_in("vote", %{"room_id" => room_id, "answer" => answer}, socket) do
    current_question = TriviaGame.GameServer.get_current_question(room_id)

    # Compare the user's answer with the correct answer
    correct = current_question.correct_answer == answer

    # Broadcast the results to all clients
    broadcast!(socket, "vote:results", %{
      room_id: room_id,
      correct: correct,
      correct_answer: current_question.correct_answer
    })

    {:noreply, socket}
  end

  def handle_in("start_question", %{"question" => question, "choices" => choices}, socket) do
    room_id = socket.topic |> String.replace_prefix("room:", "")

    # Call the GameServer to broadcast question
    TriviaGame.GameServer.start_question(room_id, question, choices)

    {:noreply, socket}
  end

  def handle_info(:timeout, socket) do
    # Handle timeouts for game questions
    {:noreply, socket}
  end
end
