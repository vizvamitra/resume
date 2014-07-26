#ifndef GEOMETRY
#define GEOMETRY

#include <GL\gl.h>
#include "quaternion.h"

namespace geom{
  const GLfloat PI = 3.14159265;

  mat4 getScaleM(vec3 scale);
  mat4 getRotationM(vec3 rot);
  mat4 getTranslationM(GLfloat Tx, GLfloat Ty, GLfloat Tz);
  mat4 getViewM(vec3 pos, vec3 target, vec3 up);
  mat4 getProjectionM(GLuint width, GLuint height, GLfloat angle,
                           GLfloat zNear, GLfloat zFar);
  
  GLfloat radians(GLfloat degrees);
  vec2 normalize(vec2 vec);
  vec3 normalize(vec3 vec);
  vec4 normalize(vec4 vec);
  vec3 cross(vec3 v1, vec3 v2);
  void rotate(vec3 vec, GLfloat angle);
  
  #include "geometry.cpp"
}
#endif