#ifndef LIGHT
#define LIGHT

#include <GL\gl.h>
#include "types.h"
#include "geometry.h"

struct Lightning {
  vec3 color;
  GLfloat ambientIntensity;
  vec3 direction;
  GLfloat diffuseIntensity;
  
  Lightning(){
    color = vec3(1.0f, 1.0f, 1.0f);
    ambientIntensity = 0.1f;
    direction = normalize(vec3(1.0f, -1.0f, 1.0f));
    diffuseIntensity = 1.5f;
  }
  
  Lightning(vec3 _color, GLfloat _aIntensity, vec3 _direction, GLfloat _dIntensity){
    color = _color;
    ambientIntensity = _aIntensity;
    direction = _direction;
    diffuseIntensity = _dIntensity;
  }
  
  void changeIntensity(GLfloat aI, GLfloat dI){
    ambientIntensity += aI;
    if (ambientIntensity < 0)
      ambientIntensity = 0.0f;
    diffuseIntensity += dI;
    if (ambientIntensity < 0)
      diffuseIntensity = 0.0f;
  }
  
  void reset(){
    color = vec3(1.0f, 1.0f, 1.0f);
    ambientIntensity = 0.1f;
    direction = normalize(vec3(1.0f, -1.0f, 1.0f));
    diffuseIntensity = 1.5f;
  }
};

#endif