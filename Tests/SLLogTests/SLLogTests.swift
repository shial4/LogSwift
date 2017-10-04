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
    
    func testLogs() {
        SLLog.addTarget(SLLogConsole())
        XCTAssert(true)
    }
}
