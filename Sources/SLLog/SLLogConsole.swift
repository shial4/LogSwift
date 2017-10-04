//
//  SLLogConsole.swift
//  SLLog
//
//  Created by Shial on 3/10/17.
//

import Foundation

public class SLLogConsole: LogHandler {
    open func handle(log: String, level: SLLog.LogType, file: String, line: UInt, message: Any) {
        print(log)
    }
}
