void Model::createVAO(std::vector<vec3> &vertices,
               std::vector<vec3> &normals,
               std::vector<vec2> &texCoords)
{
  glGenVertexArrays(1, m_VAO);
  glBindVertexArray(m_VAO[0]);    
  glGenBuffers(NumBuffers, m_buffers);
  
  glBindBuffer(GL_ARRAY_BUFFER, m_buffers[Vertices]);
  glBufferData(GL_ARRAY_BUFFER, vertices.size() * sizeof(vec4), 
               &vertices[0], GL_STATIC_DRAW);                 
  glVertexAttribPointer(vPosition, 3, GL_FLOAT, GL_FALSE, 0, (void*)(0) );
  glEnableVertexAttribArray(vPosition);
  
  glBindBuffer(GL_ARRAY_BUFFER, m_buffers[TexCoords]);
  glBufferData(GL_ARRAY_BUFFER, texCoords.size() * sizeof(vec2), 
               &texCoords[0], GL_STATIC_DRAW);
  glVertexAttribPointer(vTexture, 2, GL_FLOAT, GL_FALSE, 0, (void*)(0) );
  glEnableVertexAttribArray(vTexture);
  
  glBindBuffer(GL_ARRAY_BUFFER, m_buffers[Normals]);
  glBufferData(GL_ARRAY_BUFFER, normals.size() * sizeof(vec3), 
               &normals[0], GL_STATIC_DRAW);
  glVertexAttribPointer(vNormal, 3, GL_FLOAT, GL_FALSE, 0, (void*)(0) );
  glEnableVertexAttribArray(vNormal);
}

void Model::loadTexture(const std::string& textureName){
  m_texture = new Texture(GL_TEXTURE_2D, textureName);
  if (!m_texture->load()) {
    std::cerr<<"ERROR: couldn't load texture\n";
    exit(EXIT_FAILURE);
  }  
}

void Model::loadModelFromObj(const char* fileName,
                             std::vector<vec3> &out_vertices,
                             std::vector<vec3> &out_normals,
                             std::vector<vec2> &out_uvs)
{
  std::vector< vec3 > temp_vertices, temp_normals;
  std::vector< vec2 > temp_uvs;
  FILE * file = fopen(fileName, "r");
  if( file == NULL ){
    printf("Impossible to open the file !\n");
    exit(0);
  }
  while( 1 ){ 
    char lineHeader[128];
    // read the first word of the line
    int res = fscanf(file, "%s", lineHeader);
    if (res == EOF)
      break; // EOF = End Of File. Quit the loop.
 
    // else : parse lineHeader
    if ( strcmp( lineHeader, "v" ) == 0 ){
      vec3 vertex;
      fscanf(file, "%f %f %f\n", &vertex.x, &vertex.y, &vertex.z );
      temp_vertices.push_back(vertex);
    } else if ( strcmp( lineHeader, "vt" ) == 0 ){
      vec2 uv;
      fscanf(file, "%f %f\n", &uv.x, &uv.y );
      temp_uvs.push_back(uv);
    } else if (strcmp( lineHeader, "vn" ) == 0) {
      vec3 normal;
      fscanf(file, "%f %f %f\n", &normal.x, &normal.y, &normal.z );
      temp_normals.push_back(normal);
    } else if ( strcmp( lineHeader, "f" ) == 0 ){
      unsigned int vertexIndex[3];
      unsigned int uvIndex[3];
      unsigned int normalIndex[3];
      int matches = fscanf(file, "%d/%d/%d %d/%d/%d %d/%d/%d\n",
                           &vertexIndex[0],&uvIndex[0],&normalIndex[0],
                           &vertexIndex[1],&uvIndex[1],&normalIndex[1],
                           &vertexIndex[2],&uvIndex[2],&normalIndex[2]);
      if (matches != 9){
        printf("File can't be read by our simple parser : ( Try exporting with other options\n");
        exit(1);
      }
      out_vertices.push_back(temp_vertices[ vertexIndex[0]-1 ]);
      out_uvs.push_back(temp_uvs[ uvIndex[0]-1 ]);
      out_normals.push_back(temp_normals[ normalIndex[0]-1 ]);
      
      out_vertices.push_back(temp_vertices[ vertexIndex[1]-1 ]);
      out_uvs.push_back(temp_uvs[ uvIndex[1]-1 ]);
      out_normals.push_back(temp_normals[ normalIndex[1]-1 ]);
      
      out_vertices.push_back(temp_vertices[ vertexIndex[2]-1 ]);
      out_uvs.push_back(temp_uvs[ uvIndex[2]-1 ]);
      out_normals.push_back(temp_normals[ normalIndex[2]-1 ]);
    }
  }
}

void Model::changeReflectionCoef(GLfloat value){
  m_material.cReflection += value;
  if (m_material.cReflection < 0){
    m_material.cReflection = 0;
  }
}
void Model::changeSpecPower(GLint value){
  m_material.specPower += value;
  if (m_material.specPower < 1){
    m_material.specPower = 1;
  }
}
void Model::reset(){
  m_material.reset();  
}