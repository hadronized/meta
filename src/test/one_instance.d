import meta.utils.one_instance;

class foo {
    mixin OneInstance!foo;
}

int main() {
    auto f1 = new foo;
    auto f2 = f1;
    auto f3 = new foo;
    return 0;
}