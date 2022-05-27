//
//  LoginPresenterTests.swift
//  WatchLater-Kirillov_UnitTests
//
//  Created by Stepan Kirillov on 5/27/22.
//

import XCTest
@testable import WatchLater_Kirillov_Dev

class LoginPresenterTests: XCTestCase {

    private var presenter: LoginPresenter!
    private var controllerSpy: LoginViewControllerSpy!
    private lazy var expectations = expectation(description: "expectation")
    
    override func setUpWithError() throws {
        controllerSpy = LoginViewControllerSpy()
        presenter = LoginPresenter(viewController: controllerSpy)
    }

    override func tearDownWithError() throws {
        controllerSpy = nil
        presenter = nil
    }

    func testPresenterSucceedState() throws {
        let state = LoginResponseState.success
        
        presenter.procedLoginResult(state: state)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            self.expectations.fulfill()
        }
        wait(for: [expectations], timeout: 1)
        XCTAssertEqual(self.controllerSpy.isPresentFavouriteViewController, true)
    }
    
    func testPresenterFailedState() throws {
        let state = LoginResponseState.failure("ad", nil)
        
        presenter.procedLoginResult(state: state)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            self.expectations.fulfill()
        }
        wait(for: [expectations], timeout: 1)
        XCTAssertEqual(controllerSpy.isLoginFailedStateCalled, true)
    }
    
    func testPresentFailedStateWhenFailFunctionCalled() throws {
        presenter.failedToLogin(message: "adf")
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            self.expectations.fulfill()
        }
        wait(for: [expectations], timeout: 1)
        XCTAssertEqual(controllerSpy.isLoginFailedStateCalled, true)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
