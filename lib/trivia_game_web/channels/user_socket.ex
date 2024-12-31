defmodule TriviaGameWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "room:*", TriviaGameWeb.RoomChannel

  # Add more channels as needed

  # Called on every socket connect.
  # Return {:ok, socket} to accept or {:error, reason} to deny.
  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  # Socket id's are topics that allow you to identify all sockets
  # for a given user, for things like disconnecting them.
  @impl true
  def id(_socket), do: nil
end
