//
//  SLLogConsole.swift
//  SLLog
//
//  Created by Shial on 3/10/17.
//

import Foundation

public struct LogColor {
    public init(_ terminal: String, _ console: String) {
        self.terminalColor = terminal
        self.consolColor = console
    }
    var consolColor: String
    var terminalColor: String
}

public class SLLogConsole: LogHandler {
    public init(isDebug: Bool = true,
                isTerminal: Bool = false,
                minProductionLogType: UInt = 3,
                logFormat: String = ":d :t :f::l :m",
                dateFormat: String? = nil,
                logColors: [SLLog.LogType:LogColor]? = nil) {
        self.isDebug = isDebug
        self.isTerminal = isTerminal
        self.minProductionLogType = minProductionLogType
        self.logFormat = logFormat
        if let format = dateFormat {
            self.formattert.dateFormat = format
        }
        if let colors = logColors {
            self.logColors = colors
        }
    }
    
    public var isDebug: Bool
    public var minProductionLogType: UInt
    public var isTerminal: Bool
    public var logFormat: String
    public var logColors: [SLLog.LogType:LogColor] = [
        SLLog.LogType.verbose:LogColor("37m", "☑️"),
        SLLog.LogType.info:LogColor("34m", "Ⓜ️"),
        SLLog.LogType.debug:LogColor("92m", "✅"),
        SLLog.LogType.warning:LogColor("93mm", "⚠️"),
        SLLog.LogType.error:LogColor("91m", "⛔️"),
    ]
    
    private var formattert: DateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                                                                 timeZone: "UTC",
                                                                 locale: "en_US_POSIX")
    
    private func applayColors(_ color: LogColor?, text: String) -> String {
        guard let c = color else {
            return text
        }
        if isTerminal {
            return "\u{001b}[" + c.terminalColor + text + "\u{001b}[0m"
        } else {
            return "\(c.consolColor) " + text
        }
    }
    
    open func handle(log: String, level: SLLog.LogType, spot: Occurrence, message: Any) {
        guard isDebug || level.rawValue >= minProductionLogType else { return }
        print(logFormat.replacingOccurrences(of: ":d", with: formattert.string(from: Date()))
        .replacingOccurrences(of: ":t", with: applayColors(logColors[level], text: "\(level)"))
        .replacingOccurrences(of: ":f", with: "\(spot.file.split(separator: "/").last ?? "")")
        .replacingOccurrences(of: ":l", with: "\(spot.line)")
        .replacingOccurrences(of: ":m", with: "\(message)"))
    }
}
