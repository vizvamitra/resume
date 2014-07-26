require 'matrix'
require "./line.rb"
require "./quad.rb"
require "./clipper.rb"
require "./transformer.rb"
require './mypack'

# paint modes
LINES = 2
QUADS = 4
# painter settings
ANTIALIASING = 1
DONT_SAVE = false
# draw modes
ALL = 1
NEW = 2

class Painter
  include MyPack, Clipper, Transformer, Line, Quad
  
  def initialize width, height, border
    @windowWidth = width
    @windowHeight = height
    @border = border
    
    @paintMode = nil
    
    # arrays containing new data
    @vertexBuffer, @colorBuffer = [], []
    
    # arrays with whole data
    @lineVertexArray, @lineColorArray = [], []
    @quadVertexArray, @quadColorArray = [], []
    
    # temp array for vertices data after clipping and transformations
    @resultVertexArray = []
    
    # color and render variables
    @red, @green, @blue = 1.0, 1.0, 1.0
    @antiAliasing = false
    
    # geometry matrix
    @viewMatrix2d = Matrix[
      [1.0, 0.0, 0.0],
      [0.0, 1.0, 0.0],
      [0.0, 0.0, 1.0],
    ]
  end

  def pDrawBegin type
    throw "Error: wrong argument" unless [LINES, QUADS].include?(type)
    @paintMode = type
    @vertexBuffer, @colorBuffer = [], []
  end
  
  def pDrawEnd save = true

    if save
      # Correction for shift
      i = 0
      while i < (@vertexBuffer.size - 1)
        x, y = getLocalCoords2d(@vertexBuffer[i], @vertexBuffer[i+1])
        case @paintMode
        when LINES
          @lineVertexArray << x << y
        when QUADS
          @quadVertexArray << x << y
        end
        i += 2
      end
      
      case @paintMode
      when LINES
        @lineColorArray += @colorBuffer
      when QUADS
        @quadColorArray += @colorBuffer
      end
    end
    
    if @paintMode == QUADS
      cPtr, vPtr = 0, 0
      tmpVArr, tmpCArr = [], []
      while vPtr < @vertexBuffer.size
        tmpVArr << @vertexBuffer[vPtr..vPtr+7]
        tmpCArr << @colorBuffer[cPtr..cPtr+11]
        
        vPtr+=8
        cPtr+=12
      end
      
      @vertexBuffer, @colorBuffer = tmpVArr, tmpCArr
    end
    
    # Отправка массива точек на рисование
    drawData(NEW)
    
    @vertexBuffer, @colorBuffer = [], []
    @paintMode = nil
  end

  def pVertex x, y
    paintModeCheck()
    @vertexBuffer << x.to_f << y.to_f
    @colorBuffer << @red << @green << @blue
  end
  
  def pColor r, g, b
    paintModeCheck()
    @red, @green, @blue = r, g, b
  end
  
  def pSet(flag, value)
    case flag
    when ANTIALIASING
      @antiAliasing = value
    end
  end
  
  def pSwitch flag
    case flag
    when ANTIALIASING
      @antiAliasing ? @antiAliasing = false : @antiAliasing = true
    end
  end
  
  def pClearData
    @lineVertexArray, @lineColorArray = [], []
    @quadVertexArray, @quadColorArray = [], []
  end
  
  def pDraw
    drawData(ALL)
  end
  
private
  
  def paintModeCheck
    throw "Error: funtion called not inside drawBegin() - drawEnd()" if @paintMode.nil?
  end
  
  def drawData mode
    case mode
    when NEW
      drawArray(@vertexBuffer, @colorBuffer, @paintMode)
    when ALL
      @tempLineVertexArray = []
      @tempQuadVertexArray = []
      
      @resultVertexArray = []
      @resultColorArray = []
      
      # Lines array processing
      a = Thread.new{
        @tempLineVertexArray = transformArray2d(@lineVertexArray)
        @resultLineVertexArray, @resultLineColorArray = clipLines(@tempLineVertexArray, @lineColorArray)
      }      
      # quads array processing
      b = Thread.new{
        @tempQuadVertexArray = transformArray2d(@quadVertexArray)
        @resultQuadVertexArray, @resultQuadColorArray = clipQuads(@tempQuadVertexArray, @quadColorArray)
      }      
      a.join
      b.join
      
      drawArray(@resultLineVertexArray, @resultLineColorArray, LINES)
      drawArray(@resultQuadVertexArray, @resultQuadColorArray, QUADS)
    end
  end
  
  def processArray vertexArray, colorArray, mode
    vertexData, colorData = [], []

    vPtr = 0
    cPtr = 0
    
    case mode
    when LINES
      begin
        while vPtr < vertexArray.size && cPtr < colorArray.size
          points, colors = line *vertexArray[vPtr..(vPtr+3)], *colorArray[cPtr..(cPtr+5)]
          vertexData += points
          colorData += colors
          vPtr+=4
          cPtr+=6
        end
      rescue ArgumentError
      end
    when QUADS
      begin
        while vPtr < vertexArray.size && cPtr < colorArray.size
          points, colors = quad(vertexArray[vPtr], colorArray[cPtr])
          vertexData += points
          colorData += colors
          vPtr += 1
          cPtr += 1
        end
      rescue ArgumentError
      end
    end
  
    return vertexData, colorData
  end
  
  def drawArray vertexArray, colorArray, mode
    # формирование массива точек с учётом отсечения
    vertexData, colorData = processArray(vertexArray, colorArray, mode)
    
    posBuf = '        '
    glGenBuffers(2, posBuf)
    
    glBindBuffer(GL_ARRAY_BUFFER, posBuf.unpack("L2")[0])
    glBufferData(GL_ARRAY_BUFFER,4*vertexData.size,pack(vertexData),GL_STATIC_DRAW)
    glVertexPointer(2, GL_FLOAT, 0, 0)

    glBindBuffer(GL_ARRAY_BUFFER, posBuf.unpack("L2")[1])
    glBufferData(GL_ARRAY_BUFFER,4*colorData.size,pack(colorData),GL_STATIC_DRAW)
    glColorPointer(3, GL_FLOAT, 0, 0)

    glEnableClientState(GL_VERTEX_ARRAY)
    glEnableClientState(GL_COLOR_ARRAY);

    glDrawArrays(GL_LINES, 0, vertexData.size/2);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    
    #glDeleteBuffers(2, posBuf)
    #~ glDeleteBuffers(1, posBuf)
  end
end

module PainterBindings
  def pDrawBegin type
    @painter.pDrawBegin type
  end
  
  def pDrawEnd save = true
    @painter.pDrawEnd save
  end
  
  def pVertex x, y
    @painter.pVertex x, y
  end
  
  def pColor r, g, b
    @painter.pColor r, g, b
  end
  
  def pSet flag, value
    @painter.pSet flag, value
  end
  
  def pSwitch(flag)
    @painter.pSwitch flag
  end
  
  def pClearData
    @painter.pClearData
  end
  
  def pDraw
    @painter.pDraw
  end
  
  ##### Geometry #####
  
  def pShift2d tx, ty
    @painter.pShift2d tx, ty
  end
  
  def pScale2d sx, sy
    @painter.pScale2d sx, sy
  end
  
  def pRotate2d angle
    @painter.pRotate2d angle
  end
  
  def pResetView
    @painter.pResetView
  end
end