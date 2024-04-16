#!/usr/bin/swift
import Foundation

struct Frame: Decodable {
	let x: Int
	let y: Int
	let w: Int
	let h: Int

	var x2: Int {
		return x + w
	}

	var xm: Int {
		return (x + x2) / 2
	}

	var y2: Int {
		return y + h
	}

	var ym: Int {
		return (y + y2) / 2
	}
}

struct Display: Decodable {
	let id: Int
	let index: Int
	let frame: Frame
	let spaces: [Int]
}

struct Space: Decodable {
	enum CodingKeys: String, CodingKey {
		case id, index, display, windows
        case hasFocus = "has-focus"
		case isVisible = "is-visible"
    }

	let id: Int
	let index: Int
	let display: Int
	let windows: [Int]
	let hasFocus: Bool
	let isVisible: Bool
}

struct Window: Decodable {
	enum CodingKeys: String, CodingKey {
		case id, app, title, frame, display, space
        case hasFocus = "has-focus"
		case isVisible = "is-visible"
		case isMinimized = "is-minimized"
		case isHidden = "is-hidden"
    }
	
	let id: Int
	let app: String
	let title: String
	let frame: Frame
	let display: Int
	let space: Int
	let hasFocus: Bool
	let isVisible: Bool
	let isMinimized: Bool
	let isHidden: Bool
}

func sortBy(fields: [(Window) -> Int]) -> (Window, Window) -> Bool {
	return { (lhs: Window, rhs: Window) in 
		for field in fields {
			let l = field(lhs)
			let r = field(rhs)
			if (l != r) {
				return l < r
			}
		}
		
		return false
	}
}

let sortX = sortBy(fields: [
	{w in w.space},
	{w in w.frame.x},
	{w in w.frame.y},
	{w in w.id}
])

let sortX2 = sortBy(fields: [
	{w in w.space},
	{w in -w.frame.x2},
	{w in w.frame.y},
	{w in w.id}
])

let sortY = sortBy(fields: [
	{w in w.space},
	{w in w.frame.y},
	{w in w.frame.x},
	{w in w.id}
])

// Utility Functions {{{1
// Only works using relative path or full path
func compile() {
	let swiftc = Process()
	swiftc.executableURL = URL(fileURLWithPath: "/usr/bin/swiftc")
	let (script, binary) = CommandLine.arguments[0].contains("/glazed.swift") ? 
		(CommandLine.arguments[0], CommandLine.arguments[0].replacingOccurrences(of: "/glazed.swift", with: "/glazed")) :
		(CommandLine.arguments[0].replacingOccurrences(of: "/glazed", with: "/glazed.swift"), CommandLine.arguments[0])
	let args = ["-o", binary, script]
	swiftc.arguments = args

	let pipe = Pipe()
	swiftc.standardOutput = pipe
	swiftc.standardError = pipe
	try! swiftc.run()
	let data = try! pipe.fileHandleForReading.readToEnd()
	if let data = data, let s = String(data: data, encoding: .utf8) {
		print(s)
	} else {
		print("compiled successfully")
	}
}

func runYabai(arguments: [String]) -> Data? {
	let yabai = Process()
	yabai.executableURL = URL(fileURLWithPath: "/usr/local/bin/yabai")
	yabai.arguments = arguments

	let pipe = Pipe()
	yabai.standardOutput = pipe

	try! yabai.run()
	let data = try! pipe.fileHandleForReading.readToEnd()
	return data
}

func open(_ uri: String) {
	let o = Process()
	o.executableURL = URL(fileURLWithPath: "/usr/bin/open")
	o.arguments = ["-g", uri]

	
	let pipe = Pipe()
	o.standardOutput = pipe
	o.standardError = pipe
	try! o.run()
	let data = try! pipe.fileHandleForReading.readToEnd()
	if let data = data, let s = String(data: data, encoding: .utf8) {
		print(s)
	} else {
		print("opened successfully")
	}
}

enum RectangleEvent: String {
	case action = "execute-action"
	case layout = "execute-layout"
}

func openRectangle(event: RectangleEvent, id: String) {
	open("rectangle-pro://\(event.rawValue)?name=\(id)")
}

func getDisplays() -> [Display] {
	let data: Data! = runYabai(arguments: ["-m", "query", "--displays"])
	return try! JSONDecoder().decode([Display].self, from: data)
}

