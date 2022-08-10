$(info Compiling x86_64-apple-darwin target)

O = o
A = a
DYLIB = bundle
LDFLAGS += -liconv -target x86_64-apple-darwin
CFLAGS += -target x86_64-apple-darwin
