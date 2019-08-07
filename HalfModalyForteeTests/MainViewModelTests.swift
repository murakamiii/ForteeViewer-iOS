//
//  MainViewModelTests.swift
//  HalfModalyForteeTests
//
//  Created by murakami Taichi on 2019/08/07.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import XCTest
import RxTest
import RxSwift
@testable import HalfModalyFortee

class MainViewModelTests: XCTestCase {
    let db = DisposeBag()
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func ThrowError(error: Error) throws {
        throw error
    }
    
    func test_timetableResponse() {
        let vm = MainViewModel(forteeAPI: ForteeAPIStub())
        vm.timetableResponse.subscribe(
            onNext: { contents in
                XCTAssertEqual(contents, [Content.stubTalk, Content.stubSlot])
            }
        ).disposed(by: db)
    }
    
    func test_errorResponse() {
        let vm = MainViewModel(forteeAPI: ForteeAPIStubError(errorValue: .network))
        vm.errorResponse.subscribe(
            onNext: { error in
                XCTAssertEqual(error, APIError.network)
            }
        ).disposed(by: db)
        
        let vm2 = MainViewModel(forteeAPI: ForteeAPIStubError(errorValue: .server))
        vm2.errorResponse.subscribe(
            onNext: { error in
                XCTAssertEqual(error, APIError.server)
            }
        ).disposed(by: db)
    }
}
