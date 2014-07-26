void Pipeline::scale(GLfloat sx, GLfloat sy, GLfloat sz){
  m_scale.x *= sx;
  m_scale.y *= sy;
  m_scale.z *= sz;
}
void Pipeline::rotate(GLfloat ax, GLfloat ay, GLfloat az){
  m_rotation.x += radians(ax);
  m_rotation.y += radians(ay);
  m_rotation.z += radians(az);
}
void Pipeline::translate(GLfloat tx, GLfloat ty, GLfloat tz){
  m_translation.x += tx;
  m_translation.y += ty;
  m_translation.z += tz;
}
void Pipeline::setPerspective(GLfloat width, GLfloat height, GLfloat FOV, GLfloat zNear, GLfloat zFar){
  m_perspective.width = width;
  m_perspective.height = height;
  m_perspective.FOV = FOV;
  m_perspective.zNear = zNear;
  m_perspective.zFar = zFar;
}
void Pipeline::setCamera(vec3 pos, vec3 target, vec3 up){
  m_camera.pos = pos;
  m_camera.target = target;
  m_camera.up = up;
}

mat4 Pipeline::getWorld(){
  mat4 scale, rotation, translation;
  scale = getScaleM(m_scale);
  rotation = getRotationM(m_rotation);
  translation = getTranslationM(m_translation);
  return translation * rotation * scale;
}

mat4 Pipeline::getTransform(){
  mat4 world, view, projection;
  
  world = getWorld();
  view = getViewM(m_camera.pos, m_camera.target, m_camera.up);
  projection = getProjectionM(m_perspective.width, m_perspective.height, m_perspective.FOV, m_perspective.zNear, m_perspective.zFar);
  
  return projection * view * world;
}

vec3 Pipeline::getCameraPos(){
  return m_camera.pos;
}

void Pipeline::reset(){
  m_scale = vec3(1.0f);
  m_rotation = vec3(0.0f);
  m_translation = vec3(0.0f);
  
  setCamera(vec3(0.0f, 0.0f, 0.0f), vec3(0.0f, 0.0f, 1.0f), vec3(0.0f, 1.0f, 0.0f));
}