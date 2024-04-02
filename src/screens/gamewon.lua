function init_gwon_fadein()
  gwonfade1=split2d[[
    129,130,3,131,133,134,15,141,134,10,11,130,141,134,134,0|
    129,130,3,131,133,5,134,141,5,10,11,130,141,5,134,0|
    129,130,3,131,133,5,134,141,5,10,11,130,141,5,5,0
  ]]
  gwonfade2=split2d[[
    129,128,131,129,130,133,5,130,133,134,134,128,130,133,5,0|
    129,128,129,128,128,128,130,128,128,5,5,128,128,128,130,0|
    129,0,128,0,0,0,0,0,0,130,130,0,0,0,0,0|
    0,0,0,0,0,0,0,0,0,128,128,0,0,0,0,0|
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  ]]
  gwonchars=split2d[[
    176,38,23|
    177,46,23|
    178,54,23|
    179,70,23|
    180,78,23|
    181,85,23
  ]]
  gwonanis={}
  fadeani=create_fadeani(30,50,gwonfade1)
  add(gwonanis,fadeani)
  for ch in all(gwonchars) do
    local si,x,y=unpack(ch)
    add(gwonanis,create_ani(60,30,{
      x=x,
      y0=-10,
      y1=y,
      y=-10,
      si=si,
      upd=function(self,t)
        self.y=lerp(self.y0,self.y1,easeoutquad(t))
      end,
      drw=function(self)
        draw_sproutline(self.si,self.x,self.y)
        spr(self.si,self.x,self.y)
      end
    }))
  end
  for i=1,board.rows do
    for j=1,board.cols do
      if board.grid[i][j]>0 then
        local x,y=get_cell_pos(i,j,board)
        add(gwonanis,create_ani(flr(rnd(15)),1,{
          x=x+4,
          y=y+4,
          r=i,
          c=j,
          upd=function(self)
            spawn_breakp(self.x,self.y)
            board.grid[self.r][self.c]=0
            sfx(8)
          end
        }))
      end
    end
  end
  gwontitlefr=0
  scorepos=get_highscorepos(score)
  music(-1,3000)
  sfx(10)
end

function upd_gwon_fadein()
  update_gwonbg()
  update_anis(gwonanis)
  if #gwonanis==0 then
    set_gstate(scorepos>0 and "gwon_input" or "gwon_hscores")
  end
end

function drw_gwon_fadein()
  draw_gwonbg(fadeani.wait==0)
  draw_anis(gwonanis)
end

function init_gwon_input()
  init_inputinitials()
end

function upd_gwon_input()
  local initials=update_inputinitials()
  if initials then
    add_highscore(initials,score,scorepos)
    set_gstate("gwon_hscores")
  end
  update_gwonbg()
  gwontitlefr=(gwontitlefr+1)%100
end

function drw_gwon_input()
  draw_gwonbg(true)
  draw_gwontitle(gwontitlefr)
  draw_inputinitials(score,10,1)
end

function init_gwon_hscores()
  blink=0
end

function upd_gwon_hscores()
  if btnp(5) then
    set_gstate("gwon_fadeout")
  end
  update_gwonbg()
  gwontitlefr=(gwontitlefr+1)%100
  blink=(blink+1)%50
end

function drw_gwon_hscores()
  draw_gwonbg(true)
  draw_gwontitle(gwontitlefr)
  draw_highscores(10,1,11,scorepos)
  if blink<25 then
    mprint("press ❎",xcenter(),100,10,1)
  end
end

function init_gwon_fadeout()
  fadeani=create_fadeani(0,20,gwonfade2)
end

function upd_gwon_fadeout()
  if not update_ani(fadeani) then
    set_gstate("title_fadein")
  end
end

function drw_gwon_fadeout()
end

function update_gwonbg()
  update_player()
  update_board()
  update_hud()
  update_bg()
  update_lightning()
  update_particles()
end

function draw_gwonbg(changecols)
  if changecols then
    colorpali[3]=1
    colorpali[4]=1
    colorpali[10]=7
    colorpali[11]=7
    pal(colorpali)
  end
  draw_bg()
  draw_board()
  draw_player()
  draw_particles()
  draw_hud()
  if changecols then
    colorpali[3]=3
    colorpali[4]=4
    colorpali[10]=10
    colorpali[11]=11
    pal(colorpali)
  end
end

function draw_gwontitle(fr)
  for i=1,#gwonchars do
    local ch=gwonchars[i]
    local si,x,y=unpack(ch)
    local t=mid(0,fr-(i-1)*5,30)/30
    local xx=x-2*cos(t)
    local yy=y+2*sin(t)
    draw_sproutline(si,xx,yy)
    spr(si,xx,yy)
  end
end
