//
//  RegistrationPresenterTests.swift
//  WatchLater-Kirillov_UnitTests
//
//  Created by Stepan Kirillov on 5/27/22.
//

import XCTest
@testable import WatchLater_Kirillov_Dev

class RegistrationPresenterTests: XCTestCase {

    private var presenter: RegistrationPresenter!
    private var controllerSpy: RegistrationViewControllerSpy!
    private lazy var expectations = expectation(description: "expectation")
    
    override func setUpWithError() throws {
        controllerSpy = RegistrationViewControllerSpy()
        presenter = RegistrationPresenter(viewController: controllerSpy)
    }

    override func tearDownWithError() throws {
        controllerSpy = nil
        presenter = nil
    }

    func testPresenterSucceedState() throws {
        let state = RegistrationResponseState.success
        
        presenter.proceedRegistrationResult(state: state)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            self.expectations.fulfill()
        }
        wait(for: [expectations], timeout: 1)
        XCTAssertEqual(self.controllerSpy.isPresentThumbnailsViewControllerCalled, true)
    }
    
    func testPresenterFailedState() throws {
        let state = RegistrationResponseState.failure("adf", nil)
        
        presenter.proceedRegistrationResult(state: state)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            self.expectations.fulfill()
        }
        wait(for: [expectations], timeout: 1)
        XCTAssertEqual(controllerSpy.isRegistrationFailedStateCalled, true)
    }
    
    func testPresenterLoginFailedState() throws {
        let state = RegistrationResponseState.loginFailed
        
        presenter.proceedRegistrationResult(state: state)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            self.expectations.fulfill()
        }
        wait(for: [expectations], timeout: 1)
        XCTAssertEqual(controllerSpy.isPresentLoginAlertCalled, true)
    }
    
    func testPresentFailedStateWhenFailFunctionCalled() throws {
        presenter.showFailedState(message: "adf")
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            self.expectations.fulfill()
        }
        wait(for: [expectations], timeout: 1)
        XCTAssertEqual(controllerSpy.isRegistrationFailedStateCalled, true)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
