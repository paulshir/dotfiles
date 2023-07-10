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

	var y2: Int {
		return y + h
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

func sortX(lhs: Window, rhs: Window) -> Bool {
	if (lhs.space != rhs.space) {
		return lhs.space < rhs.space
	} else if (lhs.frame.x != rhs.frame.x) {
		return lhs.frame.x < rhs.frame.x
	} else if (lhs.frame.y != rhs.frame.y) {
		return lhs.frame.y < rhs.frame.y
	} else {
		return lhs.id < rhs.id
	}
}

// Utility Functions {{{1

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
//jq '[.[] | select(."has-focus")][0] as $aw | [.[] | select(.id != $aw.id and .space == $aw.space and (.frame.x + .frame.w) >= ($aw.frame.x + $aw.frame.w))] | sort_by(.display, .frame.x, .frame.y, .id) | .[0].id'
func queryWindowRight() -> Window? {
	let (active, windows) = getWindowsOnDisplayedSpaces()
	return windows.filter { window in 
		return window.isVisible
	}.sorted(by: sortX).first { window in 
		return window.id != active.id && window.frame.x2 > active.frame.x2
	}
}


// Debug {{{1
func printWindow(win: Window?) {
	if let f = win {
		print("\(f.id): \(f.app) - \(f.title)")
		print("[\(f.frame.x),\(f.frame.y)].....[\(f.frame.x2),\(f.frame.y)]")
		print("[\(f.frame.x),\(f.frame.y2)].....[\(f.frame.x2),\(f.frame.y2)]")
		print("w: \(f.frame.w), h: \(f.frame.h)")
	} else {
		print("No window found")
	}
}

func debug() {
	let (active, _) = getWindowsOnDisplayedSpaces()
	printWindow(win: active)
	printWindow(win: queryWindowRight())
}

if (CommandLine.argc > 1) {
	switch CommandLine.arguments[1] {
	case "debug":
		debug()
	default:
		print("No subcommand provided")
		exit(1)
	}
}
