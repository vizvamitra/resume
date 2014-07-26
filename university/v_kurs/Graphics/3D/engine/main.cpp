#include "stdafx.h"

// Shader loading
#define GLSL(version, shader) "#version " #version "\n" #shader

// shaders
const char* vert = GLSL
( 
  330 core,
  layout( location = 0 ) in vec4 vPosition;
  layout( location = 1 ) in vec2 vTexture;
  layout( location = 2 ) in vec3 vNormal;
  
  out vec2 texCoord;
  out vec3 normal;
  out vec3 position;
  
  uniform mat4 world;
  uniform mat4 transform;
  
  void main()
  {
    gl_Position = transform * vPosition;
    texCoord = vTexture;
    normal = (world * vec4(vNormal, 0.0f)).xyz;
    position = (world * vPosition).xyz;
  }
);

const char* frag = GLSL
( 
  330 core,
  struct Light{
    vec3 color;
    float aIntensity;
    vec3 direction;
    float dIntensity;
  };
  
  struct Material{
    float cReflection;
    float specPower;
  };
  
  out vec4 fColor;
  
  in vec2 texCoord;
  in vec3 normal;
  in vec3 position;
  
  uniform sampler2D texUnit;
  uniform Light light;
  uniform vec3 cameraPos;
  
  uniform Material material;

  void main()
  {
    // ambient light;
    vec4 aColor = vec4(light.color, 1.0f) * light.aIntensity;
    
    // diffuse light
    vec4 dColor = vec4(0.0f, 0.0f, 0.0f, 0.0f);
    vec4 sColor = vec4(0.0f, 0.0f, 0.0f, 0.0f);;
    float dFactor = dot(normalize(normal), -light.direction);
    if (dFactor > 0){
      dColor = vec4(light.color, 1.0f) * light.dIntensity * dFactor;
      
      // specular light
      vec3 vToEye = normalize(cameraPos - position);
      vec3 vReflected = normalize(light.direction - 2 * normal * dot(normal, light.direction));
      float specFactor = dot(vToEye, vReflected);
      specFactor = pow(specFactor, material.specPower);
      if (specFactor > 0){
        sColor = vec4(light.color, 1.0f) * material.cReflection * specFactor;
      }      
    }

    fColor = texture(texUnit, texCoord) * (aColor + dColor + sColor);
  }  
);
  
void init(void)
{
  mesh = new Model("wall.obj", "wall.jpg");
  
  // Loading shaders
  Program program( vert, NULL, frag );
  program.use();
  
  // Getting uniform indices
  UniformIndices[Transform] = glGetUniformLocation(program.id(), "transform");
  UniformIndices[World] = glGetUniformLocation(program.id(), "world");
  UniformIndices[TexUnit] = glGetUniformLocation(program.id(), "texUnit");
  UniformIndices[LightColor] = glGetUniformLocation(program.id(), "light.color");
  UniformIndices[LightDirection] = glGetUniformLocation(program.id(), "light.direction");
  UniformIndices[AmbientLightIntensity] = glGetUniformLocation(program.id(), "light.aIntensity");
  UniformIndices[DiffuseLightIntensity] = glGetUniformLocation(program.id(), "light.dIntensity");
  UniformIndices[CameraPos] = glGetUniformLocation(program.id(), "cameraPos");
  UniformIndices[ReflectionCoef] = glGetUniformLocation(program.id(), "material.cReflection");
  UniformIndices[SpecPower] = glGetUniformLocation(program.id(), "material.specPower");
  
  // OpenGL settings
  glEnable(GL_DEPTH_TEST);
  glEnable(GL_CULL_FACE);
  glFrontFace(GL_CW);
  glCullFace(GL_BACK);
  
  // Application settings
  p.setPerspective(WINWIDTH, WINHEIGHT, 30.0f, 1.0f, 1000.0f);
  for (GLint i = 0; i<NumEvents; i++){
    events[i] = false;
  }
}

