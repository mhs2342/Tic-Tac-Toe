//
//  main.swift
//  Tic-Tac-Toe
//
//  Created by Matthew Sanford on 7/22/19.
//  Copyright © 2019 Sanch LLC. All rights reserved.
//

import Foundation

let args = CommandLine.arguments
let game = GameBoard()

func extractMove(_ str: String) -> (Int, Int)? {
    if str.count > 3 { return nil }

    if let row = Int(String(str[str.startIndex])),
        let col = Int(String(str[str.index(before: str.endIndex)])) {
        return (row, col)
    }
    return nil
}

func printCurrentMove() {
    switch game.currentPlayer {
    case .player1:
        print("\nPlayer 1's move")
    case .player2:
        print("\nPlayer 2's move")
    }
}

print("Let's play Tic-Tac-Toe!")
print("Make your move like this")
print("0 0\n\n")
print(game.printBoard)

while game.remainingMoves > 0 {
    printCurrentMove()

    while let str = readLine() {
        if let move = extractMove(str) {
            do {
                try game.move(pos: move)
                print(game.printBoard)
                break
            } catch {
                print("Invalid Move")
                printCurrentMove()
            }


        }
    }

    if let winner = game.isGameOver() {
        switch winner {
        case .player1:
            print("Player 1 wins")
        case .player2:
            print("Player 2 wins")
        }
        exit(EXIT_SUCCESS)
    }
}
print("Draw")
exit(EXIT_FAILURE)





