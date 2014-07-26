module Quad
  def quad quadArray, colorArray
    vResult, cResult = [], []
    
    vPtr, cPtr = 0, 0
    while vPtr < quadArray.size - 3
      points, colors = line(*quadArray[vPtr..vPtr+3], *colorArray[cPtr..vPtr+5])
      vResult += points
      cResult += colors
      
      vPtr+=2
      cPtr+=3
    end
    points, colors = line(*quadArray[-2..-1],*quadArray[0..1], *colorArray[-3..-1], *colorArray[0..2])
    vResult += points
    cResult += colors
    
    return vResult, cResult
  end
end