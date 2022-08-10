#include <ruby.h>
#include <ruby/encoding.h>
#include <libkakasi.h>

const char* KAKASI_ARGS[2] = {"kakasi", "-JK"};

VALUE rb_kanji_to_katakana(VALUE self, VALUE string);

void Init_kanji_to_katakana() {
    VALUE rb_mKanjiToKatakana = rb_const_get(rb_cObject, rb_intern("KanjiToKatakana"));

    kakasi_getopt_argv(2, (char**)KAKASI_ARGS);

    rb_define_singleton_method(rb_mKanjiToKatakana, "kanji_to_katakana", rb_kanji_to_katakana, 1);
}

VALUE rb_kanji_to_katakana(VALUE self, VALUE string) {
    VALUE cp932 = rb_const_get(rb_cEncoding, rb_intern("CP932"));
    VALUE utf8 = rb_const_get(rb_cEncoding, rb_intern("UTF_8"));

    // Re-encode string to Encoding::CP932
    string = rb_funcall(string, rb_intern("encode"), 1, cp932);

    // Get a fresh char pointer
    char* ptr = malloc(RSTRING_LEN(string) + 1);
    memcpy(ptr, StringValueCStr(string), RSTRING_LEN(string));
    ptr[RSTRING_LEN(string)] = '\0';

    // Run translation
    char *buf = kakasi_do(ptr);

    // Construct CP932-encoded string and re-encode it in UTF-8
    VALUE decoded = rb_enc_str_new_cstr(buf, rb_to_encoding(cp932));
    decoded = rb_funcall(decoded, rb_intern("encode"), 1, utf8);
    kakasi_free(buf);

    return decoded;
}
