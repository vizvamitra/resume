Camera::Camera(GLuint width, GLuint height, vec3 pos, vec3 target, vec3 up){
  winWidth = width;
  winHeight = height;
  
  m_pos = pos;  
  m_target = normalize(target);
  m_up = normalize(up);
  
  m_mousePos.x = winWidth / 2;
  m_mousePos.y = winHeight / 2;
  
  m_angleAddH = 0.0f;
  m_angleAddV = 0.0f;
}
Camera::Camera(GLuint width, GLuint height){
  winWidth = width;
  winHeight = height;
  
  m_pos    = vec3(0.0f, 0.0f, -20.0f);
  m_target = vec3(0.0f, 0.0f, 1.0f);
  m_up     = vec3(0.0f, 1.0f, 0.0f);
  
  m_mousePos.x = winWidth / 2;
  m_mousePos.y = winHeight / 2;
  
  m_angleAddH = 0.0f;
  m_angleAddV = 0.0f;
}

void Camera::setPosition(GLfloat x, GLfloat y, GLfloat z){
  m_pos = vec3(x, y, z);
}
void Camera::setPosition(vec3 pos){
  m_pos = pos;
}

void Camera::onKeyboard(char key){
  switch(key){
    case 'w':{
      m_pos += m_target * STEPSIZE;
      } break;
    case 's':{
      m_pos -= m_target * STEPSIZE;
      } break;
    case 'a':{
      vec3 left = cross(m_up, m_target);
      left = normalize(left) * (STEPSIZE * winHeight/winWidth);
      m_pos += left;
      } break;
    case 'd':{
      vec3 right = cross(m_target, m_up);
      right = normalize(right) * (STEPSIZE * winHeight/winWidth);
      m_pos += right;
      } break;
    case ' ':{
        m_pos += m_up * STEPSIZE;
      } break;
    case (char)114:{ /*Ctrl*/
        m_pos -= m_up * STEPSIZE;
      } break;
  }
}

void Camera::onMouseMove(GLint x, GLint y){
  const GLint dx = x - m_mousePos.x;
  const GLint dy = y - m_mousePos.y;
  
  m_angleH = 0.0f + m_angleAddH;
  m_angleV = 0.0f + m_angleAddV;
  
  m_angleH += (float)dx * ANGLECHANGE;
  m_angleV += (float)dy * ANGLECHANGE;
  
  update();
  
  if (x==winWidth-1 || x==0 || y==winHeight-1 || y==0){
    m_angleAddH = m_angleH;
    m_angleAddV = m_angleV;
  
    glutWarpPointer(winWidth/2, winHeight/2);
  }
}

void Camera::update(){
  const vec3 axisV = vec3(0.0f, 1.0f, 0.0f);
  vec3 target = vec3(0.0f, 0.0f, 1.0f);
  rotate(target, axisV, m_angleH);
  
  vec3 axisH = cross(target, axisV);
  normalize(axisH);
  rotate(target, axisH, m_angleV);
  
  m_target = target;
  normalize(m_target);
  
  m_up = cross(axisH, m_target);
  normalize(m_up);
}

void Camera::reset(){
  m_pos    = vec3(0.0f, 0.0f, -20.0f);
  m_target = vec3(0.0f, 0.0f, 1.0f);
  m_up     = vec3(0.0f, 1.0f, 0.0f);
  m_angleAddH = 0.0f;
  m_angleAddV = 0.0f;
  glutWarpPointer(winWidth/2, winHeight/2);
}