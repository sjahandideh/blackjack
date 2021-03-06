defmodule Blackjack.PlayerTest do
  use ExUnit.Case

  alias Blackjack.Player

  test ".hand returns the current hand of the player" do
    # begining
    shamim = Player.start
    assert Player.next_move(shamim) == :deal # at the start

    # player gets a dealed hand
    hand = [{"King", :Cubes}, {"3", :Hearts}]
    Player.update_hand(shamim, hand)
    assert Player.hand(shamim) == hand
  end

  test ".next_move returns the prefered next move of the player which can be [:hit, :stand]" do
    # begining
    shamim = Player.start
    assert Player.next_move(shamim) == :deal # at the start

    # player gets a dealed hand with sum of 13 < 17
    cards = [{"King", :Cubes}, {"3", :Hearts}]
    Player.update_hand(shamim, cards)
    assert Player.next_move(shamim) == :hit

    # player requests a hit with sum of 15
    card = {"2", :Spades}
    Player.update_hand(shamim, card)
    assert Player.next_move(shamim) == :hit

    # player requests a hit with sum of 20
    card = {"5", :Spades}
    Player.update_hand(shamim, card)
    assert Player.next_move(shamim) == :stand
  end

  test ".moves returns the history of moves performed" do
    # begining
    shamim = Player.start
    assert Player.next_move(shamim) == :deal # at the start

    # player gets a dealed hand with sum of 13 < 17
    cards = [{"King", :Cubes}, {"3", :Hearts}]
    Player.update_hand(shamim, cards)
    assert Player.moves(shamim) == [:deal]
    assert Player.next_move(shamim) == :hit

    # player requests a hit with sum of 15
    card = {"2", :Spades}
    Player.update_hand(shamim, card)
    assert Player.moves(shamim) == [:hit, :deal]

    # player requests a hit with sum of 20
    card = {"5", :Spades}
    Player.update_hand(shamim, card)
    assert Player.moves(shamim) == [:hit, :hit, :deal]
  end
end
