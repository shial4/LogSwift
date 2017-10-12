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

SLLog is a simple yet elegant swift logger. Allows you to log content to file, console or your custom target.

```swift
1990-02-19T22:45:36.250Z [VERBOSE] MyFile.swift:19 - 123
1991-03-20T20:33:44.777Z [INFO] MyFile.swift:20 - ABC
1992-04-21T09:53:51.021Z [DEBUG] MyFile.swift:21 - @$#!^%
1993-05-22T11:05:02.000Z [WARNING] MyFile.swift:22 - 2017-10-04 22:45:36 +0000
1994-06-23T15:13:00.146Z [ERROR] MyFile.swift:23 - [0.10000000000000001, 1, "A", 2017-10-04 09:55:36 +0000]
```

## 🔧 Installation

Add the following dependency to your `Package.swift` file:
```swift
.package(url: "https://github.com/shial4/SLLog.git", from: "0.0.1"),
```

## 💊 How To Start

### 1 Import

On top of your file import:
```swift
import SLLog
```

### 2 Initialize

Setup SLLoger
```swift
SLLog.addHandler(try! SLLogFile("path/to/directory"))
```
Or console handler
```swift
SLLog.addHandler(SLLogConsole())
```
or both
```swift
SLLog.addHandler(SLLogConsole(), try! SLLogFile(path))
```
You can create your custom log handler. Simply correspond to `LogHandler` protocol.

```swift
public class MyHandler: LogHandler {
    open func handle(log: String, level: SLLog.LogType, file: String, line: UInt, message: Any) {
        //Do your stuff with log.
    }
}
```
then add it to SLLog
```swift
SLLog.addHandler(MyHandler())
```

### 3 Usage

Log any information you need.
```swift
SLLog.d("ABC")
SLLog.w("#%^$&@")
SLLog.e("1233")
```
Any object.
```swift
SLLog.addHandler(SLLogConsole())
SLLog.v(123)
SLLog.i("ABC")
SLLog.d("@$#!^%")
SLLog.w(Date())
SLLog.e([0.1,1,"A",Date()])
```

## 4 SLLogConsole
Default console log:
```swift
isDebug: Bool = true,
isTerminal: Bool = false,
minProductionLogType: UInt = 3
logFormat: String = ":d :t :f::l :m",
dateFormat: String? = nil,
logColors: [SLLog.LogType:LogColor]? = nil
```
Override argument passing it in initializer to variate ConsoleLog
`SLLogConsole(isDebug: true, isTerminal: false)`
or
`SLLogConsole(isTerminal: false)`
and so on.
Use isTerminal property to choose between terminal or console settings.

By default logs are set for terminal.
log format `":d :t :f::l :m"` where
`:d` is replace in string to display date
`:t` is replaced by log type
`:f` is replaced by file name
`:l` is replaced by line number
`:m` is replaced by message object

Default date format used by logger is as follow `"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"`

To ged rid of default log colors pass empty disctionary in `logColors` or dictionary with your own definitions.
For more information about terminal color take a look: `https://misc.flogisoft.com/bash/tip_colors_and_formatting`
### LogColor
LogColor is defined as follow `init(_ terminal: String, _ console: String)`
For XCode console emoticons are used as collor.
```swift
SLLog.LogType.verbose:LogColor("37m", "☑️"),
SLLog.LogType.info:LogColor("34m", "Ⓜ️"),
SLLog.LogType.debug:LogColor("92m", "✅"),
SLLog.LogType.warning:LogColor("93mm", "⚠️"),
SLLog.LogType.error:LogColor("91m", "⛔️"),
```


## ⭐ Contributing

Be welcome to contribute to this project! :)

## ❓ Questions

You can create an issue on GitHub.

## 📝 License

This project was released under the [MIT](LICENSE) license.

