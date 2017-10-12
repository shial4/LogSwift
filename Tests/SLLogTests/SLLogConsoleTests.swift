//
//  SLLogConsoleTests.swift
//  SLLogTests
//
//  Created by Shial on 5/10/17.
//

import XCTest
import Foundation
@testable import SLLog

class SLLogConsoleTests: XCTestCase {
    static var allTests = [
        ("testLogs", testLogs),
        ]
    
    func testLogs() {
        SLLog.addHandler(SLLogConsole(isTerminal: false))
        SLLog.v(123)
        SLLog.i("ABC")
        SLLog.d("@$#!^%")
        SLLog.w(Date())
        SLLog.e([0.1,1,"A",Date()])
        XCTAssert(true)
    }
}
