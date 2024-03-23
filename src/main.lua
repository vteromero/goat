function _init()
  version="V1.0"
  cartdata("vteromero_goat")
  highscore=dget(0)
  dfltcpal=split"1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0"
  dfltbgcols=split"12,7,6,1,0"
  alldarkbluecpal=split"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
  alldarkredcpal=split"2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2"
  redflashcpal=split"8,2,2,2,8,14,14,8,8,8,8,8,13,14,14,2"
  titlecpal=split"1,130,3,4,5,6,7,8,9,10,11,12,13,134,15,0"
  dir2dr=split"0,0,-1,1"
  dir2dc=split"-1,1,0,0"
  gstates={
    title0={init_title0,upd_title0,drw_title0},
    title1={init_title1,upd_title1,drw_title1},
    title2={init_title2,upd_title2,drw_title2},
    chapter_intro={init_chintro,upd_chintro,drw_chintro},
    chapter={init_chapter,upd_chapter,drw_chapter},
    game_over1={init_gover1,upd_gover1,drw_gover1},
    game_over2={init_gover2,upd_gover2,drw_gover2},
    game_over3={init_gover3,upd_gover3,drw_gover3},
    game_won1={init_gwon1,upd_gwon1,drw_gwon1},
    game_won2={init_gwon2,upd_gwon2,drw_gwon2},
    game_won3={init_gwon3,upd_gwon3,drw_gwon3},
  }
  init_bg()
  init_particles()
  set_colorpal(dfltcpal)
  set_gstate("title1")
end

function _update60()
  _upd()
end

function _draw()
  _drw()
end

function set_gstate(st)
  local init,drw,upd=unpack(gstates[st])
  init()
  _upd=upd
  _drw=drw
end

function set_colorpal(cpal)
  colorpal=cpal
  colorpali=clone(dfltcpal)
  pal(cpal,1)
end

function start_game()
  dead=false
  score=0
  init_objects()
  init_scheduler()
  init_bmoves()
  init_board()
  init_player()
  init_hud()
  set_chapter(1)
end

function lerp(a,b,t)
  return a+(b-a)*t
end

-- fisher-yates
function shuffle(t)
  for i=#t,1,-1 do
    local j=flr(rnd(i))+1
    t[i],t[j]=t[j],t[i]
  end
  return t
end

function easeinquad(t)
  return t*t
end

function easeoutquad(t)
  t-=1
  return 1-t*t
end

-- get x pos for horizontally-centered print
function xcprint(s,x0,x1)
  local x0=x0 or 0
  local x1=x1 or 127
  local midx=(x1-x0+1)\2
  return x0+midx-#s*2
end

function xrprint(s,x)
  return x-4*#s+2
end

function cprint(text,y,c)
  print(text,xcprint(text),y,c)
end

function rprint(text,x,y,c)
  print(text,xrprint(text,x),y,c)
end

function print_shadow(text,x,y,c0,c1)
  print(text,x+1,y+1,c1)
  print(text,x,y,c0)
end

function print_2tone(s,x,y,c0,c1)
  print(s,x,y,c1)
  clip(0,0,127,y+3)
  print(s,x,y,c0)
  clip()
end

function print_2tone_shadow(s,x,y,c0,c1,c2)
  print(s,x+1,y+1,c2)
  print_2tone(s,x,y,c0,c1)
end

-- print outlined text. c0: bg color; c1: text color
function outlined(text,x,y,c0,c1)
  for i=0,2 do
    for j=0,2 do
      print(text,x+i,y+j,c0)
    end
  end
  print(text,x+1,y+1,c1)
end

-- print outlined text, horizontally centered
-- c0: bg color; c1: text color
function coutlined(text,y,c0,c1)
  outlined(text,xcprint(text),y,c0,c1)
end

function split2d(s)
  local arr={}
  for v in all(split(s,"|",false)) do
    add(arr,split(v))
  end
  return arr
end

function clone(t)
  local u={}
  for k,v in pairs(t) do
    u[k]=v
  end
  return u
end

function create_fadeani(wait,mage,pals)
  return create_ani(wait,mage,{
    pals=pals,
    upd=function(self,t)
      local idx=min(flr(t*#self.pals)+1,#self.pals)
      set_colorpal(self.pals[idx])
    end
  })
end
