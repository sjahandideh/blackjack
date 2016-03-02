defmodule Blackjack.Deck do
  # TODO: this has to be a genserver as well.
  # it needs to keep track of the state of the deck
  # TODO: Ace can be 1 or 10 depending on the total sum of hand

  @ranks ~w(Ace King Queen Jack 10 9 8 7 6 5 4 3 2 1)
  @suits ~w(Spades Hearts Diamonds Cubes)

  def ranks, do: @ranks

  def hit do
    pick_random
  end

  def deal do
    [pick_random, pick_random]
  end

  def count_occurance({rank, _}, rank),           do: 1
  def count_occurance({different_rank, _}, rank), do: 0
  def count_occurance(cards, rank) do
    Enum.count(cards, fn(card) ->
      elem(card, 0) == rank
    end)
  end

  def count({"Ace", _}),    do: 1
  def count({"King", _}),   do: 10
  def count({"Queen", _}),  do: 10
  def count({"Jack", _}),   do: 10
  def count({num, _}),      do: String.to_integer(num) 
  def count(cards) do
    Enum.reduce(cards, 0, fn(card, sum) ->
      sum + count(card)
    end)
  end

  ###
  # Private methods
  ###

  defp pick_random do
    rank = Enum.random @ranks
    suit = Enum.random @suits

    {rank, suit}
  end
end
