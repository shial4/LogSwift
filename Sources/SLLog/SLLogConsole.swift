//
//  SLLogConsole.swift
//  SLLog
//
//  Created by Shial on 3/10/17.
//

import Foundation

public class TerminalColor {
    final class var `default`: String { return "39m" }
    final class var black: String { return "30m" }
    final class var white: String { return "97m" }
    final class func custom(_ value: String) -> String { return value }
}

extension TerminalColor {
    public final class var red: String { return "31m" }
    public final class var green: String { return "32m" }
    public final class var yellow: String { return "33m" }
    public final class var blue: String { return "34m" }
    public final class var magenta: String { return "35m" }
    public final class var cyan: String { return "36m" }
    public final class var lightGray: String { return "37m" }
    public final class var darkGray: String { return "90m" }
    public final class var lightRed: String { return "91m" }
    public final class var lightGreen: String { return "92m" }
    public final class var lightYellow: String { return "93m" }
    public final class var lightBlue: String { return "94m" }
    public final class var lightMagenta: String { return "95m" }
    public final class var lightCyan: String { return "96m" }
}

public struct LogColor {
    public init(_ terminal: String, _ console: String) {
        self.terminalColor = terminal
        self.consolColor = console
    }
    var consolColor: String
    var terminalColor: String
}

public class SLLogConsole: LogHandler {
    public struct Configuration {
        public init() {}
        public var mode: (isDebug: Bool, isTerminal: Bool) = {
            #if Xcode
                return (true, false)
            #else
                return (true, true)
            #endif
        }()
        public var minProductionLogType: UInt = 3
        public var format: (logFormat: String, dateFormat: String?) = (":d :t :f::l :m", nil)
        public var logColors: [SLLog.LogType:LogColor] = [
            SLLog.LogType.verbose:LogColor(TerminalColor.lightGray, "☑️"),
            SLLog.LogType.info:LogColor(TerminalColor.lightCyan, "Ⓜ️"),
            SLLog.LogType.debug:LogColor(TerminalColor.lightGreen, "✅"),
            SLLog.LogType.warning:LogColor(TerminalColor.lightYellow, "⚠️"),
            SLLog.LogType.error:LogColor(TerminalColor.lightRed, "⛔️"),
            ]
    }

    public init(_ config: Configuration = Configuration()) {
        self.mode = config.mode
        self.minProductionLogType = config.minProductionLogType
        self.logFormat = config.format.logFormat
        self.logColors = config.logColors
        if let format = config.format.dateFormat {
            self.formattert.dateFormat = format
        }
    }
    
    public var mode: (isDebug: Bool, isTerminal: Bool)
    public var minProductionLogType: UInt
    public var logFormat: String
    public var logColors: [SLLog.LogType:LogColor]
    
    private var formattert: DateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                                                                 timeZone: "UTC",
                                                                 locale: "en_US_POSIX")
    
    private func applayColors(_ color: LogColor?, text: String) -> String {
        guard let c = color else {
            return text
        }
        if mode.isTerminal {
            return "\u{001b}[" + c.terminalColor + text + "\u{001b}[0m"
        } else {
            return "\(c.consolColor) " + text
        }
    }
    
    open func handle(log: String, level: SLLog.LogType, spot: Occurrence, message: Any) {
        guard mode.isDebug || level.rawValue >= minProductionLogType else { return }
        print(logFormat.replacingOccurrences(of: ":d", with: formattert.string(from: Date()))
        .replacingOccurrences(of: ":t", with: applayColors(logColors[level], text: "\(level)"))
        .replacingOccurrences(of: ":f", with: "\(spot.file.split(separator: "/").last ?? "")")
        .replacingOccurrences(of: ":l", with: "\(spot.line)")
        .replacingOccurrences(of: ":m", with: "\(message)"))
    }
}

extension SLLogConsole {
    public convenience init(isTerminal: Bool) {
        self.init()
        self.mode.isTerminal = isTerminal
    }
    public convenience init(isDebug: Bool) {
        self.init()
        self.mode.isDebug = isDebug
    }
    public convenience init(isDebug: Bool, isTerminal: Bool) {
        self.init()
        self.mode = (isDebug, isTerminal)
    }
}
