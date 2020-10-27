#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

InvokeHyper(inKey)
{
	; MsgBox % "InKey: " . inKey
	IF inKey = s
		RUN "C:\Program Files\Sublime Text 3\subl.exe"
	ELSE IF inKey = f
		RUN "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
	ELSE
		SEND !+^#%inKey%
}

InvokeHyperFromEndKey(inErrorLevel)
{
	EK := "{" . StrReplace(inErrorLevel, "EndKey:") . "}"
	InvokeHyper(EK)
}

+CAPSLOCK::CAPSLOCK

CAPSLOCK::
	INPUT, OutputVar, L1 M T0.3, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}{Enter}
	
	IF OutputVar
		InvokeHyper(OutputVar)
	ELSE IF InStr(ErrorLevel, "EndKey:"){
		InvokeHyperFromEndKey(ErrorLevel)
	}
	ELSE IF ErrorLevel = NewInput
		SEND {ESC}
	ELSE {
		INPUT, OutputVar, L1 M, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}{Enter}

		IF OutputVar
			InvokeHyper(OutputVar)
		ELSE IF InStr(ErrorLevel, "EndKey:"){
			InvokeHyperFromEndKey(ErrorLevel)
		}
	}
	
CAPSLOCK UP::
	INPUT