//
//  SLLogConsole.swift
//  SLLog
//
//  Created by Shial on 3/10/17.
//

import Foundation

public class SLLogConsole: LogHandler {
    public init() {}
    
    open func handle(log: String, level: SLLog.LogType, spot: Occurrence, message: Any) {
        print(log)
    }
}
