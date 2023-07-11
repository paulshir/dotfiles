## Glazed

Window Management Scripts

Uses [yabai](https://github.com/koekeishiya/yabai) and [rectangle pro](https://rectangleapp.com/pro) for the heavy
lifting.

Commands are run from Karabiner Elements

Swift is the language used as:
* With bash the jq queries were too big, and hard to parse/maintain
* Did some benchmarking, and while the swift script is about the same as python, it is orders of magnitude faster once
compiled
* This will only work on mac anyway so not too concerned about cross platform support.

### Compiling
The script has a sub command to compile itself. This only works if invoked using the relative path, and will fail if
invoked from `$PATH`

```
./glazed.swift compile
```

### Commands
TODO
