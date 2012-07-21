module meta;

/* imports */
import std.range : retro;
import std.algorithm : joiner, countUntil;
import std.array : array;
import std.file : dirEntries, SpanMode, timeLastModified;
import std.stdio : writefln, writeln;
import std.string : tr;
import std.datetime : SysTime;
import std.process : shell;

/* build type */
enum BUILD_TYPE = "-debug -g";

/* source directory */
enum SRC_DIR = "../src/meta";
enum TEST_DIR = "../src/test";
enum INCLUDE_DIR_STRING = "-I../src -I../lib/Derelict3/import";

/* lib dependencies */
enum LIBS = "-L-L../lib/Derelict3/lib -L-lDerelictGL3 -L-lDerelictUtil -L-lDerelictGLFW3";

/* output */
enum LIB_NAME = "libmeta.a";

int main(string[] args) {
    if (args.length == 1)
        build(SRC_DIR, true, false);
    else
        dispatch_args(args[1 .. $]);
    return 0;
}

void dispatch_args(string[] args) {
    foreach (a; args) {
        switch (a) {
            case "build" :
                build(SRC_DIR, false, false);
                break;

            case "clean" :
                shell("rm -f *.o " ~ LIB_NAME);
                break;

            case "link" :
                build(SRC_DIR, true, false);
                break;

            case "test" :
                build(TEST_DIR, false, true);
                break;

            default :;
                usage();
        }
    }
}

void usage() {
    writeln("usage: meta [build|link|test|clean]");
}

void build(string path, bool link, bool test) {
    bool doTest = test & !link;
    writefln("Building %s...", path);
    auto files = array(dirEntries(path, "*.d", SpanMode.depth));
    string toLink;

    version (DigitalMars) {
        string compileString(string f, string output) {
            return (doTest ? "rdmd " : "dmd -c ") ~ BUILD_TYPE ~ " " ~ INCLUDE_DIR_STRING ~ " " ~ f ~ (doTest ? "" : " -of" ~ output);
        }
    }

    auto filesNb = files.length;
    writefln("%d files to compile", filesNb);
    foreach (int i, string f; files) {
        auto moduleName = (doTest ? "test." : "meta.") ~ tr(f[path.length+1 .. $], "/", ".");
        auto objectName = moduleName[0 .. $-2] ~ ".o";
        if (timeLastModified(f) >= timeLastModified(objectName, SysTime.min)) {
            writefln("--> [%4d%% | Compiling %s ]", cast(int)(((i+1)*100/filesNb)), moduleName);
            auto ret = shell(compileString(f, objectName));
            if (ret.length >= 1)
                writeln(ret ~ '\n');
        }

        if (link)
            toLink ~= ' ' ~ objectName;
    }
    writeln("...done\n");

    if (link) {
        writeln("Linking meta...");
        version (DigitalMars) {
            auto linkString = "dmd -lib " ~ BUILD_TYPE ~ " " ~ toLink ~ " " ~ LIBS ~ " -of" ~ LIB_NAME;
        }

        auto ret = shell(linkString);
        writeln(ret ~ '\n');
        writeln("...done\n");
    }
}
