#ifndef PROGRAM
#define PROGRAM

#include <GL\gl.h>

class Program
{
public:
  Program( const char* vert, const char* geom, const char* frag )
  {
    GLuint prog = glCreateProgram();
    if( vert ) AttachShader( prog, GL_VERTEX_SHADER, vert );
    if( geom ) AttachShader( prog, GL_GEOMETRY_SHADER, geom );
    if( frag ) AttachShader( prog, GL_FRAGMENT_SHADER, frag );
    glLinkProgram( prog );
    CheckStatus( prog );
    m_program = prog;
  }
  
  void use(){
    glUseProgram(m_program);
  }
  
  GLuint id(){
    return m_program;
  }

private:
  GLuint m_program;

  void CheckStatus( GLuint obj )
  {
    GLint status = GL_FALSE, len = 10;
    if( glIsShader(obj) )   glGetShaderiv( obj, GL_COMPILE_STATUS, &status );
    if( glIsProgram(obj) )  glGetProgramiv( obj, GL_LINK_STATUS, &status );
    if( status == GL_TRUE ) return;
    if( glIsShader(obj) )   glGetShaderiv( obj, GL_INFO_LOG_LENGTH, &len );
    if( glIsProgram(obj) )  glGetProgramiv( obj, GL_INFO_LOG_LENGTH, &len );
    std::vector< char > log( len, 'X' );
    if( glIsShader(obj) )   glGetShaderInfoLog( obj, len, NULL, &log[0] );
    if( glIsProgram(obj) )  glGetProgramInfoLog( obj, len, NULL, &log[0] );
    std::cerr << &log[0] << std::endl;
    exit( -1 );
  }

  void AttachShader( GLuint program, GLenum type, const char* src )
  {
    GLuint shader = glCreateShader( type );
    glShaderSource( shader, 1, &src, NULL );
    glCompileShader( shader );
    CheckStatus( shader );
    glAttachShader( program, shader );
    glDeleteShader( shader );
  }
};

#endif