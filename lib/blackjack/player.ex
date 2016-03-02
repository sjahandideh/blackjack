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

  ###
  # GenServer API
  # state = player's hand
  ###

  def init(_) do
    hand = []
    {:ok, hand}
  end

  def handle_call(:hand, _from, hand) do
    {:reply, hand, hand}
  end

  def handle_call(:next_move, _from, hand) do
    cond do
      hand == []              -> move = :deal
      (Deck.count(hand) < 17) -> move = :hit
      true                  -> move = :stand 
    end
    {:reply, move, hand}
  end

  def handle_cast({:change_hand, card}, hand) when is_tuple(card) do
    {:noreply, [card | hand]}
  end
  def handle_cast({:change_hand, cards}, hand) when is_list(cards) do
    {:noreply, hand ++ cards}
  end
end
