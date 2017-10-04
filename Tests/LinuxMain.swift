import XCTest
@testable import SLLogTests

XCTMain([
    testCase(SLLogTests.allTests),
    testCase(SLLogFileTests.allTests),
    testCase(SLLogConsoleTests.allTests),
])
