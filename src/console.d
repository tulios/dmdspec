module console;

import std.stdio;

import std.exception: enforce;

auto NOT_IMPLEMENTED_YET = "Not implemented for your OS yet.";

version (Windows) {
	import std.c.windows.windows;
	import std.windows.syserror;
	
	enum Color : WORD {
		RED     = FOREGROUND_RED | FOREGROUND_INTENSITY,
		GREEN   = FOREGROUND_GREEN | FOREGROUND_INTENSITY,
		CYAN    = FOREGROUND_BLUE | FOREGROUND_GREEN | FOREGROUND_INTENSITY,
		WHITE   = FOREGROUND_BLUE | FOREGROUND_GREEN | FOREGROUND_RED | FOREGROUND_INTENSITY,
	}
	
	WORD getCharacterAttributes() {
		HANDLE stdoutHandle = GetStdHandle(STD_OUTPUT_HANDLE);
		enforce(stdoutHandle != INVALID_HANDLE_VALUE, sysErrorString(GetLastError()));
		
		CONSOLE_SCREEN_BUFFER_INFO consoleInfo;
		
		BOOL successful = GetConsoleScreenBufferInfo(stdoutHandle, &consoleInfo);
		enforce(successful, sysErrorString(GetLastError()));
		
		return consoleInfo.wAttributes;
	}
	
	void setCharacterAttributes(WORD attributes) {
		HANDLE stdoutHandle = GetStdHandle(STD_OUTPUT_HANDLE);
		enforce(stdoutHandle != INVALID_HANDLE_VALUE, sysErrorString(GetLastError()));
		
		BOOL successful = SetConsoleTextAttribute(stdoutHandle, attributes);
		enforce(successful, sysErrorString(GetLastError));
	}
	
	WORD setForegroundColor(WORD color) {
		stdin.flush();
		WORD previousColor = getCharacterAttributes();
		setCharacterAttributes(color | (previousColor & 0xFFF0));
		return previousColor;
	}
	
	void writec(alias W, T...)(WORD color, string fmt, T args) {
		WORD previousColor = setForegroundColor(color);
		W(fmt, args);
		setForegroundColor(previousColor);
	}
}
else version (Posix) {
	import core.vararg;
             	
	enum Color : string {
		RED     = "\033[31m",
		GREEN   = "\033[32m",
		CYAN    = "\033[36m",
		RESET   = "\033[0m",
	}
	
	void writec(alias W, T...)(Color color, string fmt, T args) {		
		W(cast(string)(color ~ fmt ~ Color.RESET), args);
	}
}
else {
	static assert(NOT_IMPLEMENTED_YET);
}

void writecfln(T...)(Color color, string fmt, T args) {
    writec!(std.stdio.writefln)(color, fmt, args);
}

void writecf(T...)(Color color, string fmt, T args) {
    writec!(std.stdio.writef)(color, fmt, args);    
}
