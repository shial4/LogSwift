//
//  SLLogFile.swift
//  SLLog
//
//  Created by Shial on 3/10/17.
//

import Foundation
import Dispatch

public class SLLogFile {
    struct LogObject: Codable {
        let d: String
        let t: Int
        let f: String?
        let l: UInt?
        let m: String
    }
    
    private static let comma = ",".data(using: .utf8)!
    private static let openArray = "[".data(using: .utf8)!
    private static let closeArray = "]".data(using: .utf8)!
    
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
    public final var path: String {
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
    
    public func addEntry(level: SLLog.LogType, occurrence: Occurrence, message: Any) {
        queue.addOperation { [weak self] in
            guard let strongSelf = self else { return }
            guard let path = strongSelf.filePath else { return }
            do {
                let data = try strongSelf.buildObject(message: message, level: level, occurrence: occurrence)
                if FileManager.default.fileExists(atPath: path) {
                    strongSelf.appendEntry(data, path: path)
                } else {
                    strongSelf.addFirstEntry(data, path: path)
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func addFirstEntry(_ data: Data, path: String) {
        if let file = path.components(separatedBy: "/").last {
            files.append(file)
        }
        FileManager.default.createFile(atPath: path, contents: SLLogFile.openArray + data + SLLogFile.comma + SLLogFile.closeArray)
        fileHandle?.closeFile()
        fileHandle = FileHandle(forWritingAtPath: path)
    }
    
    private func appendEntry(_ data: Data, path: String) {
        if fileHandle == nil {
            fileHandle = FileHandle(forWritingAtPath: path)
        }
        if let fileEnd = fileHandle?.seekToEndOfFile() {
            fileHandle?.seek(toFileOffset: fileEnd - 1)
        }
        fileHandle?.write(data + SLLogFile.comma + SLLogFile.closeArray)
    }
    
    private func buildObject(message: Any, level: SLLog.LogType, occurrence: Occurrence) throws -> Data {
        return try JSONEncoder().encode(LogObject(d: occurrence.UTC, t: level.rawValue, f: occurrence.file, l: occurrence.line, m: "\(message)"))
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
    public func handle(message: Any, level: SLLog.LogType, occurrence: Occurrence) {
        addEntry(level: level, occurrence: occurrence, message: message)
    }
}
