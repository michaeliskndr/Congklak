//
//  CongklakViewModelTests.swift
//  CongklakTests
//
//  Created by Michael Iskandar on 22/01/24.
//

import XCTest
@testable import Congklak

class CongklakViewModelTests: XCTestCase {

    func testPlayMove() {
        let viewModel = CongklakViewModel()

        // Test a valid move
        XCTAssertTrue(viewModel.playMove(at: 0))
        XCTAssertEqual(viewModel.getBoard(), [0, 8, 8, 8, 8, 8, 8, 7, 7, 7, 7, 7, 7, 7])
        XCTAssertEqual(viewModel.getCurrentPlayer(), 1)

        // Test an invalid move
        XCTAssertFalse(viewModel.playMove(at: 7))
        XCTAssertEqual(viewModel.getBoard(), [0, 8, 8, 8, 8, 8, 8, 7, 7, 7, 7, 7, 7, 7])
        XCTAssertEqual(viewModel.getCurrentPlayer(), 1)

        // Test another valid move
        XCTAssertTrue(viewModel.playMove(at: 1))
        XCTAssertEqual(viewModel.getBoard(), [0, 8, 8, 8, 8, 8, 8, 7, 7, 7, 7, 7, 7, 7])
        XCTAssertEqual(viewModel.getCurrentPlayer(), 1)
    }

    func testCaptureStones() {
        let viewModel = CongklakViewModel()

        // Set up the board for a capture scenario
        viewModel.playMove(at: 0)
        viewModel.playMove(at: 1)
        viewModel.playMove(at: 2)
        viewModel.playMove(at: 3)

        // Capture stones
        viewModel.captureStones(at: 3)

        // Check if stones are captured
        XCTAssertEqual(viewModel.getBoard(), [0, 0, 9, 9, 9, 9, 9, 7, 7, 7, 7, 7, 8, 8])
    }

    func testHandleExtraTurn() {
        let viewModel = CongklakViewModel()

        // Handle extra turn for player 1
        viewModel.handleExtraTurn(at: 7)
        XCTAssertEqual(viewModel.getCurrentPlayer(), 1)

        // Handle extra turn for player 2
        viewModel.handleExtraTurn(at: 3)
        XCTAssertEqual(viewModel.getCurrentPlayer(), 2)
    }

    func testIsGameNotFinished() {
        let viewModel = CongklakViewModel()
        
        _ = viewModel.playMove(at: 0)
        XCTAssertFalse(viewModel.isGameFinished())
    }
    
    func testIsGameFinished() {
        let viewModel = CongklakViewModel()
        
        while viewModel.remainingTurn > 0 {
            let player = viewModel.getCurrentPlayer()
            _ = viewModel.playMove(at: player == 1 ? 1 : 8)
        }

        XCTAssertTrue(viewModel.isGameFinished())
    }
}