func getSpaces() -> [Space] {
	let data: Data! = runYabai(arguments: ["-m", "query", "--spaces"])
	return try! JSONDecoder().decode([Space].self, from: data)
}

func getWindows() -> [Window] {
	let data: Data! = runYabai(arguments: ["-m", "query", "--windows"])
	return try! JSONDecoder().decode([Window].self, from: data)
}

func getActiveWindow() -> Window? {
	let data: Data! = runYabai(arguments: ["-m", "query", "--windows", "--window"])
	return try! JSONDecoder().decode([Window].self, from: data)[0]
}

func orActiveWindow(_ window: Window?) -> Window? {
	if let window = window {
		return window
	}

	return getActiveWindow()
}

func getWindowsOnDisplayedSpaces() -> (Window, [Window]) {
	let spaces = getSpaces().filter { space in
		return space.isVisible
	}.map { space in
		return space.index
	}

	let wins = getWindows().filter { win in
		return spaces.contains(win.space)
	}
	
	let active: Window! = wins.first { win in
		return win.hasFocus
	}

	return (active, wins)
}

// Focus {{{1
func queryWindowRight() -> Window? {
	let (active, windows) = getWindowsOnDisplayedSpaces()
	return windows.filter { window in 
		return window.isVisible
	}.sorted(by: sortX).first { window in 
		return window.id != active.id && window.frame.x2 > active.frame.x2
	}
}

func queryWindowLeft() -> Window? {
	let (active, windows) = getWindowsOnDisplayedSpaces()
	return windows.filter { window in 
		return window.isVisible
	}.sorted(by: sortX2).first { window in 
		return window.id != active.id && window.frame.x < active.frame.x
	}
}

func focusWindow(window: Window?) {
	if let window = window {
		let _ = runYabai(arguments: ["-m", "window", "--focus", "\(window.id)"])
	}
}

// Move {{{1
func moveWindowToSpace(window: Window?, space: String?) {
	if let space = space {
		var args = ["-m", "window", "--space", space]
		if let window = window {
			args.insert("\(window.id)", at: 2)
		}

		let _ =	runYabai(arguments: args)
	}
}

// Resize {{{1
func resizeWindowLeftHalf() {
	openRectangle(event: RectangleEvent.action, id: "left-half")
}

func resizeWindowRightHalf() {
	openRectangle(event: RectangleEvent.action, id: "right-half")
}

func resizeWindowMaximize() {
	openRectangle(event: RectangleEvent.action, id: "maximize")
}

func resizeWindowCenter() {
	openRectangle(event: RectangleEvent.action, id: "center")
}
// Debug {{{1
func printWindow(_ window: Window?) {
	if let w = window {
		print("\(w.id): \(w.app) - \(w.title)")
		print("[\(w.frame.x),\(w.frame.y)].....[\(w.frame.x2),\(w.frame.y)]")
		print("[\(w.frame.x),\(w.frame.y2)].....[\(w.frame.x2),\(w.frame.y2)]")
		print("w: \(w.frame.w), h: \(w.frame.h)")
	} else {
		print("No window found")
	}
}

func debug() {
	let (active, _) = getWindowsOnDisplayedSpaces()
	printWindow(active)
	printWindow(queryWindowLeft())
	printWindow(queryWindowRight())
}

if (CommandLine.argc > 1) {
	switch CommandLine.arguments[1] {
	case "compile":
		compile()
	case "debug":
		debug()
	case "focus_window_right", "focusWindowRight":
		focusWindow(window: queryWindowRight())
	case "focus_window_left", "focusWindowLeft":
		focusWindow(window: queryWindowLeft())
	case "move_window_to_space", "moveWindowToSpace":
		moveWindowToSpace(window: nil, space: CommandLine.arguments[2])
	case "resize_window_left_half", "resizeWindowLeftHalf":
		resizeWindowLeftHalf()
	case "resize_window_right_half", "resizeWindowRightHalf":
		resizeWindowRightHalf()
	case "resize_window_maximize", "resizeWindowMaximize":
		resizeWindowMaximize()
	case "resize_window_center", "resizeWindowCenter":
		resizeWindowCenter()
	default:
		print("No subcommand provided")
		exit(1)
	}
}
