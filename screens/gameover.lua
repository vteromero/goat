function init_gover1()
  goverchars=split2d[[
    160,-34,26,38,30,30|
    161,-25,35,38,30,30|
    162,-16,44,38,30,30|
    163,-7,53,38,30,30|
    164,128,69,38,30,30|
    165,137,78,38,30,30|
    163,146,87,38,30,30|
    166,155,96,38,30,30
  ]]
  fadeani=create_fadeani(0,50,goverfade1)
  govercharanis={}
  for ch in all(goverchars) do
    local si,x0,x1,y,wait,age=unpack(ch)
    add(govercharanis,create_ani(wait,age,{
      x0=x0,
      x1=x1,
      x=x0,
      y=y,
      si=si,
      upd=function(self,t)
        self.x=lerp(self.x0,self.x1,easeoutquad(t))
      end,
      drw=function(self)
        draw_sproutline(self.si,self.x,self.y)
        spr(self.si,self.x,self.y)
      end
    }))
  end
  if score>highscore then
    highscore=score
    dset(0,highscore)
  end
  music(-1,3000)
  sfx(9)
end

function upd_gover1()
  update_goverbg()
  fadeani=update_ani(fadeani) and fadeani or nil
  update_anis(govercharanis)
  if not fadeani and #govercharanis==0 then
    set_gstate("game_over2")
  end
end

function drw_gover1()
  draw_goverbg()
  draw_anis(govercharanis)
end

function init_gover2()
  blink=0
end

function upd_gover2()
  if btnp(5) then
    set_gstate("game_over3")
  end
  update_goverbg()
  blink=(blink+1)%50
end

function drw_gover2()
  draw_goverbg()
  draw_govertitle()
  draw_goverscores()
  if blink<25 then
    print_shadow("press ❎",xcprint("press ❎"),90,6,1)
  end
end

function init_gover3()
  fadeani=create_fadeani(0,20,goverfade2)
end

function upd_gover3()
  update_goverbg()
  if not update_ani(fadeani) then
    set_gstate("title0")
  end
end

function drw_gover3()
  draw_goverbg()
  draw_govertitle()
  draw_goverscores()
end

function update_goverbg()
  update_player()
  update_board()
  update_hud()
  update_bg()
  update_lightning()
  update_particles()
end

function draw_goverbg()
  colorpali[4]=3
  colorpali[6]=9
  colorpali[8]=13
  colorpali[14]=9
  pal(colorpali)
  draw_bg()
  draw_board()
  draw_player()
  draw_particles()
  draw_hud()
  colorpali[4]=4
  colorpali[6]=6
  colorpali[8]=8
  colorpali[14]=14
  pal(colorpali)
end

function draw_govertitle()
  for ch in all(goverchars) do
    local si,_,x,y=unpack(ch)
    draw_sproutline(si,x,y)
    spr(si,x,y)
  end
end

function draw_sproutline(si,x,y)
  pal(alldarkbluecpal)
  for i=-1,1 do
    for j=-1,1 do
      spr(si,x+i,y+j)
    end
  end
  pal(colorpali)
end

function draw_goverscores()
  print_2tone_shadow("YOUR SCORE:",26,60,6,8,1)
  print_2tone_shadow("HIGH SCORE:",26,70,6,8,1)
  print_2tone_shadow(tostr(score),xrprint(tostr(score),102),60,6,8,1)
  print_2tone_shadow(tostr(highscore),xrprint(tostr(highscore),102),70,6,8,1)
end
