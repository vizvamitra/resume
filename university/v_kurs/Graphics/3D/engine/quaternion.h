#ifndef QUATERNION
#define QUATERNION

#include <GL\gl.h>
#include "geometry.h"

struct Quaternion{
  GLfloat x, y, z, w;
  vec3 v;
  
  Quaternion(GLfloat _x, GLfloat _y, GLfloat _z, GLfloat _w){
    x = _x;
    y = _y;
    z = _z;
    w = _w;

    normalize();
  }
  
  Quaternion inverse(){
    Quaternion result = Quaternion(-x, -y, -z, w);
    return result;
  }
  
  GLfloat norm(){
    return sqrtf(x*x + y*y + z*z + w*w);
  }
  
  void normalize(){
    GLfloat n = norm();
    w /= n;
    x /= n;
    y /= n;
    z /= n;
  }
  
  void show(){
    std::cerr<<w<<", ("<<x<<", "<<y<<", "<<z<<")\n";
  }
};

Quaternion operator * (const Quaternion& l, const Quaternion& r){
  const float w = (l.w * r.w) - (l.x * r.x) - (l.y * r.y) - (l.z * r.z);
  const float x = (l.x * r.w) + (l.w * r.x) + (l.y * r.z) - (l.z * r.y);
  const float y = (l.y * r.w) + (l.w * r.y) + (l.z * r.x) - (l.x * r.z);
  const float z = (l.z * r.w) + (l.w * r.z) + (l.x * r.y) - (l.y * r.x);
  
  Quaternion result = Quaternion(x, y, z, w);
  return result;
}
Quaternion operator * (const Quaternion& q, const vec3& v){
  const float w = - (q.x * v.x) - (q.y * v.y) - (q.z * v.z);
  const float x =   (q.w * v.x) + (q.y * v.z) - (q.z * v.y);
  const float y =   (q.w * v.y) + (q.z * v.x) - (q.x * v.z);
  const float z =   (q.w * v.z) + (q.x * v.y) - (q.y * v.x);

  Quaternion result = Quaternion(x, y, z, w);
  return result;
}
  
#endif