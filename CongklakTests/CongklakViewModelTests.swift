//
//  CongklakViewModelTests.swift
//  CongklakTests
//
//  Created by Michael Iskandar on 22/01/24.
//

import XCTest
import RxSwift
import RxTest
@testable import Congklak

class CongklakViewModelTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var viewModel: CongklakViewModel!

    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        viewModel = CongklakViewModel()
    }

    override func tearDown() {
        scheduler = nil
        disposeBag = nil
        viewModel = nil
        super.tearDown()
    }

    func testPlayMoveValidMove() {
        let boardObserver = scheduler.createObserver([Int].self)
        let playerObserver = scheduler.createObserver(Int.self)
        let invalidMoveObserver = scheduler.createObserver(String?.self)
        let winnerObserver = scheduler.createObserver(String?.self)

        viewModel.boardObservable
            .subscribe(boardObserver)
            .disposed(by: disposeBag)

        viewModel.playerObservable
            .subscribe(playerObserver)
            .disposed(by: disposeBag)

        viewModel.invalidMoveObservable
            .subscribe(invalidMoveObserver)
            .disposed(by: disposeBag)

        viewModel.winnerObservable
            .subscribe(winnerObserver)
            .disposed(by: disposeBag)

        // Simulate a valid move
        scheduler.createColdObservable([.next(10, 0)])
            .subscribe(onNext: { [weak self] index in
                self?.viewModel.playMove(at: index)
            })
            .disposed(by: disposeBag)

        scheduler.start()

        // Verify the expected changes
        XCTAssertEqual(boardObserver.events.count, 7)
        XCTAssertEqual(playerObserver.events.count, 2)
        XCTAssertEqual(invalidMoveObserver.events.count, 1)
        XCTAssertEqual(winnerObserver.events.count, 1)

        // Add more assertions as needed
    }

    func testPlayMoveInvalidMove() {
        let boardObserver = scheduler.createObserver([Int].self)
        let playerObserver = scheduler.createObserver(Int.self)
        let invalidMoveObserver = scheduler.createObserver(String?.self)
        let winnerObserver = scheduler.createObserver(String?.self)

        viewModel.boardObservable
            .subscribe(boardObserver)
            .disposed(by: disposeBag)

        viewModel.playerObservable
            .subscribe(playerObserver)
            .disposed(by: disposeBag)

        viewModel.invalidMoveObservable
            .subscribe(invalidMoveObserver)
            .disposed(by: disposeBag)

        viewModel.winnerObservable
            .subscribe(winnerObserver)
            .disposed(by: disposeBag)

        // Simulate an invalid move
        scheduler.createColdObservable([.next(10, 8)]) // Assuming 8 is an invalid move for player 1
            .subscribe(onNext: { [weak self] index in
                self?.viewModel.playMove(at: index)
            })
            .disposed(by: disposeBag)

        scheduler.start()

        // Verify the expected changes
        XCTAssertEqual(boardObserver.events.count, 1)
        XCTAssertEqual(playerObserver.events.count, 1)
        XCTAssertEqual(invalidMoveObserver.events.count, 2)
        XCTAssertEqual(winnerObserver.events.count, 1)
    }

    func testCaptureStones() {
        let boardObserver = scheduler.createObserver([Int].self)

        viewModel.boardObservable
            .subscribe(boardObserver)
            .disposed(by: disposeBag)

        // Simulate a move that results in capturing stones
        scheduler.createColdObservable([.next(10, 0)])
            .subscribe(onNext: { [weak self] index in
                self?.viewModel.playMove(at: index)
            })
            .disposed(by: disposeBag)

        scheduler.start()

        // Verify the expected changes
        XCTAssertEqual(boardObserver.events.count, 7)
    }

    func testHandleExtraTurn() {
        let playerObserver = scheduler.createObserver(Int.self)

        viewModel.playerObservable
            .subscribe(playerObserver)
            .disposed(by: disposeBag)

        // Simulate a move that results in an extra turn
        scheduler.createColdObservable([.next(10, 7)])
            .subscribe(onNext: { [weak self] index in
                self?.viewModel.playMove(at: index)
            })
            .disposed(by: disposeBag)
        
        scheduler.start()

        // Verify the expected changes
        XCTAssertEqual(playerObserver.events.count, 1) // One for the initial turn and one for the extra turn
        XCTAssertEqual(playerObserver.events.last?.value.element, 1) // Check if player changed correctly
    }

    func testPlayAgain() {
        let boardObserver = scheduler.createObserver([Int].self)
        let playerOneWarehouseObserver = scheduler.createObserver(Int.self)
        let playerTwoWarehouseObserver = scheduler.createObserver(Int.self)

        viewModel.boardObservable
            .subscribe(boardObserver)
            .disposed(by: disposeBag)

        viewModel.playerOneWarehouseObservable
            .subscribe(playerOneWarehouseObserver)
            .disposed(by: disposeBag)

        viewModel.playerTwoWarehouseObservable
            .subscribe(playerTwoWarehouseObserver)
            .disposed(by: disposeBag)

        // Simulate playing again
        scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] index in
                self?.viewModel.playAgain()
            })
            .disposed(by: disposeBag)

        scheduler.start()

        // Verify the expected changes
        XCTAssertEqual(boardObserver.events.count, 2)
        XCTAssertEqual(playerOneWarehouseObserver.events.count, 2)
        XCTAssertEqual(playerTwoWarehouseObserver.events.count, 2)
        XCTAssertEqual(viewModel.remainingTurn, 16)
    }
}
