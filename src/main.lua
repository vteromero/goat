function _init()
  version="V1.0"
  cartdata("vteromero_goat")
  dfltcpal=split"1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0"
  dfltbgcols=split"12,7,6,1,0"
  alldarkbluecpal=split"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
  alldarkredcpal=split"2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2"
  redflashcpal=split"8,2,2,2,8,14,14,8,8,8,8,8,13,14,14,2"
  dir2dr=split"0,0,-1,1"
  dir2dc=split"-1,1,0,0"
  gstates={
    title_fadein={init_titlefadein,upd_titlefadein,drw_titlefadein},
    title_main={init_titlemain,upd_titlemain,drw_titlemain},
    title_hscores={init_titlehscores,upd_titlehscores,drw_titlehscores},
    title_trans={init_titletrans,upd_titletrans,drw_titletrans},
    chapter_intro={init_chintro,upd_chintro,drw_chintro},
    chapter={init_chapter,upd_chapter,drw_chapter},
    gover_fadein={init_goverfadein,upd_goverfadein,drw_goverfadein},
    gover_input={init_goverinput,upd_goverinput,drw_goverinput},
    gover_hscores={init_goverhscores,upd_goverhscores,drw_goverhscores},
    gover_fadeout={init_goverfadeout,upd_goverfadeout,drw_goverfadeout},
    gwon_fadein={init_gwonfadein,upd_gwonfadein,drw_gwonfadein},
    gwon_input={init_gwoninput,upd_gwoninput,drw_gwoninput},
    gwon_hscores={init_gwonhscores,upd_gwonhscores,drw_gwonhscores},
    gwon_fadeout={init_gwonfadeout,upd_gwonfadeout,drw_gwonfadeout},
  }
  init_highscores()
  init_bg()
  init_particles()
  set_colorpal(dfltcpal)
  set_gstate("title_fadein")
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

function round(x)
  return flr(x+0.5)
end

function poutline(c)
  return function(s,x,y)
    for i=-1,1 do
      for j=-1,1 do
        print(s,x+i,y+j,c)
      end
    end
  end
end

function xcenter()
  return function(s)
    return 64-#s*2
  end
end

function xright(x)
  return function(s)
    return x-4*#s+2
  end
end

function mprint(s,x,y,c,sh,twot)
  local x=type(x)=="function" and x(s) or x
  if sh then
    if type(sh)=="function" then
      sh(s,x,y)
    else
      print(s,x+1,y+1,sh)
    end
  end
  if twot then
    print(s,x,y,twot)
    clip(0,0,127,y+3)
    print(s,x,y,c)
    clip()
  else
    print(s,x,y,c)
  end
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
