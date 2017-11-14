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
        ("testTerminal", testTerminal),
        ]
    
    func testLogs() {
        SLLog.clearHandlers()
        SLLog.addHandler(SLLogConsole(isTerminal: false))
        Log.v(123)
        Log.i("ABC")
        Log.d("@$#!^%")
        Log.w(Date())
        Log.e([0.1,1,"A",Date()])
        XCTAssert(true)
    }
    
    func testTerminal() {
        SLLog.clearHandlers()
        SLLog.addHandler(SLLogConsole(isTerminal: true))
        Log.v(123)
        Log.i("ABC")
        Log.d("@$#!^%")
        Log.w(Date())
        Log.e([0.1,1,"A",Date()])
        XCTAssert(true)
    }
}
