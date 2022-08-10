$(info Compiling arm64-apple-darwin target)

O = o
A = a
DYLIB = bundle
LDFLAGS += -liconv -target arm64-apple-darwin
CFLAGS += -target arm64-apple-darwin
