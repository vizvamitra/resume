#!/usr/bin/env ruby
#encoding: ISO-8859-1
require 'opengl'
require 'glut'
require 'glu'
include OpenGL,GLU,GLUT
OpenGL.load_dll( 'libGL.so', '/usr/lib' )
GLUT.load_dll( 'libglut.so', '/usr/lib' )
# my modules
require './painter.rb'

class Engine
  include PainterBindings
  
  def initialize width, height
    # window params
    @windowWidth = width
    @windowHeight = height
    @border = 20
    # creating painter
    @painter = Painter.new(@windowWidth, @windowHeight, @border)
    # setting initial settings =)
    initGL()
    initScreen()
    # launck program
    glutMainLoop()
  end   
  
  def clearScreen
    # clearing data arrays
    pClearData()
    pResetView()
    # redrawing scene
    glutPostRedisplay()
    glutSwapBuffers()
  end
  
  def draw
    glPushMatrix()
    glClear(GL_COLOR_BUFFER_BIT)
    glBegin(GL_LINE_LOOP)
      glColor3f(1,1,1)
      glVertex2f(@border-1, @border-1)
      glVertex2f(@windowWidth-@border+1, @border-1)
      glVertex2f(@windowWidth-@border+1, @windowHeight-@border+1)
      glVertex2f(@border-1, @windowHeight-@border+1)
    glEnd()
    pDraw()
    glPopMatrix()
    glutSwapBuffers()
  end

  def initGL
    glutInit([1].pack('I'), [""].pack('p'))
    
    glutInitDisplayMode(GLUT_DOUBLE|GLUT_RGB)
    glutInitWindowSize(@windowWidth,@windowHeight)
    glutInitWindowPosition(600, 150)
    
    @window = glutCreateWindow("Vizvamitra's Engine")
    
    glutDisplayFunc( GLUT.create_callback(:GLUTDisplayFunc, method(:draw).to_proc) )
    #glutIdleFunc( GLUT.create_callback(:GLUTIdleFunc, method(:idle).to_proc) )
    glutKeyboardFunc( GLUT.create_callback(:GLUTKeyboardFunc, method(:keyboard).to_proc) )
    glutSpecialFunc( GLUT.create_callback(:GLUTSpecialFunc, method(:sKeyboard).to_proc) )
    glutMouseFunc( GLUT.create_callback(:GLUTMouseFunc, method(:mousePressed).to_proc) )
    glutPassiveMotionFunc( GLUT.create_callback(:GLUTPassiveMotionFunc, method(:mouseMoved).to_proc) )
    glutMotionFunc( GLUT.create_callback(:GLUTMotionFunc, method(:mousePressedMove).to_proc) )
    #glutTimerFunc 20, GLUT.create_callback(:GLUTTimerFunc, method(:timer).to_proc), 0
    
    glPointSize(1)
  end
  
  def initScreen
    glClearColor(0.0, 0.0, 0.0, 1.0)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    glOrtho(0.0, @windowWidth, @windowHeight, 0.0, -1.0, 1.0)
    glMatrixMode(GL_MODELVIEW)
  end
  
  def timer val=0
    pDrawBegin(LINES)
      pColor(1.0, 0.5, 0.5)
      pVertex(@startX, @startY)
      pColor(0.5, 1.0, 0.5)
      pVertex(@endX, @endY)
    pDrawEnd(DONT_SAVE)
    glutSwapBuffers()
    @timer = false
  end
  
  def keyboard key, x, y
    case key
    when 27 # ESC
      glutDestroyWindow @window
      exit 0
    when 99 # "c"
      clearScreen()
    when 97 # "a"
      pSwitch(ANTIALIASING)
      glutPostRedisplay()
    when 91 # "["
      pRotate2d (Math::PI / 16)
      glutPostRedisplay()
    when 93 # "]"
      pRotate2d -(Math::PI / 16)
      glutPostRedisplay()
    when 114 # "r"
      pResetView()
      glutPostRedisplay()
    else
      p key
    end
  end
  
  def sKeyboard key, x, y
    case key
    when GLUT_KEY_UP
      pShift2d(0, 5)
    when GLUT_KEY_DOWN 
      pShift2d(0, -5)
    when GLUT_KEY_LEFT
      pShift2d(5, 0)
    when GLUT_KEY_RIGHT
      pShift2d(-5, 0)
    end
    glutPostRedisplay()
  end
  
  def mousePressed button, state, x, y
    case button
    when GLUT_LEFT_BUTTON
      if state == GLUT_DOWN
        @startX, @startY = x, y
        @endX, @endY = x, y
        @leftButton = true
      else
        pDrawBegin(LINES)
          pColor(1.0, 0.5, 0.5)
          pVertex(@startX, @startY)
          pColor(0.5, 1.0, 0.5)
          pVertex(@endX, @endY)
        pDrawEnd()
        glutPostRedisplay()
        @timer = false
        @leftButton = false
      end
    #~ when GLUT_RIGHT_BUTTON ########### temporary
      #~ if state == GLUT_DOWN
        #~ @startX, @startY = x, y
        #~ @endX, @endY = x, y
        #~ @rightButton = true
      #~ else
        #~ pDrawBegin(QUADS)
          #~ pVertex(@startX, @startY)
          #~ pVertex(@endX, @startY)
          #~ pVertex(@endX, @endY)
          #~ pVertex(@startX, @endY)
        #~ pDrawEnd()
        #~ glutPostRedisplay()
        #~ @timer2 = false
        #~ @rightButton = false
      #~ end############################
    when 3 # wheel up
      if state == GLUT_DOWN
        pScale2d(2, 2)
        glutPostRedisplay()
      end
    when 4 # wheel down
      if state == GLUT_DOWN
        pScale2d(0.5, 0.5)
        glutPostRedisplay()
      end
    end
  end
    
  def mousePressedMove x, y
    @endX = x
    @endY = y
    glutPostRedisplay() if !@timer && @leftButton
    glutTimerFunc 10, GLUT.create_callback(:GLUTTimerFunc, method(:timer).to_proc), 0 if !@timer && @leftButton
    @timer = true if @leftButton
  end
  
  def mouseMoved ax, ay
    glutSetWindowTitle("x: #{ax}, y: #{ay}")
  end
    
  #~ def idle
    #~ glutPostRedisplay()
  #~ end
 
end

#~ $time = Time.now
app = Engine.new(512, 512)
