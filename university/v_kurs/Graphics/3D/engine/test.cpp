#include <glm/glm.hpp>
#include <iostream>

#include "types.h"
#include "light.h"

using namespace std;

int main(int argc, char** argv){
  //~ glm::vec4 f(1.0f, 2.0f, 3.0f, 1.0f);
  //~ glm::vec4 b(4.0f, 5.0f, 6.0f, 0.5f);
  
  //~ f*=0.5;
  
  //~ cerr<<f.x<<" "<<f.y<<" "<<f.z<<" "<<f.w<<"\n";
  
  Light light;
  light.color.print();
}

