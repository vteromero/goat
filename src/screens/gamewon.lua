function init_gwon1()
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
    176,38,38|
    177,46,38|
    178,54,38|
    179,70,38|
    180,78,38|
    181,85,38
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
  if score>highscore then
    highscore=score
    dset(0,highscore)
  end
  music(-1,3000)
  sfx(10)
end

function upd_gwon1()
  update_gwonbg()
  update_anis(gwonanis)
  if #gwonanis==0 then
    set_gstate("game_won2")
  end
end

function drw_gwon1()
  draw_gwonbg(fadeani.wait==0)
  draw_anis(gwonanis)
end

function init_gwon2()
  gwontitlefr=0
  blink=0
end

function upd_gwon2()
  if btnp(5) then
    set_gstate("game_won3")
  end
  update_gwonbg()
  gwontitlefr=(gwontitlefr+1)%100
  blink=(blink+1)%50
end

function drw_gwon2()
  draw_gwonbg(true)
  draw_gwontitle(gwontitlefr)
  draw_gwonscores()
  if blink<25 then
    print_shadow("press ❎",xcprint("press ❎"),90,10,1)
  end
end

function init_gwon3()
  fadeani=create_fadeani(0,20,gwonfade2)
end

function upd_gwon3()
  if not update_ani(fadeani) then
    set_gstate("title0")
  end
  update_gwonbg()
  gwontitlefr=(gwontitlefr+1)%100
end

function drw_gwon3()
  draw_gwonbg(true)
  draw_gwontitle(gwontitlefr)
  draw_gwonscores()
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
    local xx=x+2*cos(t)
    local yy=y+2*sin(t)
    draw_sproutline(si,xx,yy)
    spr(si,xx,yy)
  end
end

function draw_gwonscores()
  print_2tone_shadow("YOUR SCORE:",26,60,10,3,1)
  print_2tone_shadow("HIGH SCORE:",26,70,10,3,1)
  print_2tone_shadow(tostr(score),xrprint(tostr(score),102),60,10,3,1)
  print_2tone_shadow(tostr(highscore),xrprint(tostr(highscore),102),70,10,3,1)
end
