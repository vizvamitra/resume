// OpenGL
#include <GL\glew.h>
#include <GL\gl.h>
#include <GL\freeglut.h>
//#include <glm/glm.hpp>
//#include <glm/gtc/matrix_transform.hpp>

// C++
#include <vector>
#include <iostream>
#include <string.h>

// ImageMagick
#include <Magick++.h>

// Local
#include "types.h"
#include "program.h"
#include "model.h"
#include "pipeline.h"
#include "camera.h"
#include "light.h"

#include "variables.h"
#include "controls.h"

#pragma comment(lib, "freeglut.lib")
#pragma comment(lib, "glew32.lib")
#pragma comment(lib, "glew32mx.lib")
#pragma comment(lib, "glew32mxs.lib")
#pragma comment(lib, "CORE_RL_Magick++_.lib")
#pragma comment(lib, "CORE_RL_magick_.lib")
#pragma comment(lib, "CORE_RL_wand_.lib")