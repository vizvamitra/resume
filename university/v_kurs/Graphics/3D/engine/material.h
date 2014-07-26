#ifndef MATERIAL
#define MATERIAL

#include <GL\gl.h>

struct Material{
  GLfloat cReflection;
  GLfloat specPower;
  
  Material(){
    cReflection = 0.7f;
    specPower = 8.0f;
  }
    
  Material(GLfloat cr, GLfloat sp){
    cReflection = cr;
    specPower = sp;
  }
  
  void reset(){
    cReflection = 0.7f;
    specPower = 8.0f;
  }
};

#endif