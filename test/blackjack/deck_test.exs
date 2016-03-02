defmodule Blackjack.DeckTest do
  use ExUnit.Case

  alias Blackjack.Deck

  test ".ranks returns all possible ranks in the deck" do
    assert Deck.ranks == ~w(Ace King Queen Jack 10 9 8 7 6 5 4 3 2 1)
  end

  test ".hit returns one random card from the deck" do
    assert is_tuple(Deck.hit)
  end

  test ".deal returns two random cards from the deck" do
    hand = Deck.deal

    assert is_list(hand)
    assert length(hand) == 2
  end

  test ".count returns blackjack sum of cards" do
    hand = [{"Ace", :Hearts}, {"3", :Diamonds}]
    assert Deck.count(hand) == 4

    hand = [{"King", :Cubes}, {"8", :Spades}, {"2", :Hearts}]
    assert Deck.count(hand) == 20
  end

  test ".count_occurance returns the number of times a specific rank appears in a list of cards" do
    hand = [{"King", :Cubes}, {"8", :Spades}, {"King", :Hearts}]
    assert Deck.count_occurance(hand, "Ace")  == 0
    assert Deck.count_occurance(hand, "8")    == 1
    assert Deck.count_occurance(hand, "King") == 2

    assert Deck.count_occurance({"King", :Cubes}, "King") == 1
    assert Deck.count_occurance({"Ace", :Cubes}, "King")  == 0
  end
end
