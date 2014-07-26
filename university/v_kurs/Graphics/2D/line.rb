module Line

  def line x1,y1, x2,y2, r1,g1,b1, r2,g2,b2
    @vertexData, @colorData = [], []
    x1 = x1.to_i
    y1 = y1.to_i
    x2 = x2.to_i
    y2 = y2.to_i
    if x1==x2 || y1 == y2
      strightLine x1,y1, x2,y2, r1,g1,b1, r2,g2,b2
    else
      x1,y1, x2,y2, r1,g1,b1, r2,g2,b2 = coordsFix(x1,y1, x2,y2, r1,g1,b1, r2,g2,b2)
      if @antiAliasing
        aaAngleLine(x1, y1, x2, y2, r1,g1,b1, r2,g2,b2)
      else
        angleLine(x1, y1, x2, y2, r1,g1,b1, r2,g2,b2)
      end
    end
    return @vertexData, @colorData
  end
  
private

  def angleLine x1,y1, x2,y2, r1,g1,b1, r2,g2,b2
    dx = x2 - x1
    dy = (y2-y1).abs
    error = dx/2
    ystep = (y1 < y2) ? 1 : -1
    y = y1
    rStep = (r2-r1).to_f/(dx-1)
    gStep = (g2-g1).to_f/(dx-1)
    bStep = (b2-b1).to_f/(dx-1)
    r, g, b = r1, g1, b1
    
    x1.upto(x2) do |x|
      putPixel x, y, r, g, b
      error -= dy
      if error < 0
        y += ystep
        error += dx
      end
      r += rStep
      g += gStep
      b += bStep
    end
  end
  
  def aaAngleLine x1,y1, x2,y2, r1,g1,b1, r2,g2,b2
    dx = x2 - x1
    dy = y2 - y1
    gradient = dy.to_f / dx.to_f
    y = y1 + gradient
    rStep = (r2-r1).to_f/(dx-1)
    gStep = (g2-g1).to_f/(dx-1)
    bStep = (b2-b1).to_f/(dx-1)
    r, g, b = r1, g1, b1
    
    putPixel x1, y1, r1, g1, b1
    putPixel x2, y2, r2, g2, b2
    (x1+1).upto(x2-1) do |x|
      putPixel x, y.to_i, r*(1 - floatPart(y)), g*(1 - floatPart(y)), b*(1 - floatPart(y))
      putPixel x, y.to_i+1, r*floatPart(y), g*floatPart(y), b*floatPart(y)
      y += gradient
      r += rStep
      g += gStep
      b += bStep
    end
  end
    
  def strightLine x1,y1, x2,y2, r1,g1,b1, r2,g2,b2
    @steep = false
    if x1==x2
      y1, y2, r1,g1,b1, r2,g2,b2 = y2, y1, r2,g2,b2, r1,g1,b1 if y1 > y2
      
      rStep = (r2-r1).to_f/(y2-y1-1)
      gStep = (g2-g1).to_f/(y2-y1-1)
      bStep = (b2-b1).to_f/(y2-y1-1)
      r, g, b = r1, g1, b1
      
      y1.upto(y2) do |y|
        putPixel x1, y, r, g, b
        r += rStep
        g += gStep
        b += bStep
      end
    else
      x1, x2, r1,g1,b1, r2,g2,b2 = x2, x1, r2,g2,b2, r1,g1,b1 if x1 > x2
      
      rStep = (r2-r1).to_f/(x2-x1-1)
      gStep = (g2-g1).to_f/(x2-x1-1)
      bStep = (b2-b1).to_f/(x2-x1-1)
      r, g, b = r1, g1, b1
      
      x1.upto(x2) do |x|
        putPixel x, y1, r, g, b
        r += rStep
        g += gStep
        b += bStep
      end
    end
  end
  
  def coordsFix x1,y1, x2,y2, r1,g1,b1, r2,g2,b2
    @steep = (y2-y1).abs > (x2-x1).abs
    if @steep
      x1, y1 = y1, x1
      x2, y2 = y2, x2
    end
    if x2 < x1
      x1, x2 = x2, x1
      y1, y2 = y2, y1
      r1,g1,b1, r2,g2,b2 = r2,g2,b2, r1,g1,b1
    end
    return x1,y1, x2,y2, r1,g1,b1, r2,g2,b2
  end
  
  def putPixel x, y, r=1, g=1, b=1
    x, y = y, x if @steep
    
    @colorData << r << g << b
    @vertexData << x << y
    @colorData << r << g << b
    @vertexData << x-0.5 << y
    @colorData << r << g << b
    @vertexData << x-0.5 << y-0.5
    @colorData << r << g << b
    @vertexData << x << y-0.5
  end
  
  def floatPart x
    x - x.to_i
  end
end