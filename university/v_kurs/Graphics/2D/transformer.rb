module Transformer
include Math

public

  def pShift2d tx, ty
    m = Matrix[
      [1.0, 0.0, 0.0],
      [0.0, 1.0, 0.0],
      [ tx,  ty, 1.0]
    ]
    @viewMatrix2d = (@viewMatrix2d * m)
  end
  
  def pScale2d sx, sy
    m = Matrix[
      [ sx, 0.0, 0.0],
      [0.0,  sy, 0.0],
      [0.0, 0.0, 1.0]
    ]
    @viewMatrix2d = (@viewMatrix2d * m)
  end
  
  def pRotate2d angle
    unless angle.zero?
      m = Matrix[
        [cos(angle), -sin(angle), 0],
        [sin(angle), cos(angle), 0],
        [0, 0, 1]
      ]
      @viewMatrix2d = (@viewMatrix2d * m)
    end
  end
  
  def pResetView
    @viewMatrix2d = Matrix[
      [1.0, 0.0, 0.0],
      [0.0, 1.0, 0.0],
      [0.0, 0.0, 1.0],
    ]
  end
  
private

  def transformArray2d array
    result = []
    
    ptr = 0
    while ptr < array.size
      break if ptr+1 > array.size
      x,y = getTransformedCoords2d array[ptr], array[ptr+1]
      result << x << y
      ptr+=2
    end
    return result
  end
  
  def getTransformedCoords2d x, y
    m = (Matrix[[x, y, 1]] * @viewMatrix2d)
    x = m[0,0]/m[0,2]
    y = m[0,1]/m[0,2]
    return x, y
  end
  
  def getLocalCoords2d x, y
    xyw = Matrix[[x, y, 1]] * @viewMatrix2d.inv
    x = xyw[0,0] / xyw[0,2]
    y = xyw[0,1] / xyw[0,2]
    return x, y
  end
end