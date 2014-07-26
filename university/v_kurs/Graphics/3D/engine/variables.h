#define WINWIDTH  1280
#define WINHEIGHT 1024

// Uniforms
enum UniformIndex_IDs { Transform, World, TexUnit, LightColor,
                        LightDirection, AmbientLightIntensity,
                        DiffuseLightIntensity, CameraPos,
                        ReflectionCoef, SpecPower,
                        NumUniforms };
GLuint UniformIndices[NumUniforms];

// Event control
enum {W, S, A, D, Left, Right, Up, Down, Plus, Minus, Shift,
      Space, Ctrl, OpenBracket, CloseBracket, Semicolon, SingleQuote,
      NumEvents};
GLboolean events[NumEvents];

// Data info
Model* mesh;

// Engine variables
Pipeline p;
Camera camera(WINWIDTH, WINHEIGHT);
Lightning light;

// Test variables
GLuint frames;