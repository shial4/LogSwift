//
//  DateFormatterExtension.swift
//  SLLog
//
//  Created by Shial on 4/10/17.
//

import Foundation

public typealias Occurrence = (file: String, line: UInt)

public protocol LogProvider {}

extension LogProvider {
    public func send(level: SLLog.LogType, spot: Occurrence, message: @autoclosure () -> Any) {
        SLLog.send(level: level, spot: spot, message: message)
    }
}

public protocol LogHandler {
    func handle(log: String, level: SLLog.LogType, spot: Occurrence, message: Any)
}

public class SLLog {
    public private(set) static var providers: [LogProvider] = []
    public private(set) static var targets: [LogHandler] = []
    public private(set) static var dateFormat: DateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                                                                             timeZone: "UTC",
                                                                             locale: "en_US_POSIX")
    
    fileprivate class func send(level: SLLog.LogType, spot: Occurrence, message: @autoclosure () -> Any) {
        let object = message()
        let log: String = "\(dateFormat.string(from: Date())) \(level) \(spot.file.split(separator: "/").last ?? ""):\(spot.line) - \(object)"
        targets.forEach { $0.handle(log:log, level: level, spot: spot, message: object) }
    }
    
    public class func addHandler(_ target: LogHandler...) {
        self.targets.append(contentsOf: target)
    }
    
    public class func clearHandlers() {
        self.targets.removeAll()
    }
    
    public class func addProvider(_ providers: LogProvider...) {
        self.providers.append(contentsOf: providers)
    }
    
    public class func clearProviders() {
        self.providers.removeAll()
    }
}

public extension SLLog {
    public enum LogType: Int, CustomStringConvertible {
        public var description: String {
            switch self {
            case .verbose:
                return "[VERBOSE]"
            case .info:
                return "[INFO]"
            case .debug:
                return "[DEBUG]"
            case .warning:
                return "[WARNING]"
            case .error:
                return "[ERROR]"
            }
        }
        
        case verbose = 0
        case info = 1
        case debug = 2
        case warning = 3
        case error = 4
    }
}

public final class Log {
    public class func v(_ message: @autoclosure () -> Any, _ file: String = #file, _ line: UInt = #line) {
        SLLog.send(level: .verbose, spot: (file, line), message: message)
    }
    
    public class func i(_ message: @autoclosure () -> Any, _ file: String = #file, _ line: UInt = #line) {
        SLLog.send(level: .info, spot: (file, line), message: message)
    }
    
    public class func d(_ message: @autoclosure () -> Any, _ file: String = #file, _ line: UInt = #line) {
        SLLog.send(level: .debug, spot: (file, line), message: message)
    }
    
    public class func w(_ message: @autoclosure () -> Any, _ file: String = #file, _ line: UInt = #line) {
        SLLog.send(level: .warning, spot: (file, line), message: message)
    }
    
    public class func e(_ message: @autoclosure () -> Any, _ file: String = #file, _ line: UInt = #line) {
        SLLog.send(level: .error, spot: (file, line), message: message)
    }
}
