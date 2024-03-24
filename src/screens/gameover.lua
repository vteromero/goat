function init_goverfadein()
  goverchars=split2d[[
    160,-34,26,23,30,30|
    161,-25,35,23,30,30|
    162,-16,44,23,30,30|
    163,-7,53,23,30,30|
    164,128,69,23,30,30|
    165,137,78,23,30,30|
    163,146,87,23,30,30|
    166,155,96,23,30,30
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
  scorepos=get_highscorepos(score)
  music(-1,3000)
  sfx(9)
end

function upd_goverfadein()
  update_goverbg()
  fadeani=update_ani(fadeani) and fadeani or nil
  update_anis(govercharanis)
  if not fadeani and #govercharanis==0 then
    set_gstate(scorepos>0 and "gover_input" or "gover_hscores")
  end
end

function drw_goverfadein()
  draw_goverbg()
  draw_anis(govercharanis)
end

function init_goverinput()
  init_inputinitials()
end

function upd_goverinput()
  local initials=update_inputinitials()
  if initials then
    add_highscore(initials,score,scorepos)
    set_gstate("gover_hscores")
  end
  update_goverbg()
end

function drw_goverinput()
  draw_goverbg()
  draw_govertitle()
  draw_inputinitials(score,6,1)
end

function init_goverhscores()
  blink=0
end

function upd_goverhscores()
  if btnp(5) then
    set_gstate("gover_fadeout")
  end
  update_goverbg()
  blink=(blink+1)%50
end

function drw_goverhscores()
  draw_goverbg()
  draw_govertitle()
  draw_highscores(6,1,14,scorepos)
  if blink<25 then
    mprint("press ❎",xcenter(),100,6,1)
  end
end

function init_goverfadeout()
  fadeani=create_fadeani(0,20,goverfade2)
end

function upd_goverfadeout()
  if not update_ani(fadeani) then
    set_gstate("title0")
  end
end

function drw_goverfadeout()
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
