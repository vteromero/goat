function init_particles()
  part={}
end

function update_particles()
  update_anis(part)
end

function draw_particles()
  draw_anis(part)
end

function upd_pos(p)
  p.x+=p.dx
  p.y+=p.dy
end

function spawn_breakp(x,y)
  for i=1,5 do
    add(part,create_ani(0,15,{
      x=x,
      y=y,
      dx=rnd()*2-1,
      dy=rnd()*2-1,
      upd=upd_pos,
      drw=function(self)
        pset(self.x,self.y,5)
      end,
    }))
  end
end

function spawn_smokep(x,y)
  for i=1,5 do
    add(part,create_ani(0,20+rnd(20),{
      x=x,
      y=y,
      r=rnd(0.5),
      dx=rnd(0.2)-0.1,
      dy=-rnd(0.2),
      dr=0.1,
      fillp=nil,
      upd=upd_smokep,
      drw=drw_smokep,
    }))
  end
end

function spawn_dustcloud(x,y)
  for i=1,20 do
    local ang=rnd()
    local dx,dy=cos(ang),sin(ang)
    add(part,create_ani(0,20,{
      x=x+4*dx,
      y=y+4*dy,
      r=rnd(0.3),
      dx=0.5*dx,
      dy=0.5*dy,
      dr=0.1,
      fillp=nil,
      upd=upd_smokep,
      drw=drw_smokep,
    }))
  end
end

function upd_smokep(p)
  local f=p.mage-p.age
  p.x+=p.dx+((board and board.ani) and board.ani.dx or 0)
  p.y+=p.dy+((board and board.ani) and board.ani.dy or 0)
  p.r+=p.dr
  if f<5 then
    p.fillp=0b0111111111011111.1
  elseif f<10 then
    p.fillp=0b1010010110100101.1
  end
end

function drw_smokep(p)
  local x0,x1=p.x-p.r,p.x+p.r
  local y0,y1=p.y-p.r,p.y+p.r
  if p.fillp then
    fillp(p.fillp)
  end
  ovalfill(x0,y0,x1,y1,13)
  ovalfill(x0,y0,x1-1,y1-1,6)
  fillp()
end

function spawn_scorepopup(x,y,val,c0,c1)
  add(part,create_ani(0,20,{
    s=tostr(val),
    x=x,
    y=y,
    c0=c0,
    c1=c1,
    upd=function(self)
      self.y-=0.5
    end,
    drw=function(self)
      print_2tone(self.s,self.x,self.y,self.c0,self.c1)
    end
  }))
end

function spawn_lightning(x,y)
  add(part,create_ani(0,20,{
    x=x,
    y=y,
    r=0,
    upd=function(self,t)
      self.r=flr(5*t)
    end,
    drw=function(self)
      circ(self.x,self.y,self.r,9)
      line(self.x-1,0,self.x-1,self.y,10)
      line(self.x,0,self.x,self.y,9)
      line(self.x+1,0,self.x+1,self.y,10)
    end,
  }))
end

function spawn_fallp(x,y,c)
  add(part,create_ani(flr(rnd(12)),5+flr(rnd(7)),{
    x=x,
    y=y,
    c=c,
    dx=0,
    dy=0.6,
    upd=upd_pos,
    drw=function(self)
      pset(self.x,self.y,self.c)
    end,
  }))
end
