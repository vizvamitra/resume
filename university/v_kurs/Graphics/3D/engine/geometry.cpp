// Transformations
mat4 getScaleM(vec3 scale){
  return mat4(
    scale.x,    0.0f,    0.0f, 0.0f,
       0.0f, scale.y,    0.0f, 0.0f,
       0.0f,    0.0f, scale.z, 0.0f,
       0.0f,    0.0f,    0.0f, 1.0f
  );
}

mat4 getRotationM(vec3 rot){
  const GLfloat ax = rot.x;
  const GLfloat ay = rot.y;
  const GLfloat az = rot.z;
  
  const GLfloat cx = cos(ax); 
  const GLfloat sx = sin(ax); 
  const GLfloat cy = cos(ay); 
  const GLfloat sy = sin(ay); 
  const GLfloat cz = cos(az); 
  const GLfloat sz = sin(az);
  
  mat4 mx, my, mz;
  
  mx = mat4(
    1.0f, 0.0f, 0.0f, 0.0f,
    0.0f,   cx,  -sx, 0.0f,
    0.0f,   sx,   cx, 0.0f,
    0.0f, 0.0f, 0.0f, 1.0f
  );
  my = mat4(
      cy, 0.0f,   sy, 0.0f,
    0.0f, 1.0f, 0.0f, 0.0f,
     -sy, 0.0f,   cy, 0.0f,
    0.0f, 0.0f, 0.0f, 1.0f
  );
  mz = mat4(
      cz,   -sz, 0.0f, 0.0f,
      sz,    cz, 0.0f, 0.0f,
    0.0f,  0.0f, 1.0f, 0.0f,
    0.0f,  0.0f, 0.0f, 1.0f
  );
  
  return mz * my * mx;
}

mat4 getTranslationM(vec3 t){
  return mat4(
    1.0f, 0.0f, 0.0f,  t.x,
    0.0f, 1.0f, 0.0f,  t.y,
    0.0f, 0.0f, 1.0f,  t.z,
    0.0f, 0.0f, 0.0f, 1.0f
  );
}

mat4 getProjectionM(GLuint width, GLuint height, GLfloat angle, GLfloat zNear, GLfloat zFar){
  angle = radians(angle);
  const GLfloat ar = (GLfloat)width / (GLfloat)height;
  const GLfloat zTan = tan(angle/2);
  const GLfloat zRange = zNear-zFar;
  return mat4(
    1.0f/(ar*zTan),      0.0f,                 0.0f,                  0.0f,
              0.0f, 1.0f/zTan,                 0.0f,                  0.0f,
              0.0f,      0.0f, (-zNear-zFar)/zRange, (2*zNear*zFar)/zRange,
              0.0f,      0.0f,                 1.0f,                  0.0f
  );
}

mat4 getViewM(vec3 pos, vec3 target, vec3 up){
  vec3 N = target;
  normalize(N);
  vec3 V = up;
  normalize(V);
  vec3 U = cross(N, V);
  
  mat4 translation = mat4(
    1.0f, 0.0f, 0.0f, -pos.x,
    0.0f, 1.0f, 0.0f, -pos.y,
    0.0f, 0.0f, 1.0f, -pos.z,
    0.0f, 0.0f, 0.0f,    1.0f
  );

  mat4 UVN = mat4(
     U.x,  U.y,  U.z, 0.0f,
     V.x,  V.y,  V.z, 0.0f,
     N.x,  N.y,  N.z, 0.0f,
    0.0f, 0.0f, 0.0f, 1.0f
  );
  
  return UVN * translation;
}


// Support functions
GLfloat radians(GLfloat degrees){
  return ( degrees / 180.0f ) * PI;
}

vec2 normalize(vec2 vec){
  GLfloat n = sqrt(vec.x*vec.x + vec.y*vec.y);
  return vec2(vec.x/n, vec.y/n);
}
vec3 normalize(vec3 vec){
  GLfloat n = sqrt(vec.x*vec.x + vec.y*vec.y + vec.z*vec.z);
  return vec3(vec.x/n, vec.y/n, vec.z/n);
}
vec4 normalize(vec4 vec){
  GLfloat n = sqrt(vec.x*vec.x + vec.y*vec.y + vec.z*vec.z + vec.w*vec.w);
  return vec4(vec.x/n, vec.y/n, vec.z/n, vec.w/n);
}

vec3 cross(vec3 v1, vec3 v2){
  GLfloat x = v1.z*v2.y - v1.y*v2.z;
  GLfloat y = v1.x*v2.z - v1.z*v2.x;
  GLfloat z = v1.y*v2.x - v1.x*v2.y;
  return vec3(x, y, z);
}

void rotate(vec3 &vec, vec3 axis, GLfloat angle){
  const float sinHalfAngle = sin(radians(angle));
  const float cosHalfAngle = cos(radians(angle));
  
  const float Qx = axis.x * sinHalfAngle;
  const float Qy = axis.y * sinHalfAngle;
  const float Qz = axis.z * sinHalfAngle;
  const float Qw = cosHalfAngle;
  Quaternion rotation(Qx, Qy, Qz, Qw);
  
  Quaternion inverse = rotation.inverse();
  
  Quaternion result = rotation * vec * inverse;
  vec = vec3(result.x, result.y, result.z);
}