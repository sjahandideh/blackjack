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

  def update_hand(me, cards) do
    GenServer.cast me, {:update_hand, cards}
  end

  def next_move(me) do
    GenServer.call me, :next_move
  end

  def moves(me) do
    GenServer.call me, :moves
  end

  ###
  # GenServer API
  ###

  def init(_) do
    state = %{hand: [], moves: [:deal]}
    {:ok, state}
  end

  def handle_call(:hand, _from, state) do
    {:reply, state.hand, state}
  end

  defp update_moves(hand, moves) do
    move = cond do
      hand == []              -> :deal
      (Deck.count(hand) < 17) -> :hit
      true                    -> :stand
    end
    [move | moves]
  end

  def handle_call(:next_move, _from, state) do
    next_move = List.first(state.moves)
    {:reply, next_move, state}
  end

  def handle_cast({:update_hand, cards}, state) do
    new_hand = cond do
      is_list(cards) -> (state.hand ++ cards)
      true           -> [cards | state.hand]
    end
    moves = update_moves(new_hand, state.moves)
    state = %{
      hand: new_hand,
      moves: moves
    }

    {:noreply, state}
  end

  def handle_call(:moves, _from, state) do
    [next_move | moves] = state.moves
    {:reply, moves, state}
  end
end
