# lib/trivia_game/game_server.ex

defmodule TriviaGame.GameServer do
  use GenServer

  def start_link(room_id) do
    GenServer.start_link(__MODULE__, room_id, name: {:global, :"game_#{room_id}"})
  end

  def init(room_id) do
    {:ok, %{}}
  end

  def handle_cast({:start_question, question}, state) do
    # Handle starting a new question
    {:noreply, Map.put(state, :current_question, question)}
  end

  def handle_cast({:end_question, correct_answer}, state) do
    # Handle ending a question and calculating results
    broadcast_results(state[:room_id], correct_answer)
    {:noreply, Map.put(state, :current_question, nil)}
  end

  defp broadcast_results(room_id, correct_answer) do
    TriviaGameWeb.Endpoint.broadcast!("room:#{room_id}", "vote:results", %{correct_answer: correct_answer})
  end
end
