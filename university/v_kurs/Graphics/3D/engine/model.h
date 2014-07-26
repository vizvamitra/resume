#ifndef MODEL
#define MODEL

#include <vector>
#include <GL\gl.h>
#include "types.h"
#include "texture.h"
#include "material.h"

class Model{
public:
  Model(const char* fileName, const std::string& textureName){
    std::vector< vec3 > vertices, normals;
    std::vector< vec2 > texCoords;
    
    loadModelFromObj(fileName, vertices, normals, texCoords);
    m_numVertices = vertices.size();
    createVAO(vertices, normals, texCoords);
    loadTexture(textureName);
    
    m_modelMatrix = mat4(1.0f);
  }  
  ~Model(){
    delete m_texture;
  }
  
  void bind(){
    glBindVertexArray(m_VAO[0]);
    m_texture->bind(GL_TEXTURE0);
  }  
  mat4 modelMatrix(){
    return m_modelMatrix;
  }
  GLuint size(){
    return m_numVertices;
  }
  
  GLfloat getReflectionCoef(){
    return m_material.cReflection;
  }
  GLint getSpecPower(){
    return m_material.specPower;
  }
  void changeReflectionCoef(GLfloat value);
  void changeSpecPower(GLint value);
  void reset();

private:
  enum Buffer_IDs { Vertices, TexCoords, Normals, NumBuffers };
  enum Attrib_IDs { vPosition = 0 , vTexture = 1, vNormal = 2 };
  GLuint m_VAO[1];
  GLuint m_buffers[NumBuffers];
  Texture* m_texture;
  mat4 m_modelMatrix;
  GLuint m_numVertices;
  
  Material m_material;

  void createVAO(std::vector<vec3> &vertices,
                 std::vector<vec3> &normals,
                 std::vector<vec2> &texCoords);  
  void loadTexture(const std::string& textureName);  
  void loadModelFromObj(const char* fileName,
                        std::vector<vec3> &out_vertices,
                        std::vector<vec3> &out_normals,
                        std::vector<vec2> &out_uvs);
};

#include "model.cpp"
  
#endif