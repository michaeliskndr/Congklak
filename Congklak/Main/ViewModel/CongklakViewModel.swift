//
//  CongklakViewModel.swift
//  Congklak
//
//  Created by Michael Iskandar on 22/01/24.
//

import Foundation

class CongklakViewModel: CongklakViewModelResponder {
    private var board: [Int]
    private var currentPlayer: Int
    var playerOneWarehouse: Int = 0
    var playerTwoWarehouse: Int = 0
    var remainingTurn = 16

    init() {
        board = Array(repeating: 7, count: 14)
        currentPlayer = 1
    }

    func playMove(at index: Int) -> Bool {
        guard (currentPlayer == 1 && index < 7) || (currentPlayer == 2 && index >= 7 && index < 14) else {
            return false
        }

        var stones = board[index]
        board[index] = 0

        var currentIndex = index
        var playerOneField = true
        
        // Sowing
        while stones > 0 {
            playerOneField = currentIndex < 7
            if currentIndex < 7 {
                currentIndex = (currentIndex + 1)
            } else {
                currentIndex = (currentIndex - 1)
            }

            if currentPlayer == 1 {
                if currentIndex == 7 {
                    if playerOneField {
                        /// handle scoring for player one
                        playerOneWarehouse += 1
                        stones -= 1
                        if stones == 0 {
                            break
                        } else {
                            currentIndex = 13
                            board[currentIndex] += 1
                            stones -= 1
                            continue
                        }
                    } else {
                        board[currentIndex] += 1
                        stones -= 1
                        currentIndex = 0
                    }
                }
            } else {
                if currentIndex == 7 {
                    if playerOneField {
                        currentIndex = 13
                        board[currentIndex] += 1
                        stones -= 1
                        continue
                    } else {
                        /// handle scoring for player two
                        board[currentIndex] += 1
                        stones -= 1
                        playerTwoWarehouse += 1
                        stones -= 1
                        if stones == 0 {
                            break
                        } else {
                            currentIndex = 0
                            board[currentIndex] += 1
                            stones -= 1
                            continue
                        }
                    }
                }
            }
            
            board[currentIndex] += 1
            stones -= 1
            remainingTurn -= 1
        }


        captureStones(at: currentIndex)
        
        handleExtraTurn(at: currentIndex)
        return true
    }

    func captureStones(at index: Int) {
        guard index != 7 || index < 13, board[index] == 0 else { return }
        var oppositeIndex = 0
        if currentPlayer == 1, index < 7, board[index] == 0 {
            oppositeIndex = index + 7
        } else {
            oppositeIndex = index - 7
        }
        board[index] += board[oppositeIndex]
        board[oppositeIndex] = 0
    }
    
    func handleExtraTurn(at index: Int) {
        if index == 7 {
            currentPlayer = 1
        } else {
            currentPlayer = 3 - currentPlayer
        }
    }

    func isGameFinished() -> Bool {
        return remainingTurn == 0
    }

    func getCurrentPlayer() -> Int {
        return currentPlayer
    }

    func getBoard() -> [Int] {
        return board
    }
}
