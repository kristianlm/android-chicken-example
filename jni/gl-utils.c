
#include <stdio.h>

#include <EGL/egl.h>
#include <GLES/gl.h>


 void DrawSprite(/*GLuint sprite,*/ float X, float Y, float Z, float W, float H)
{
  // glBindTexture(GL_TEXTURE_2D,sprite);
 
  
  W /= 2.0;
  H /= 2.0;

  GLfloat box[] = {X - W, Y - H,  Z,
                   X - W, Y + H,  Z,
                   X + W, Y - H,  Z, 
                   X + W, Y + H,  Z};

  //  GLfloat tex[] = {0,0, 1,0, 1,1, 0,1};
  glEnableClientState(GL_VERTEX_ARRAY);
  //  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
 
  glVertexPointer(3, GL_FLOAT, 0, box);
  //  glTexCoordPointer(2, GL_FLOAT, 0, tex);
 
  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
 
  glDisableClientState(GL_VERTEX_ARRAY);
  //  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
}