void display(void)
{
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  p.setCamera(camera.pos(), camera.target(), camera.up());
  mat4 transform = p.getTransform();
  mat4 world = p.getWorld();
  
  glUniformMatrix4fv(UniformIndices[Transform], 1, GL_TRUE, &transform[0]);
  glUniformMatrix4fv(UniformIndices[World], 1, GL_TRUE, &world[0]);
  
  glUniform1i(UniformIndices[TexUnit], 0);
  
  glUniform3f(UniformIndices[LightColor], light.color.x, light.color.y, light.color.z);
  glUniform1f(UniformIndices[AmbientLightIntensity], light.ambientIntensity);
  glUniform3f(UniformIndices[LightDirection], light.direction.x, light.direction.y, light.direction.z);
  glUniform1f(UniformIndices[DiffuseLightIntensity], light.diffuseIntensity);
  vec3 currentCameraPos = p.getCameraPos();
  glUniform3f(UniformIndices[CameraPos], currentCameraPos.x, currentCameraPos.y, currentCameraPos.z);
  glUniform1f(UniformIndices[ReflectionCoef], mesh->getReflectionCoef());
  glUniform1f(UniformIndices[SpecPower], mesh->getSpecPower());
  
  mesh->bind();
  
  glDrawArrays(GL_TRIANGLES, 0, mesh->size());

  glFlush();
  //~ frames++;
}

void idle(){
  glutPostRedisplay();
}

void timer(int value)
{
  if (events[Right])        if (events[Shift]) rotate(light.direction, vec3(0.0f, 0.0f, 1.0), -0.5f);
                            else p.rotate ( 0.0f, 1.0f, 0.0f);
  if (events[Left])         if (events[Shift]) rotate(light.direction, vec3(0.0f, 0.0f, 1.0), 0.5f);
                            else p.rotate ( 0.0f, -1.0f, 0.0f);
  if (events[Up])           if (events[Shift]) rotate(light.direction, vec3(1.0f, 0.0f, 0.0), 0.5f);
                            else p.rotate (-1.0f, 0.0f, 0.0f);
  if (events[Down])         if (events[Shift]) rotate(light.direction, vec3(1.0f, 0.0f, 0.0), -0.5f);
                            else p.rotate (1.0f, 0.0f, 0.0f);
  if (events[Plus])         if (events[Shift])light.changeIntensity(0.00f, 0.05f);
                            else light.changeIntensity(0.05f, 0.00f);
  if (events[Minus])        if (events[Shift])light.changeIntensity(0.00f, -0.05f);
                            else light.changeIntensity(-0.05f, 0.00f);
  if (events[W])            camera.onKeyboard('w');
  if (events[S])            camera.onKeyboard('s');
  if (events[A])            camera.onKeyboard('a');
  if (events[D])            camera.onKeyboard('d');
  if (events[Space])        camera.onKeyboard(' ');
  if (events[OpenBracket])  mesh->changeReflectionCoef(-0.1f);
  if (events[CloseBracket]) mesh->changeReflectionCoef(0.1f);
  if (events[Semicolon])    mesh->changeSpecPower(-1.0f);
  if (events[SingleQuote])  mesh->changeSpecPower(1.0f);
  if (events[Ctrl])         camera.onKeyboard((char)114);
  
  glutPostRedisplay();
  glutTimerFunc(20, timer, 0);
}

int main(int argc, char** argv)
{
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_RGBA);
  glutInitWindowSize(WINWIDTH, WINHEIGHT);
  glutInitContextVersion(3, 3);
  glutInitContextProfile(GLUT_CORE_PROFILE);
  glutCreateWindow(argv[0]);
  //glutEnterGameMode();
  glutWarpPointer(WINWIDTH/2, WINHEIGHT/2);
  
  glewExperimental = GL_TRUE;
  if (glewInit()) {
    std::cerr << "Unable to initialize GLEW ... exiting" << std::endl;
    exit(EXIT_FAILURE);
  }

  init();
  
  glutDisplayFunc(display);
  glutTimerFunc(20, timer, 0);
  
  initControlFuncs();

  glutMainLoop();
}