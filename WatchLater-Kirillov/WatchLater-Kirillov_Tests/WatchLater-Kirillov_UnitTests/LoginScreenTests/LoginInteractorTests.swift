//
//  LoginInteractorTests.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/27/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import XCTest
@testable import WatchLater_Kirillov_Dev

class LoginInteractorTests: XCTestCase {

    private var loginInteractor: LoginInteractor!
    private var loginPresenterSpy: LoginPresenterSpy!
    private var loginServiceSpy: LoginServiceLoginSucceedSpy!
    
    override func setUpWithError() throws {
        loginServiceSpy = LoginServiceLoginSucceedSpy()
        loginPresenterSpy = LoginPresenterSpy()
        loginInteractor = LoginInteractor(presenter: loginPresenterSpy, networkService: loginServiceSpy)
    }

    override func tearDownWithError() throws {
        loginServiceSpy = nil
        loginPresenterSpy = nil
        loginInteractor = nil
    }

    func testInteractorEmptyData() throws {
        let data = LoginData(email: "", password: "")
        
        loginInteractor.login(data: data)
        
        XCTAssertEqual(loginPresenterSpy.success, false)
        XCTAssertEqual(loginServiceSpy.isCalled, false)
    }
    
    func testInteractorEmptyPassword() throws {
        let data = LoginData(email: "ad", password: "")
        
        loginInteractor.login(data: data)
        
        XCTAssertEqual(loginPresenterSpy.success, false)
        XCTAssertEqual(loginServiceSpy.isCalled, false)
    }
    
    func testInteractorEmptyEmail() throws {
        let data = LoginData(email: "", password: "ad")
        
        loginInteractor.login(data: data)
        
        XCTAssertEqual(loginPresenterSpy.success, false)
        XCTAssertEqual(loginServiceSpy.isCalled, false)
    }
    
    func testInteractorSuccessLogin() throws {
        let data = LoginData(email: "lala", password: "ad")
        
        loginInteractor.login(data: data)
        
        XCTAssertEqual(loginPresenterSpy.success, true)
        XCTAssertEqual(loginServiceSpy.isCalled, true)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
