//
//  Log.swift
//  SLLog
//
//  Created by Shial on 30/7/19.
//

import Foundation

public final class Log {
    public class func v(_ message: @autoclosure () -> Any, _ file: String = #file, _ line: UInt = #line) {
        SLLog.send(message: message(), level: .verbose, occurrence: (file, line, SLLog.dateFormat.string(from: Date())))
    }
    
    public class func i(_ message: @autoclosure () -> Any, _ file: String = #file, _ line: UInt = #line) {
        SLLog.send(message: message(), level: .info, occurrence: (file, line, SLLog.dateFormat.string(from: Date())))
    }
    
    public class func d(_ message: @autoclosure () -> Any, _ file: String = #file, _ line: UInt = #line) {
        SLLog.send(message: message(), level: .debug, occurrence: (file, line, SLLog.dateFormat.string(from: Date())))
    }
    
    public class func w(_ message: @autoclosure () -> Any, _ file: String = #file, _ line: UInt = #line) {
        SLLog.send(message: message(), level: .warning, occurrence: (file, line, SLLog.dateFormat.string(from: Date())))
    }
    
    public class func e(_ message: @autoclosure () -> Any, _ file: String = #file, _ line: UInt = #line) {
        SLLog.send(message: message(), level: .error, occurrence: (file, line, SLLog.dateFormat.string(from: Date())))
    }
}
