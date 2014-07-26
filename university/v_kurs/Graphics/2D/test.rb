#! /usr/bin/ruby

require 'mathn'
include Math

class Test
  
  def initialize
    @viewMatrix2d = [
      [1.0, 0.0, 0.0],
      [0.0, 1.0, 0.0],
      [0.0, 0.0, 1.0],
    ]
    
    @array = []
  end
  
  def pShift2d tx, ty
    @viewMatrix2d[2][0] += tx
    @viewMatrix2d[2][1] += ty
  end
  
  def pScale2d sx, sy
    @viewMatrix2d[0][0] *= sx.to_f unless sx.zero?
    @viewMatrix2d[1][1] *= sy.to_f unless sy.zero?
  end
  
  def pRotate2d angle
    @viewMatrix2d[0][0] = cos(acos(@viewMatrix2d[0][0]) + angle)
    @viewMatrix2d[1][0] = -sin(acos(@viewMatrix2d[1][0]) + angle)
    @viewMatrix2d[0][1] = sin(acos(@viewMatrix2d[0][1]) + angle)
    @viewMatrix2d[1][1] = cos(acos(@viewMatrix2d[1][1]) + angle)
  end
  
  def transformArray array
    result = []
    
    ptr = 0
    while ptr < array.size
      break if ptr+1 >= array.size
      x,y = getTransformedCoords2d(array[ptr], array[ptr+1])
      result << x << y
      ptr+=2
    end
    return result
  end
  
  def getTransformedCoords2d x, y
    x = x*@viewMatrix2d[0][0] + y*@viewMatrix2d[1][0] + 1*@viewMatrix2d[2][0]
    y = x*@viewMatrix2d[0][1] + y*@viewMatrix2d[1][1] + 1*@viewMatrix2d[2][1]
    w = x*@viewMatrix2d[0][2] + y*@viewMatrix2d[1][2] + 1*@viewMatrix2d[2][2]
    x /= w
    y /= w
    return x, y
  end
  
  def getLocalCoords x, y
    m = Matrix[*@viewMatrix2d].inverse.to_a
    x = x*m[0][0] + y*m[1][0] + 1*m[2][0]
    y = x*m[0][1] + y*m[1][1] + 1*m[2][1]
    w = x*m[0][2] + y*m[1][2] + 1*m[2][2]
    x /= w
    y /= w
    return x, y
  end
  
  def addVertex x, y
    @array << x << y
  end
  
  def test
    @array = transformArray @array
    @array[0], @array[1] = getLocalCoords @array[0], @array[1]
    @array[2..3] = getLocalCoords @array[2], @array[3]
    @array
  end
  
  
end

def to_rad a
  (a/180)*PI
end

def to_deg a
  (a/PI)*180
end

t = Test.new
t.pShift2d 2, 0
t.pScale2d 2, 2
t.addVertex 0, 0
t.addVertex 1, 3
p t.test