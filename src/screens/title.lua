function init_titlefadein()
  titlefade=split2d[[
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0|
    129,128,128,128,128,128,130,128,128,128,128,128,128,128,130,0|
    129,128,129,129,130,141,5,130,141,5,141,141,130,141,5,0|
    129,130,131,132,133,134,15,141,5,134,134,5,141,5,134,0|
    129,130,131,132,133,134,15,141,134,15,134,5,141,134,15,0|
    1,130,3,4,5,6,7,8,9,10,11,12,13,134,15,0
  ]]
  fadeani=create_fadeani(0,20,titlefade)
  bgcols=dfltbgcols
  set_bgani(nil)
  init_idlegoat()
  menuitem(1,"reset scores",reset_scores)
  music(16)
end

function upd_titlefadein()
  if not update_ani(fadeani) then
    set_gstate("title_main")
  end
  update_idlegoat()
  update_bg()
end

function drw_titlefadein()
  draw_bg({mounty=50,towery=128})
  draw_idlegoat()
  draw_title()
  draw_subtitle()
end

function init_titlemain()
  blink=0
  swing=0
end

function upd_titlemain()
  if btnp(5) then
    set_gstate("title_trans")
  end
  if btnp(1) then
    set_gstate("title_hscores")
  end
  update_idlegoat()
  update_bg()
  blink=(blink+1)%50
  swing=(swing+1)%60
end

function drw_titlemain()
  draw_bg({mounty=50,towery=128})
  draw_idlegoat()
  draw_title()
  draw_subtitle()
  if blink<25 then
    mprint("press ❎ to start",xcenter(),90,14,2)
  end
  mprint("scores",xright(112),3,15,2)
  mprint("➡️",117+round(2*sin(swing/60)),3,15,2)
  print("BY vICENTE rOMERO",2,121,1)
  mprint(version,xright(125),121,1)
end

function init_titlehscores()
  slideage=40
  slidefr=0
  camx=0
  trstate=0
end

function upd_titlehscores()
  if trstate==0 then
    slidefr+=1
    if slidefr==slideage then
      trstate=1
    end
  elseif trstate==1 then
    if btnp(0) then
      trstate=2
    end
  elseif trstate==2 then
    slidefr-=1
    if slidefr==0 then
      camera()
      set_gstate("title_main")
    end
  end
  camx=128*slidefr/slideage
  update_idlegoat()
  update_bg()
  swing=(swing+1)%60
end

function drw_titlehscores()
  camera()
  draw_bg({mounty=50,towery=128})
  camera(camx,0)
  draw_idlegoat()
  draw_title()
  draw_subtitle()
  camera(camx-128,0)
  draw_highscores(15,2)
  if trstate==1 then
    mprint("⬅️",4+round(2*sin(swing/60)),3,15,2)
    mprint("back",15,3,15,2)
  end
end

function init_titletrans()
  titleani=create_ani(0,70,{
    h=12,
    upd=function(self,t)
      if self.age%4==0 and self.h>0 then
        self.h-=1
        for i=0,50 do
          local x=38+i
          local y=48+self.h
          spawn_fallp(x,y,pget(x,y))
        end
      end
    end
  })
  scroll1ani=create_ani(70,20,{
    y0=128,
    y1=24,
    y=128,
    upd=function(self,t)
      self.y=lerp(self.y0,self.y1,t)
    end,
  })
  scroll2ani=create_ani(70,20,{
    y0=50,
    y1=40,
    y=50,
    upd=function(self,t)
      self.y=lerp(self.y0,self.y1,t)
    end,
  })
  fallani=create_ani(90,80,{
    y0=40,
    y1=55,
    y=40,
    si=16,
    upd=function(self)
      if self.age<=10 then
        self.y=lerp(self.y0,self.y1,self.age/10)
      elseif self.age<=50 then
        if self.age==11 then
          spawn_dustcloud(44,59)
          sfx(0)
        end
        self.y=self.y1
        self.si=17
      else
        self.si=16
      end
    end,
  })
  music(-1,2000)
end

function upd_titletrans()
  titleani=update_ani(titleani) and titleani or nil
  scroll1ani=update_ani(scroll1ani) and scroll1ani or nil
  scroll2ani=update_ani(scroll2ani) and scroll2ani or nil
  fallani=update_ani(fallani) and fallani or nil
  if not scroll1ani and not scroll2ani and not fallani then
    start_game()
  end
  update_bg()
  update_particles()
end

function drw_titletrans()
  draw_bg({
    towery=scroll1ani and scroll1ani.y,
    mounty=scroll2ani and scroll2ani.y,
  })
  spr(fallani.si,40,fallani.y)
  if titleani then
    draw_title(titleani.h)
  end
  draw_particles()
end

function init_idlegoat()
  eyeblink=10
  eyeblinkfreq=200
end

function update_idlegoat()
  eyeblink=(eyeblink+1)%eyeblinkfreq
end

function draw_idlegoat()
  if eyeblink<3 then
    pal(4,7)
  end
  spr(16,40,40)
  pal(colorpali)
end

function draw_title(sh)
  local sh=sh or 12
  pal(alldarkredcpal)
  sspr(64,96,51,sh,39,49)
  pal(colorpali)
  sspr(64,96,51,sh,38,48)
end

function draw_subtitle()
  mprint("(gOAT oN a tOWER)",xcenter(),65,4)
end
