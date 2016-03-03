defmodule Blackjack.Game do
  use GenServer

  alias Blackjack.Player
  alias Blackjack.Deck

  def start(players) do
    {:ok, me} = GenServer.start_link __MODULE__, players
    me
  end

  def players(game) do
    GenServer.call game, :players
  end

  def next_player(game) do
    GenServer.call game, :next_player
  end

  def next(game) do
    GenServer.cast game, :next
  end

  ###
  # GenServer API
  ###

  def init(players) do
    state = %{players: players, current_player_index: 0}
    {:ok, state}
  end

  def handle_call(:players, _from, state) do
    {:reply, state.players, state}
  end

  def handle_call(:next_player, _from, state) do
    {:reply, current_player(state), state}
  end

  def handle_cast(:next, state) do
    player = current_player(state)
    next_move = Player.next_move(player)
    perfom_move(player, next_move)

    state = %{state | current_player_index: next_index(state.current_player_index)}
    {:noreply, state}
  end

  ###
  # Private methods
  ###

  defp perfom_move(player, :deal),  do: Player.change_hand(player, Deck.deal)
  defp perfom_move(player, :hit),   do: Player.change_hand(player, Deck.hit)
  defp perfom_move(player, :stand), do: nil

  defp current_player(state) do
    Enum.at(state.players, state.current_player_index)
  end

  defp next_index(index) do
    index = index + 1
    if (index > 3) do
      index = 0
    end
    index
  end
end
