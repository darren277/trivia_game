# lib/trivia_game/game_server.ex

defmodule TriviaGame.GameServer do
  use GenServer

  require Logger

  def start_link(room_id) do
    GenServer.start_link(__MODULE__, %{room_id: room_id}, name: {:global, :"game_#{room_id}"})
  end

  @impl true
  def init(state) do
    IO.inspect(state, label: "GameServer Initial State")
    # We store room_id in state so we can broadcast to the correct room
    #{:ok, %{room_id: room_id, current_question: nil}}
    {:ok, state}
  end

  # Example state structure
  defstruct current_question: nil

  # Public API
  def get_current_question(room_id) do
    GenServer.call({:global, :"game_#{room_id}"}, :get_current_question)
  end

   # Public API for starting a question
   def start_question(room_id, question, choices) do
    # GenServer.cast({:global, :"game_#{room_id}"}, {:start_question, question, choices})
    Logger.debug("Broadcasting NEW_QUESTION for room:#{room_id} -> #{inspect(choices)}")
    #TriviaGameWeb.Endpoint.broadcast!("room:#{room_id}", "new_question", %{question: question, choices: choices})
    GenServer.cast({:global, :"game_#{room_id}"}, {:start_question, question, choices})
  end

  ## Callbacks

  # :start_question will broadcast a "new_question" event to all clients in "room:#{room_id}"
  @impl true
  def handle_cast({:start_question, question, choices}, state) do
    IO.inspect(state, label: "GameServer State Before Start Question")

    TriviaGameWeb.Endpoint.broadcast!("room:#{state.room_id}", "new_question", %{question: question, choices: choices})

    # Track the current question in memory
    new_state = state |> Map.put(:current_question, %{question: question, choices: choices})
    IO.inspect(new_state, label: "GameServer State After Start Question")
    {:noreply, new_state}
  end

   # Add this missing handle_call/3 clause
   @impl true
   def handle_call(:get_current_question, _from, state) do
     {:reply, state.current_question, state}
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
