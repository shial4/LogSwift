//
//  DateFormatterExtension.swift
//  SLLog
//
//  Created by Shial on 4/10/17.
//

import Foundation

public typealias Occurrence = (file: String, line: UInt, UTC: String)

public protocol LogProvider {}

extension LogProvider {
    public func send(message: @autoclosure () -> Any, level: SLLog.LogType, occurrence: Occurrence) {
        SLLog.send(message: message(), level: level, occurrence: occurrence)
    }
}

public protocol LogHandler {
    func handle(message: Any, level: SLLog.LogType, occurrence: Occurrence)
}

public class SLLog {
    public private(set) static var providers: [LogProvider] = []
    public private(set) static var targets: [LogHandler] = []
    public private(set) static var dateFormat: DateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                                                                             timeZone: "UTC",
                                                                             locale: "en_US_POSIX")
    
    class func send(message: @autoclosure () -> Any, level: SLLog.LogType, occurrence: Occurrence) {
        let object = message()
        targets.forEach { $0.handle(message: object, level: level, occurrence: occurrence) }
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
    enum LogType: Int, CustomStringConvertible {
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
