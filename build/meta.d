module meta;

/* imports */
import std.algorithm : joiner;
import std.array : array;
import std.file : dirEntries, SpanMode;
import std.stdio : writefln, writeln;
import std.process : shell;

/* source directory */
enum SRC_DIR = "../src/meta";
enum INCLUDE_DIR_STRING = "-I../src -I../src/import";

int main(string[] args) {
	if (args.length == 1)
		usage();
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
		writefln("--> [Compiling %s [%d%%]", f, cast(int)(i*100/filesNb));
		auto ret = shell(compileString(f));
		writeln(ret);
		++i;
	}
	writeln("...done");
	writeln();
}

