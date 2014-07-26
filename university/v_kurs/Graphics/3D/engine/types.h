#ifndef TYPES
#define TYPES

#include <GL\gl.h>

// VEC2 //
struct vec2 {
  GLfloat x, y;
  
  vec2(){}
    
  vec2(GLfloat f){
    x = f;
    y = f;
  }
  
  vec2(GLfloat _x, GLfloat _y){
    x = _x;
    y = _y;
  }
  
  vec2& operator += (const vec2& r){
    x += r.x;
    y += r.y;
    return *this;
  }
  vec2& operator -= (const vec2& r){
    x -= r.x;
    y -= r.y;
    return *this;
  }
  vec2 operator *= (GLfloat s){
    x *= s;
    y *= s;
    return *this;
  }
  void print(){
    std::cerr<<"("<<x<<", "<<y<<")\n";
  }
};

inline vec2 operator + (const vec2& l, const vec2& r){
  vec2 res = vec2(l.x+r.x, l.y+r.y);
  return res;
}
inline vec2 operator - (const vec2& l, const vec2& r){
  vec2 res = vec2(l.x-r.x, l.y-r.y);
  return res;
}
inline vec2 operator * (const vec2& l, const GLfloat s){
  vec2 res = vec2(l.x*s, l.y*s);
  return res;
}
inline GLfloat operator * (const vec2& l, const vec2& r){
  GLfloat res = l.x*r.x + l.y*r.y;
  return res;
}

// VEC3 //

struct vec3 {
  GLfloat x, y, z;
  
  vec3(){}
    
  vec3(GLfloat f){
    x = f;
    y = f;
    z = f;
  }
  
  vec3(GLfloat _x, GLfloat _y, GLfloat _z){
    x = _x;
    y = _y;
    z = _z;
  }
  
  vec3& operator += (const vec3& r){
    x += r.x;
    y += r.y;
    z += r.z;
    return *this;
  }
  vec3& operator -= (const vec3& r){
    x -= r.x;
    y -= r.y;
    z -= r.z;
    return *this;
  }
  vec3 operator *= (GLfloat s){
    x *= s;
    y *= s;
    z *= s;
    return *this;
  }
  void print(){
    std::cerr<<"("<<x<<", "<<y<<", "<<z<<")\n";
  }
};

inline vec3 operator + (const vec3& l, const vec3& r){
  vec3 res = vec3(l.x+r.x, l.y+r.y, l.z+r.z);
  return res;
}
inline vec3 operator - (const vec3& l, const vec3& r){
  vec3 res = vec3(l.x-r.x, l.y-r.y, l.z-r.z);
  return res;
}
inline vec3 operator * (const vec3& l, const GLfloat s){
  vec3 res = vec3(l.x*s, l.y*s, l.z*s);
  return res;
}
inline GLfloat operator * (const vec3& l, const vec3& r){
  GLfloat res = l.x*r.x + l.y*r.y + l.z*r.z;
  return res;
}

// VEC4 //

struct vec4 {
  GLfloat x, y, z, w;
  
  vec4(){}
    
  vec4(GLfloat f){
    x = f;
    y = f;
    z = f;
    w = 1.0f;
  }
  
  vec4(GLfloat _x, GLfloat _y, GLfloat _z, GLfloat _w){
    x = _x;
    y = _y;
    z = _z;
    w = _w;
  }
  
  vec4& operator += (const vec4& r){
    x += r.x;
    y += r.y;
    z += r.z;
    w += r.w;
    return *this;
  }
  vec4& operator -= (const vec4& r){
    x -= r.x;
    y -= r.y;
    z -= r.z;
    w -= r.w;
    return *this;
  }
  vec4 operator *= (GLfloat s){
    x *= s;
    y *= s;
    z *= s;
    w *= s;
    return *this;
  }
  void print(){
    std::cerr<<"("<<x<<", "<<y<<", "<<z<<", "<<w<<")\n";
  }
};

