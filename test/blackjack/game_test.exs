defmodule Blackjack.GameTest do
  use ExUnit.Case

  alias Blackjack.Game
  alias Blackjack.Player
  alias Blackjack.Deck

  setup do
    p1 = Player.start
    p2 = Player.start
    p3 = Player.start
    p4 = Player.start
    players = [p1, p2, p3, p4]
    game = Game.start players
    {:ok, game: game, players: players}
  end

  test ".start starts a new genserver with 4 players, a dealer and a deck", %{game: game, players: players} do
    assert Game.players(game) == players
  end

  test ".next_player returns the player who's round it is", %{game: game, players: players} do
    assert Game.next_player(game) == List.first(players)
  end

  test ".next performs the next move" do
    p1 = Player.start
    p2 = Player.start
    p3 = Player.start
    p4 = Player.start
    players = [p1, p2, p3, p4]
    game = Game.start players
    Game.next(game)
    assert Player.hand(p1) == [:deal]
    assert Player.moves(p1) == [:deal]
  end
end
