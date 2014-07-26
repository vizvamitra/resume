LEFT = 0b0001
RIGHT = 0b0010
BOTTOM = 0b0100
TOP = 0b1000

module Clipper

private
  
  ######## Lines ########
  
  def clipLines vertexArray, colorArray
    resultVertexArray, resultColorArray = [], []
    vPtr = 0
    cPtr = 0
    while vPtr < vertexArray.size
      if vPtr+3 >= vertexArray.size
        return resultVertexArray, resultColorArray
      end
        
      v1, v2 =  expressTest *vertexArray[vPtr..vPtr+3]      
      if v1 == 0 && v2 == 0
        resultVertexArray += vertexArray[vPtr..vPtr+3]
        resultColorArray += colorArray[cPtr..cPtr+5]
      elsif (v1 & v2).zero?
        coords, colors = rectangleClip(vertexArray[vPtr..vPtr+3], colorArray[cPtr..cPtr+5], v1, v2)
        resultVertexArray += coords
        resultColorArray += colors
      else
        # do nothing
      end
      
      vPtr += 4
      cPtr += 6
    end
    
    return resultVertexArray, resultColorArray
  end

  def expressTest x1,y1, x2,y2
    v1 = 0b0000
    v2 = 0b0000
    
    v1 |= LEFT if x1 < (@border)
    v1 |= RIGHT if x1 > (@windowWidth - @border)
    v1 |= BOTTOM if y1 > (@windowHeight - @border)
    v1 |= TOP if y1 < (@border)
    
    v2 |= LEFT if x2 < (@border)
    v2 |= RIGHT if x2 > (@windowWidth - @border)
    v2 |= BOTTOM if y2 > (@windowHeight - @border)
    v2 |= TOP if y2 < (@border)
    
    return v1, v2
  end
  
  def rectangleClip coords, colors, v1, v2
    x1,y1, x2,y2 =  coords
    r1,g1,b1, r2,g2,b2 = colors
    
    while (v1 | v2).nonzero?      
      if v1 > 0
        code = v1
        vertex = [x1, y1]
        color = [r1, g1, b1]
        n = 1
      elsif v2 > 0
        code = v2
        vertex = [x2, y2]
        color = [r2, g2, b2]
        n = 2
      end
      
      if (code & LEFT).nonzero?
        mul = (@border - vertex[0]).to_f/(x1 - x2)
        vertex[1] += (y1 - y2) * mul
        vertex[0] = @border + 1
      elsif (code & RIGHT).nonzero?
        mul = (@windowWidth - @border - vertex[0]).to_f/(x1 - x2)
        vertex[1] += (y1 - y2) * mul
        vertex[0] = @windowWidth - @border
      elsif (code & BOTTOM).nonzero?
        mul = (@windowHeight - @border - vertex[1]).to_f/(y1 - y2)
        vertex[0] += (x1 - x2) * mul
        vertex[1] = @windowHeight - @border
      elsif (code & TOP).nonzero?
        mul = (@border - vertex[1]).to_f/(y1 - y2)
        vertex[0] += (x1 - x2) * mul
        vertex[1] = @border
      end
      vertex[0] = (vertex[0]+0.5).to_i
      vertex[1] = (vertex[1]+0.5).to_i
      color[0] += (r1 - r2) * mul
      color[1] += (g1 - g2) * mul
      color[2] += (b1 - b2) * mul
      
      if n == 1
        x1, y1 = *vertex
        r1,g1,b1 = *color
      else
        x2, y2 = *vertex
        r2, g2, b2 = *color
      end
      
      v1, v2 = expressTest x1, y1, x2, y2      
      return [], [] unless (v1 & v2).zero? # line is out of frame      
      if v1 == 0 && v2 == 0
        return [x1, y1, x2, y2], [r1, g1, b1, r2, g2, b2]
      end
    end
  end
  
  ######## Quads ########
  
  def clipQuads vertexArray, colorArray
    resultVertexArray, resultColorArray = [], []
    vPtr, cPtr = 0, 0
    
    while vPtr < vertexArray.size
      resultVertexArray << vertexArray[vPtr..vPtr+7]
      resultColorArray << colorArray[cPtr..cPtr+11]
      
      vPtr+=8
      cPtr+=12
    end
    
    return resultVertexArray, resultColorArray
  end
end