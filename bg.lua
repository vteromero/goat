function init_bg()
  clouds=split2d[[
    15,38,20,1,10,19,0.03|
    45,41,20,1,40,49,0.03|
    75,42,16,1,70,79,0.03|
    95,40,8,1,90,99,0.03|
    115,38,18,1,110,119,0.03|
    12,58,25,2,10,19,-0.03|
    45,57,20,2,43,52,-0.03|
    75,56,22,2,73,82,-0.03|
    110,61,28,2,108,117,-0.03
  ]]
  bgcols=dfltbgcols
  bgstars={}
end

function update_bg()
  update_bgstars()
  for i=1,#clouds do
    local x,y,r,ci,x0,x1,dx=unpack(clouds[i])
    x+=dx
    if x>=x1 or x<=x0 then
      dx=-dx
    end
    clouds[i]={x,y,r,ci,x0,x1,dx}
  end
end

function draw_bg(opts)
  local opts=opts or {}
  local sky,cld1,cld2,mnt1,mnt2=unpack(bgcols)
  cls(sky)
  draw_anis(bgstars)
  for cl in all(clouds) do
    local x,y,r,ci=unpack(cl)
    circfill(x,y,r,ci==1 and cld1 or cld2)
  end
  pal(1,mnt1)
  pal(14,mnt2)
  map(16,0,0,opts.mounty or 40)
  pal(colorpali)
  map(0,0,29,opts.towery or 24)
end

function set_bgani(name)
  if name=="stars" then
    spawn_bgstars()
  else
    bgstars={}
  end
end

function spawn_bgstars()
  for i=1,40 do
    local c0=rnd({1,5,13})
    add(bgstars,create_ani(100+flr(rnd(200)),300+flr(rnd(200)),{
      x=rnd(128),
      y=rnd(32),
      c0=c0,
      c=c0,
      upd=function(self)
        if self.age==1 then
          self.c=rnd({6,7,15})
        elseif self.age>30 then
          self.c=self.c0
        end
      end,
      drw=function(self)
        pset(self.x,self.y,self.c)
      end
    }))
  end
end

function update_bgstars()
  for a in all(bgstars) do
    if not update_ani(a) then
      a.age=0
    end
  end
end
