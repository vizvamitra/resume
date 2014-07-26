#ifndef PIPELINE
#define PIPELINE

#include "geometry.h"
using namespace geom;

class Pipeline{
public:
  Pipeline(){
    m_scale = vec3(1.0f, 1.0f, 1.0f);
    m_rotation = vec3(0.0f, 0.0f, 0.0f);
    m_translation = vec3(0.0f, 0.0f, 0.0f);
  }
  
  void scale(GLfloat sx, GLfloat sy, GLfloat sz);
  void rotate(GLfloat ax, GLfloat ay, GLfloat az);
  void translate(GLfloat tx, GLfloat ty, GLfloat tz);
  void setPerspective(GLfloat width, GLfloat height, GLfloat FOV, GLfloat zNear, GLfloat zFar);
  void setCamera(vec3 pos, vec3 target, vec3 up);

  mat4 getWorld();
  mat4 getTransform();
  
  vec3 getCameraPos();
  
  void reset();

private:
  vec3 m_scale;
  vec3 m_rotation;
  vec3 m_translation;

  struct {
    GLfloat width;
    GLfloat height;
    GLfloat FOV;
    GLfloat zNear;
    GLfloat zFar;
  } m_perspective;
  
  struct {
    vec3 pos;
    vec3 target;
    vec3 up;
  } m_camera;
  
  mat4 m_transformation;      
};

#include "pipeline.cpp"

#endif /* pipeline.h */