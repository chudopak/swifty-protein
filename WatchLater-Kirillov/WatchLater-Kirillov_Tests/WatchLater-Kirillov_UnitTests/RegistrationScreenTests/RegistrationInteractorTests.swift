//
//  RegistrationInteractorTests.swift
//  WatchLater-Kirillov_UnitTests
//
//  Created by Stepan Kirillov on 5/27/22.
//

import XCTest
@testable import WatchLater_Kirillov_Dev

class RegistrationInteractorTests: XCTestCase {

    private var interactor: RegistrationInteractor!
    private var serviceSpy: RegistrationServiceSpy!
    private var presenterSpy: RegistrationPresenterSpy!
    
    override func setUpWithError() throws {
        serviceSpy = RegistrationServiceSpy()
        presenterSpy = RegistrationPresenterSpy()
        interactor = RegistrationInteractor(presenter: presenterSpy, networkService: serviceSpy)
    }

    override func tearDownWithError() throws {
        serviceSpy = nil
        presenterSpy = nil
        interactor = nil
    }

    func testInteractorEmptyData() throws {
        let data = RegistrationData(email: "", password: "", repeatPassword: "")
        
        interactor.register(data: data)
        
        XCTAssertEqual(presenterSpy.isShowFailedState, true)
        XCTAssertEqual(serviceSpy.isCalled, false)
    }
    
    func testInteractorEmptyPassword() throws {
        let data = RegistrationData(email: "asdf@mail.ru", password: "", repeatPassword: "asfd")
        
        interactor.register(data: data)
        
        XCTAssertEqual(presenterSpy.isShowFailedState, true)
        XCTAssertEqual(serviceSpy.isCalled, false)
    }
    
    func testInteractorEmptyRepeatPassword() throws {
        let data = RegistrationData(email: "asdf@mail.ru", password: "asfd", repeatPassword: "")
        
        interactor.register(data: data)
        
        XCTAssertEqual(presenterSpy.isShowFailedState, true)
        XCTAssertEqual(serviceSpy.isCalled, false)
    }
    
    func testInteractorEmptyEmail() throws {
        let data = RegistrationData(email: "", password: "asdf", repeatPassword: "sadf")
        
        interactor.register(data: data)
        
        XCTAssertEqual(presenterSpy.isShowFailedState, true)
        XCTAssertEqual(serviceSpy.isCalled, false)
    }
    
    func testInteractorPasswordsDoesNotMatch() throws {
        let data = RegistrationData(email: "asdf@mail.ru", password: "asdf", repeatPassword: "sadf")
        
        interactor.register(data: data)
        
        XCTAssertEqual(presenterSpy.isShowFailedState, true)
        XCTAssertEqual(serviceSpy.isCalled, false)
    }
    
    func testInteractorProceedRegistrationResult() throws {
        let data = RegistrationData(email: "asdf@mail.ru", password: "asdf", repeatPassword: "asdf")
        
        interactor.register(data: data)
        
        XCTAssertEqual(presenterSpy.isProceedRegistrationResult, true)
        XCTAssertEqual(serviceSpy.isCalled, true)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
