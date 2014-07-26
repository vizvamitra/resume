#ifndef CAMERA
  #define CAMERA
  
  //#include <glm/glm.hpp>
  #include "GL\gl.h"
  #include "geometry.h"
  #include "quaternion.h"
  
  #define STEPSIZE 0.2f
  #define ANGLECHANGE 0.06f

  class Camera
  {  
  public:
        Camera(GLuint width, GLuint height);
        Camera(GLuint width, GLuint height, vec3 pos, vec3 target, vec3 up);

        void setPosition(GLfloat x, GLfloat y, GLfloat z);
        void setPosition(vec3 pos);
  
        void onKeyboard(char key);
        void onMouseMove(GLint x, GLint y);
        void update();
        void reset();
  
        vec3 pos(){
          return m_pos;
        }
        vec3 target(){
          return m_target;
        }
        vec3 up(){
          return m_up;
        }
    
  private:
        vec3 m_pos;
        vec3 m_target;
        vec3 m_up;
  
        GLuint winWidth;
        GLuint winHeight;
  
        GLfloat m_angleH;
        GLfloat m_angleV;
        GLfloat m_angleAddH;
        GLfloat m_angleAddV;
  
        struct {
          GLint x;
          GLint y;
        } m_mousePos;
  };
  
  #include "camera.cpp"
  
#endif