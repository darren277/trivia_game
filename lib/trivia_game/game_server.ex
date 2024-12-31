# lib/trivia_game/game_server.ex

defmodule TriviaGame.GameServer do
  use GenServer

  def start_link(room_id) do
    GenServer.start_link(__MODULE__, room_id, name: {:global, :"game_#{room_id}"})
  end

  def init(room_id) do
    # We store room_id in state so we can broadcast to the correct room
    {:ok, %{room_id: room_id, current_question: nil}}
  end

   # Public API for starting a question
   def start_question(room_id, question, choices) do
    GenServer.cast({:global, :"game_#{room_id}"}, {:start_question, question, choices})
  end

  ## Callbacks

  # :start_question will broadcast a "new_question" event to all clients in "room:#{room_id}"
  def handle_cast({:start_question, question, choices}, state) do
    TriviaGameWeb.Endpoint.broadcast!(
      "room:#{state.room_id}",
      "new_question",
      %{question: question, choices: choices}
    )

    # Track the current question in memory
    new_state = state
                |> Map.put(:current_question, %{question: question, choices: choices})
    {:noreply, new_state}
  end

  # def handle_cast({:start_question, question}, state) do
  #   # Handle starting a new question
  #   {:noreply, Map.put(state, :current_question, question)}
  # end

  # def handle_cast({:end_question, correct_answer}, state) do
  #   # Handle ending a question and calculating results
  #   broadcast_results(state[:room_id], correct_answer)
  #   {:noreply, Map.put(state, :current_question, nil)}
  # end

  # defp broadcast_results(room_id, correct_answer) do
  #   TriviaGameWeb.Endpoint.broadcast!("room:#{room_id}", "vote:results", %{correct_answer: correct_answer})
  # end
end
