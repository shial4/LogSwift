//
//  SLLogFileTests.swift
//  SLLogTests
//
//  Created by Shial on 4/10/17.
//

import Foundation

import XCTest
@testable import SLLog

class SLLogFileTests: XCTestCase {
    static var allTests = [
        ("testFileExists", testFileExists),
        ("testFileContent",testFileContent),
        ("testFileContentMessage",testFileContentMessage),
        ("testFileRemove",testFileRemove),
    ]
    
    lazy var path: String = {
        var file = #file
        return file.replacingOccurrences(of: "/SLLogFileTests.swift", with: "")
    }()
    private let dateFormat: DateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd",
                                                          timeZone: "UTC",
                                                          locale: "en_US_POSIX")
    
    override func tearDown() {
        super.tearDown()
        if FileManager.default.fileExists(atPath: (path + "/sllogs")) {
            do {
                try FileManager.default.removeItem(atPath: (path + "/sllogs"))
            } catch let error {
                print(error)
            }
        }
    }
    
    func testFileExists() {
        let exp = expectation(description: "logToFile")
        
        SLLog.addTarget(try! SLLogFile(path))
        SLLog.log(.warning, "#%^$&@")
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
            if FileManager.default.fileExists(atPath: "\(self.path)/sllogs/\(self.dateFormat.string(from: Date())).log") {
                exp.fulfill()
            } else {
                XCTFail()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFileContent() {
        let exp = expectation(description: "logToFile")
        
        SLLog.addTarget(try! SLLogFile(path))
        SLLog.log(.debug, "ABC")
        SLLog.log(.warning, "#%^$&@")
        SLLog.log(.error, "1233")
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 6) {
            let filePath = "\(self.path)/sllogs/\(self.dateFormat.string(from: Date())).log"
            if FileManager.default.fileExists(atPath: filePath) {
                if let fileHandle = FileHandle(forReadingAtPath: filePath) {
                    let data = fileHandle.readDataToEndOfFile()
                    fileHandle.closeFile()
                    if let content = String(data: data, encoding: .utf8),
                        content.components(separatedBy: .newlines).count == 3 {
                        exp.fulfill()
                    } else {
                        XCTFail("incorrect logs number")
                    }
                } else {
                    XCTFail("error creating file handle")
                }
            } else {
                XCTFail("file does not exists")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFileContentMessage() {
        let exp = expectation(description: "logToFile")
        
        SLLog.addTarget(try! SLLogFile(path))
        SLLog.log(.warning, "#%^$&@")
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 6) {
            let filePath = "\(self.path)/sllogs/\(self.dateFormat.string(from: Date())).log"
            if FileManager.default.fileExists(atPath: filePath) {
                if let fileHandle = FileHandle(forReadingAtPath: filePath) {
                    let data = fileHandle.readDataToEndOfFile()
                    fileHandle.closeFile()
                    if let content = String(data: data, encoding: .utf8),
                        content.components(separatedBy: " ").last == "#%^$&@" {
                        exp.fulfill()
                    } else {
                        XCTFail("incorrect message value")
                    }
                } else {
                    XCTFail("error creating file handle")
                }
            } else {
                XCTFail("file does not exists")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFileRemove() {
        let exp = expectation(description: "logToFile")
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: "\(path)/sllogs", isDirectory: &isDirectory) {
            try? FileManager.default.createDirectory(atPath: "\(path)/sllogs", withIntermediateDirectories: false, attributes: nil)
        }
        
        if let _ = try? "x".write(toFile: "\(self.path)/sllogs/1990-01-01.log", atomically: true, encoding: .utf8) {
            XCTAssertTrue(true)
        } else {
            XCTFail("Error write to file")
        }
        
        if let _ = try? "x".write(toFile: "\(self.path)/sllogs/1991-01-01.log", atomically: true, encoding: .utf8) {
            XCTAssertTrue(true)
        } else {
            XCTFail("Error write to file")
        }
        
        if let _ = try? "x".write(toFile: "\(self.path)/sllogs/1992-01-01.log", atomically: true, encoding: .utf8) {
            XCTAssertTrue(true)
        } else {
            XCTFail("Error write to file")
        }
        
        if let _ = try? "x".write(toFile: "\(self.path)/sllogs/1993-01-01.log", atomically: true, encoding: .utf8) {
            XCTAssertTrue(true)
        } else {
            XCTFail("Error write to file")
        }
        
        if let _ = try? "x".write(toFile: "\(self.path)/sllogs/1994-01-01.log", atomically: true, encoding: .utf8) {
            XCTAssertTrue(true)
        } else {
            XCTFail("Error write to file")
        }
        
        if let _ = try? "x".write(toFile: "\(self.path)/sllogs/1995-01-01.log", atomically: true, encoding: .utf8) {
            XCTAssertTrue(true)
        } else {
            XCTFail("Error write to file")
        }
        
        XCTAssert((try? FileManager.default.contentsOfDirectory(atPath: "\(self.path)/sllogs/"))?.count ?? 0 > 3)
        SLLog.addTarget(try! SLLogFile(path))
        SLLog.log(.warning, "test")
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 4) {
            let count = (try? FileManager.default.contentsOfDirectory(atPath: "\(self.path)/sllogs/"))?.count ?? 0
            XCTAssertTrue(count == 4, "count: \(count)")
            exp.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
