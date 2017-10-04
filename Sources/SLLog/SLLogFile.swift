//
//  SLLogFile.swift
//  SLLog
//
//  Created by Shial on 3/10/17.
//

import Foundation
import Dispatch

public class SLLogFile {
    private let directoryBasename = "/sllogs"
    private let fileExtension = ".log"
    private let dateFormat: DateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd",
                                                          timeZone: "UTC",
                                                          locale: "en_US_POSIX")
    private let maxFilesCount: Int
    private let directory: String
    private var fileHandle: FileHandle?
    public private(set) var files: [String]
    private var filePath: String? {
        trimFilesNumber()
        let file: String = "\(path)/\(dateFormat.string(from: Date()))\(fileExtension)"
        return file
    }
    private var path: String {
        return directory + directoryBasename
    }
    private lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    public init(_ directory: String, maxFilesCount count: Int = 3) throws {
        try SLLogFile.verifyDirectory(directory + directoryBasename)
        self.directory = directory
        self.maxFilesCount = count
        files = try FileManager.default.contentsOfDirectory(atPath: directory + directoryBasename).sorted()
    }
    
    deinit {
        fileHandle?.closeFile()
        queue.cancelAllOperations()
    }
    
    public func addEntry(_ log: String) {
        queue.addOperation { [weak self] in
            guard let path = self?.filePath else { return }
            if FileManager.default.fileExists(atPath: path),
                let data = "\n\(log)".data(using: .utf8) {
                if self?.fileHandle == nil {
                    self?.fileHandle = FileHandle(forWritingAtPath: path)
                }
                _ = self?.fileHandle?.seekToEndOfFile()
                self?.fileHandle?.write(data)
            } else if let _ = try? "\(log)".write(toFile: path, atomically: true, encoding: .utf8) {
                if let file = path.components(separatedBy: "/").last {
                    self?.files.append(file)
                }
                self?.fileHandle?.closeFile()
                self?.fileHandle = FileHandle(forWritingAtPath: path)
            }
        }
    }
    
    private class func verifyDirectory(_ path: String) throws {
        if !FileManager.default.fileExists(atPath: path) {
            try SLLogFile.createDirectory(path)
        }
    }
    
    private class func createDirectory(_ path: String) throws {
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
    }
    
    private func trimFilesNumber() {
        let oversize = files.count - maxFilesCount
        guard oversize > 0 else {
            return
        }
        let oldFiles = Array(files[..<oversize])
        files.removeFirst(oversize)
        removeFile(oldFiles)
    }
    
    private func removeFile(_ files: [String]) {
        DispatchQueue.global().async {
            files.forEach { [weak self] in
                guard let path = self?.path else { return }
                let file: String = "\(path)/\($0)"
                if FileManager.default.fileExists(atPath: file) {
                    do {
                        try FileManager.default.removeItem(atPath: file)
                    } catch let error {
                        print(error)
                    }
                }
            }
        }
    }
}

extension SLLogFile: LogHandler {
    open func handle(log: String, level: SLLog.LogType, spot: Occurrence, message: Any) {
        addEntry(log)
    }
}