inline vec4 operator + (const vec4& l, const vec4& r){
  vec4 res = vec4(l.x+r.x, l.y+r.y, l.z+r.z, l.w+r.w);
  return res;
}
inline vec4 operator - (const vec4& l, const vec4& r){
  vec4 res = vec4(l.x-r.x, l.y-r.y, l.z-r.z, l.w-r.w);
  return res;
}
inline vec4 operator * (const vec4& l, const GLfloat s){
  vec4 res = vec4(l.x*s, l.y*s, l.z*s, l.w*s);
  return res;
}
inline GLfloat operator * (const vec4& l, const vec4& r){
  GLfloat res = l.x*r.x + l.y*r.y + l.z*r.z + l.z*r.z;
  return res;
}

// MAT4 //

struct mat4{
  GLfloat m[16];
  
  mat4(){}
  
  mat4(GLfloat f){
    m[0]=f;     m[1]=0.0f;  m[2]=0.0f;  m[3]=0.0f;
    m[4]=0.0f;  m[5]=f;     m[6]=0.0f;  m[7]=0.0f;
    m[8]=0.0f;  m[9]=0.0f;  m[10]=f;    m[11]=0.0f;
    m[12]=0.0f; m[13]=0.0f; m[14]=0.0f; m[15]=f;
  }
  
  mat4(GLfloat m0,  GLfloat m1,  GLfloat m2,  GLfloat m3,
       GLfloat m4,  GLfloat m5,  GLfloat m6,  GLfloat m7,
       GLfloat m8,  GLfloat m9,  GLfloat m10, GLfloat m11,
       GLfloat m12, GLfloat m13, GLfloat m14, GLfloat m15)
  {
    m[0]=m0;   m[1]=m1;   m[2]=m2;   m[3]=m3;
    m[4]=m4;   m[5]=m5;   m[6]=m6;   m[7]=m7;
    m[8]=m8;   m[9]=m9;   m[10]=m10; m[11]=m11;
    m[12]=m12; m[13]=m13; m[14]=m14; m[15]=m15;
  }
  
  GLfloat& operator[](const GLint n){
    return m[n];
  }
  
  inline mat4 operator + (const mat4& r){
    mat4 res;
    
    res.m[0]=m[0]+r.m[0]; res.m[4]=m[4]+r.m[4]; res.m[8]=m[8]+r.m[8];    res.m[12]=m[12]+r.m[12];
    res.m[1]=m[1]+r.m[1]; res.m[5]=m[5]+r.m[5]; res.m[9]=m[8]+r.m[9];    res.m[13]=m[13]+r.m[13];
    res.m[2]=m[2]+r.m[2]; res.m[6]=m[6]+r.m[6]; res.m[10]=m[10]+r.m[10]; res.m[14]=m[14]+r.m[14];
    res.m[3]=m[3]+r.m[3]; res.m[7]=m[7]+r.m[7]; res.m[11]=m[11]+r.m[11]; res.m[15]=m[15]+r.m[15];
    
    return res;
  }
  
  inline mat4 operator * (const mat4& r){
    mat4 res;
    
    for(GLuint i=0; i<4; i++){
      for(GLuint j=0; j<4; j++){
        res.m[i*4+j] = m[4*i] * r.m[j] +
                       m[4*i+1]*r.m[4+j] +
                       m[4*i+2]*r.m[8+j] +
                       m[4*i+3]*r.m[12+j];
      }
    }
    
    return res;
  }
  
  inline vec4 operator * (const vec4& r){
    vec4 res;
    
    res.x = m[0]*r.x +  m[1]*r.y +  m[2]*r.z +  m[3]*r.w;
    res.y = m[4]*r.x +  m[5]*r.y +  m[6]*r.z +  m[7]*r.w;
    res.z = m[8]*r.x +  m[9]*r.y +  m[10]*r.z + m[11]*r.w;
    res.w = m[12]*r.x + m[13]*r.y + m[14]*r.z + m[15]*r.w;
    
    return res;
  }
  
  void print(){
    for(int i=0;i<4;i++){
      for(int j=0;j<4;j++){
        std::cerr<<m[i*4+j]<<" ";
      }
      std::cerr<<"\n";
    }  
  }
};

#endif