# SLLog

<p align="center">
<a href="http://swift.org">
<img src="https://img.shields.io/badge/Swift-4.0-brightgreen.svg" alt="Language" />
</a>
<a href="https://raw.githubusercontent.com/shial4/SLLog/master/LICENSE">
<img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License" />
</a>
<a href="https://travis-ci.org/shial4/SLLog">
<img src="https://travis-ci.org/shial4/SLLog.svg?branch=master" alt="TravisCI" />
</a>
<a href="https://codebeat.co/projects/github-com-shial4-sllog-master">
<img src="https://codebeat.co/badges/bafbee05-9197-4625-84f8-1e022e3a6dad" alt="Codebeat" />
</a>
</p>

SLLog is a simple swift loger yet elegant. Allows you to log to content, file or your cutom target.


## 🔧 Installation

Add the following dependency to your `Package.swift` file:
```swift
.package(url: "https://github.com/shial4/SLLog.git", from: "0.0.1"),
```

## 💊 Usage

### 1 Import

On top of your file import:
```swift
import SLLog
```

### 2 Initialize

Setup SLLoger
```swift
SLLog.addTarget(try! SLLogFile(path))
```
Or console handler
```swift
SLLog.addTarget(SLLogConsole())
```
or both
```swift
SLLog.addTarget(SLLogConsole(), try! SLLogFile(path))
```
You can create your custom log handler. Simply correspond to `LogHandler` protocol.

```swift
public class MyClass: LogHandler {
    open func handle(log: String, level: SLLog.LogType, file: String, line: UInt, message: Any) {
        //Do your stuff with log.
    }
}
```

### 3 Usage

Log your entries.
```swift
SLLog.log(.debug, "ABC")
SLLog.log(.warning, "#%^$&@")
SLLog.log(.error, "1233")
```
Log Any object.
```swift
SLLog.log(.debug, 11)
SLLog.log(.warning, Date())
SLLog.log(.error, Foo())
```

## ⭐ Contributing

Be welcome to contribute to this project! :)

## ❓ Questions

You can create an issue on GitHub.

## 📝 License

This project was released under the [MIT](LICENSE) license.

