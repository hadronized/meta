module meta;

/* imports */
import std.range : retro;
import std.algorithm : joiner, countUntil;
import std.array : array;
import std.file : dirEntries, SpanMode, timeLastModified;
import std.stdio : writefln, writeln;
import std.datetime : SysTime;
import std.process : shell;

/* source directory */
enum SRC_DIR = "../src/meta";
enum INCLUDE_DIR_STRING = "-I../src -I../src/import";

int main(string[] args) {
	if (args.length == 1)
		build();
	dispatch_args(args[1 .. $]);
	return 0;
}

void dispatch_args(string[] args) {
	foreach (a; args) {
		switch (a) {
			case "build" :
				build();
				break;

			case "clean" :
				shell("rm -f *.o");
				break;

			default :;
				usage();
		}

	}
}

void usage() {
	writeln("usage: meta [build|clean]");
}

void build() {
    writeln("Building meta...");
	auto files = array(dirEntries(SRC_DIR, "*.{d}", SpanMode.depth));

	version (DigitalMars) {
		string compileString(string f) {
			return "dmd -c " ~ INCLUDE_DIR_STRING ~ " " ~ f;
		}
	}

	auto filesNb = files.length;
	foreach (int i, string f; files) {
		auto nameIndex = countUntil(retro(f), '/');
		auto objectName = f[$-nameIndex .. $-2] ~ ".o";
		if (timeLastModified(f) >= timeLastModified(objectName, SysTime.min)) {
			writefln("--> [Compiling %s [%d%%]", f, cast(int)(((i+1)*100/filesNb)));
			auto ret = shell(compileString(f));
			writeln(ret);
		}

		++i;
	}
	writeln("...done");
	writeln();
}

