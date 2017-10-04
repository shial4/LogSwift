//
//  DateFormatterExtension.swift
//  SLLog
//
//  Created by Shial on 4/10/17.
//

import Foundation

public protocol LogHandler {
    func handle(log: String, level: SLLog.LogType, file: String, line: UInt, message: Any)
}

public class SLLog {
    private static var targets: [LogHandler] = []
    private static var dateFormat: DateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                                                                 timeZone: "UTC",
                                                                 locale: "en_US_POSIX")
    
    private class func send(level: SLLog.LogType, file: String, line: UInt, message: @autoclosure () -> Any) {
        let object = message()
        let log: String = "\(dateFormat.string(from: Date())) \(level) \(file.split(separator: "/").last ?? ""):\(line) \(object)"
        targets.forEach { $0.handle(log:log, level: level, file: file, line: line, message: object) }
    }
    
    public class func addTarget(_ target: LogHandler...) {
        targets.append(contentsOf: target)
    }
}

public extension SLLog {
    public enum LogType: Int, CustomStringConvertible {
        public var description: String {
            switch self {
            case .debug:
                return "[DEBUG]"
            case .warning:
                return "[WARNING]"
            case .error:
                return "[ERROR]"
            }
        }
        
        case debug = 0
        case warning = 1
        case error = 2
    }
    
    public class func debug(_ message: @autoclosure () -> Any, _ file: String = #file, _ line: UInt = #line) {
        send(level: .debug, file: file, line: line, message: message)
    }
    
    public class func warning(_ message: @autoclosure () -> Any, _ file: String = #file, _ line: UInt = #line) {
        send(level: .warning, file: file, line: line, message: message)
    }
    
    public class func error(_ message: @autoclosure () -> Any, _ file: String = #file, _ line: UInt = #line) {
        send(level: .error, file: file, line: line, message: message)
    }
}
