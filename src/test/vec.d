import std.stdio;
import meta.utils.math.vecs;
import meta.utils.logger;
import meta.utils.memory;

int main() {
    auto l = spawn!(vec!(2, int))(3, 14);
    writeln(l);
    return 0;
}