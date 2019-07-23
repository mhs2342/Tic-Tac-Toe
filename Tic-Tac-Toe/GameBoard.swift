//
//  GameBoard.swift
//  Tic-Tac-Toe
//
//  Created by Matthew Sanford on 7/22/19.
//  Copyright © 2019 Sanch LLC. All rights reserved.
//

import Foundation

enum Player: Int {
    case player1 = 1
    case player2 = -1
}

enum GameError: Error {
    case invalidMove
    case invalidIndex
}

class GameBoard {
    var currentPlayer: Player = .player1
    var remainingMoves = 9
    var board: [[Player?]] = [
        [nil, nil, nil,],
        [nil, nil, nil,],
        [nil, nil, nil,]
    ]

    var printBoard: String {
        return """
             0     1     2
        0  \(rowToString(0))
           -----+-----+------
        1  \(rowToString(1))
           -----+-----+------
        2  \(rowToString(2))
        """
    }

    private func rowToString(_ row: Int) -> String {
        var output = ""
        for (index, val) in board[row].enumerated() {
            if let player = val {
                if player == .player1 {
                    output.append("  o  ")
                } else {
                    output.append("  x  ")
                }
            } else {
                output.append("     ")
            }
            if index != 2 {
                output.append("|")
            }
        }
        return output
    }

    public func isGameOver() -> Player? {
        return calculateWinner()
    }

    public  func move(pos: (row: Int, col: Int)) throws {
        guard board[pos.row][pos.col] == nil else {
            throw GameError.invalidMove
        }

        board[pos.row][pos.col] = currentPlayer

        remainingMoves -= 1
        if currentPlayer == .player1 {
            currentPlayer = .player2
        } else {
            currentPlayer = .player1
        }
    }

    private func calculateWinner() -> Player? {
        do {
            let leftDiag = calculateLeftDiagonal()
            let rightDiag = calculateRightDiagonal()

            if let winner = determineWinner(leftDiag) {
                return winner
            }

            if let winner = determineWinner(rightDiag) {
                return winner
            }

            for i in 0...2 {
                let row = try calculateRow(i)
                if let winner = determineWinner(row) {
                    return winner
                }
                let col = try calculateColumn(i)
                if let winner = determineWinner(col) {
                    return winner
                }
            }
        } catch  {
            print(error)
        }

        return nil
    }

    private func determineWinner(_ score: Int) -> Player? {
        if score == 3 {
            return .player1
        } else if score == -3 {
            return .player2
        } else {
            return nil
        }
    }

    private func calculateRow(_ index: Int) throws -> Int {
        guard index >= 0 && index <= 2 else { throw GameError.invalidIndex }
        let sum = board[index].reduce(0) { (sum, move) -> Int in
            move?.rawValue ?? 0
        }
        return sum
    }

    private func calculateColumn(_ index : Int) throws -> Int {
        guard index >= 0 && index <= 2 else { throw GameError.invalidIndex }
        var sum = 0
        for i in 0...2 {
            if let value = board[i][index] {
                sum += value.rawValue
            }
        }

        return sum
    }

    private func calculateLeftDiagonal() -> Int {
        var sum = 0
        for i in 0...2 {
            if let val = board[i][i] {
                sum += val.rawValue
            }
        }
        return sum
    }

    private func calculateRightDiagonal() -> Int {
        var sum = 0
        for i in stride(from: 2, to: 0, by: -1) {
            if let val = board[i][i] {
                sum += val.rawValue
            }
        }
        return sum
    }
}
