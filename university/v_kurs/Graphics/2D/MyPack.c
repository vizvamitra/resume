#include "ruby.h"

VALUE MyPack = Qnil;

void Init_mypack();

static VALUE method_pack(VALUE self, VALUE argv);

void Init_mypack() {
	MyPack = rb_define_module("MyPack");
	rb_define_method(MyPack, "pack", method_pack, 1);
}

static VALUE method_pack(VALUE self, VALUE argv) {
  VALUE s;
  VALUE *p = RARRAY_PTR(argv);
  int len = RARRAY_LEN(argv);
  float *str = ALLOC_N(float, len);
  for (int i=0; i<len; i++){
    str[i] = (float)NUM2DBL(p[i]);
  }
  s = rb_str_new((char*)str, len*4);
  xfree(str);
  str = NULL;
  return s;
}