function init_hud()
  scoreani=nil
  stabarani=nil
  powerupblink=0
  lifeblink=0
end

function update_hud()
  scoreani=update_ani(scoreani) and scoreani or nil
  stabarani=update_ani(stabarani) and stabarani or nil
  powerupblink=max(0,powerupblink-1)
  lifeblink=max(0,lifeblink-1)
end

function draw_hud(opts)
  local opts=opts or {}
  draw_stabar()
  draw_powerups()
  draw_hp()
  if opts.showtitle then
    local x=71-#chapter_title*2
    mprint(chapter_title,x,2,9,poutline(2))
  end
  if opts.showscore then
    print("MOVES",3,110,6)
    numprint(chapter_moves,3,117)
    print("SCORE",105,110,6)
    numrprint(scoreani and scoreani.score or score,125,117)
  end
end

function draw_stabar()
  local anista=(stabarani and stabarani.sta) or player.sta
  local stax0=3+35*min(player.sta,anista)/player.maxsta
  local stax1=3+35*max(player.sta,anista)/player.maxsta
  rectfill(3,3,38,6,13)
  rectfill(3,3,stax1,6,10)
  rectfill(3,3,stax0,6,14)
  rect(3,3,38,6,player.super>0 and 10 or 2)
end

function draw_powerups()
  local y=9
  if player.super>0 then
    local x1=3+35*(player.super/player.maxsuper)
    line(3,y,38,y,2)
    line(3,y,x1,y,10)
    y+=3
  end
  for i=1,player.powerups do
    if i<player.powerups or powerupblink==0 or powerupblink\6%2==0 then
      spr(53,2+(i-1)*7,y)
    end
  end
end

function draw_hp()
  for i=1,player.maxhp do
    local x=126-i*8
    if i>player.hp then
      spr(48,x,3)
    elseif i<player.hp or lifeblink==0 or lifeblink\6%2==0 then
      spr(49,x,3)
    end
  end
end

function increase_score(n)
  scoreani=create_ani(0,60,{
    score0=score,
    score=score,
    upd=function(self,t)
      self.score=flr(lerp(self.score0,score,easeoutquad(t)))
    end,
  })
  score+=n
end

function spawn_stabarani(n)
  stabarani=create_ani(0,30,{
    sta0=player.sta,
    sta=n,
    upd=function(self,t)
      self.sta=lerp(self.sta0,n,easeoutquad(t))
    end
  })
end

function numprint(n,x,y)
  local chars=split(tostr(n),1)
  for i=1,#chars do
    local si=144+tonum(chars[i])
    spr(si,x+(i-1)*8,y)
  end
end

function numrprint(n,x,y)
  local chars=split(tostr(n),1)
  for i=#chars,1,-1 do
    local si=144+tonum(chars[i])
    spr(si,x-(#chars-i+1)*8,y)
  end
end
