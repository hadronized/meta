import meta.utils.memory;

struct foo {
    int a;
}

class bar {
    int a;

    this() {
        this.a = a.init;
    }

    this(int a, string n, uint l) {
        this.a = a;
    }
}

int main() {
    auto f = spawn!foo;
    auto b = spawn!bar;
    auto b2 = spawn!bar(2, "lol", 314u);

    b.a = 4;
    return 0;
}