//
//  CongklakViewModel.swift
//  Congklak
//
//  Created by Michael Iskandar on 22/01/24.
//

import Foundation
import RxSwift

final class CongklakViewModel: CongklakViewModelResponder {    
    private var board: BehaviorSubject<[Int]> = .init(value: Array(repeating: 7, count: 14))
    var boardObservable: Observable<[Int]> {
        board.asObservable()
    }
    private var _board: [Int]? {
        try? board.value()
    }
    private var currentPlayer: BehaviorSubject<Int> = .init(value: 1)
    private var _player: Int? {
        try? currentPlayer.value()
    }
    var playerObservable: Observable<Int> {
        currentPlayer.asObservable()
    }
    var playerOneWarehouseObservable: Observable<Int> {
        playerOneWarehouse.asObservable()
    }
    private var playerOneWarehouse: BehaviorSubject<Int> = .init(value: 0)
    private var _playerOneWarehouse: Int {
        try! playerOneWarehouse.value()
    }
    var playerTwoWarehouseObservable: Observable<Int> {
        playerTwoWarehouse.asObservable()
    }
    private var playerTwoWarehouse: BehaviorSubject<Int> = .init(value: 0)
    private var _playerTwoWarehouse: Int {
        try! playerTwoWarehouse.value()
    }
    private var invalidMove: BehaviorSubject<String?> = .init(value: nil)
    var invalidMoveObservable: Observable<String?> {
        invalidMove.asObservable()
    }
    var remainingTurn = 16
    private var winner: BehaviorSubject<String?> = .init(value: nil)
    var winnerObservable: Observable<String?> {
        winner.asObservable()
    }
    
    init() {}
    func playMove(at index: Int) {
        guard (_player == 1 && index < 7) || (_player == 2 && index >= 7 && index < 14),
              var board = _board else {
            let message = "Player \(_player ?? 1)'s invalid move"
            invalidMove.on(.next(message))
            return
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

            if _player == 1 {
                if currentIndex == 7 {
                    if playerOneField {
                        /// handle scoring for player one
                        let warehouse = _playerOneWarehouse + 1
                        playerOneWarehouse.onNext(warehouse)
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
                        let warehouse = _playerTwoWarehouse + 1
                        playerTwoWarehouse.onNext(warehouse)
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
            self.board.on(.next(board))
            stones -= 1
        }


        captureStones(at: currentIndex)
        
        remainingTurn -= 1
        if remainingTurn == 0 {
            let message = "Player \(_player ?? 1) win the game"
            winner.on(.next(message))
        }
        handleExtraTurn(at: currentIndex)
    }

    func captureStones(at index: Int) {
        guard index != 7 || index < 13,
              var board = _board,
              board[index] == 0 else { return }
        var oppositeIndex = 0
        if _player == 1, index < 7, board[index] == 0 {
            oppositeIndex = index + 7
        } else if _player == 2, index >= 7, board[index] == 0  {
            oppositeIndex = index - 7
        }
        board[index] += board[oppositeIndex]
        board[oppositeIndex] = 0
        self.board.onNext(board)
    }
    
    func handleExtraTurn(at index: Int) {
        if index == 7 {
            currentPlayer.on(.next(1))
        } else {
            currentPlayer.on(.next(3 - (_player ?? 1)))
        }
    }
    
    func playAgain() {
        board.onNext(.init(Array(repeating: 7, count: 14)))
        remainingTurn = 16
        playerOneWarehouse.onNext(0)
        playerTwoWarehouse.onNext(0)
    }
}
