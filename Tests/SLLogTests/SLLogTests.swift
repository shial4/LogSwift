//
//  SLLogTests.swift
//  SLLogTests
//
//  Created by Shial on 4/10/17.
//

import XCTest
@testable import SLLog

class SLLogTests: XCTestCase {
    static var allTests = [
        ("testLogs", testLogs),
        ]
    
    override func tearDown() {
        super.tearDown()
        SLLog.clearHandlers()
    }
    
    func testLogs() {
        SLLog.addHandler(SLLogConsole())
        XCTAssert(true)
    }
}
