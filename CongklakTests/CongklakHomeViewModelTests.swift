//
//  CongklakHomeViewModelTests.swift
//  CongklakTests
//
//  Created by Michael Iskandar on 25/01/24.
//

import XCTest

@testable import Congklak

class CongklakHomeViewModelTests: XCTestCase {
    
    var viewModel: CongklakHomeViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CongklakHomeViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
        
    func testGoToGame() {
        let mockRouter = MockRouter()
        viewModel.router = mockRouter
        
        // Call the goToGame method
        viewModel.goToGame(from: UIViewController())
        
        XCTAssertTrue(mockRouter.goToGameCalled, "goToGame called")
    }
}

fileprivate class MockRouter: CongklakRouting {
    var goToGameCalled = false
    
    func goToGame(from viewController: UIViewController) {
        goToGameCalled = true
    }
}
