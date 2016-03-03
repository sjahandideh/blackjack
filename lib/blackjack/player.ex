defmodule Blackjack.Player do
  use GenServer

  alias Blackjack.Deck

  def start do
    {:ok, me} = GenServer.start_link __MODULE__, []
    me
  end

  def hand(me) do
    GenServer.call me, :hand
  end

  def change_hand(me, cards) do
    GenServer.cast me, {:change_hand, cards}
  end

  def next_move(me) do
    GenServer.call me, :next_move
  end

  def moves(me) do
    GenServer.call me, :moves
  end

  ###
  # GenServer API
  # state = player's hand
  ###

  def init(_) do
    state = %{hand: [], moves: []}
    {:ok, state}
  end

  def handle_call(:hand, _from, state) do
    {:reply, state.hand, state}
  end

  def handle_call(:next_move, _from, state) do
    hand = state.hand
    cond do
      hand == []              -> move = :deal
      (Deck.count(hand) < 17) -> move = :hit
      true                  -> move = :stand 
    end
    state = %{state | moves: [move | state.moves] }
    {:reply, move, state}
  end

  def handle_cast({:change_hand, card}, state) when is_tuple(card) do
    state = %{state | hand: [card | state.hand] }
    {:noreply, state}
  end
  def handle_cast({:change_hand, cards}, state) when is_list(cards) do
    state = %{state | hand: (state.hand ++ cards)}
    {:noreply, state}
  end

  def handle_call(:moves, _from, state) do
    {:reply, state.moves, state}
  end
end
