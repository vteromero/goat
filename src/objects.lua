function init_objects()
  objlib={
    -- Object properties:
    -- breakable => 0:can't break; 1:breaks on charge; 2:breaks w/ lightning; 3:breaks w/ super power
    -- pickable => 0:no; 1:yes
    -- nextobj => obj to replace this with after breaking it/picking it up
    -- sta => stamina change on break/pick up
    -- score => score points you get on break/pick up
    -- hp => health points (lifes) change on break/pick up
    -- si => sprite index
    -- sanioff => sprite animation offset (in frames)
    -- sanicycle => sprite animation cycle (in frames)
    -- saniseq => sprite animation sequence
    -- sanispd => sprite animation speed
    -- onpickup => function called on pick up
    -- draw => function called to draw the object
    { -- 1:rock
      breakable=1,
      pickable=0,
      nextobj=0,
      sta=-2,
      score=50,
      si=1,
    },
    { -- 2:tree
      breakable=1,
      pickable=0,
      nextobj=0,
      sta=-1,
      score=20,
      si=2,
    },
    { -- 3:stamina ball
      breakable=0,
      pickable=1,
      pickupsfx=2,
      nextobj=0,
      sta=8,
      si=3,
      sanioff=100,
      sanicycle=300,
    },
    { -- 4:spiky tree
      breakable=2,
      pickable=0,
      nextobj=0,
      hp=-1,
      si=4,
    },
    { -- 5:heart
      breakable=0,
      pickable=1,
      pickupsfx=6,
      nextobj=0,
      hp=1,
      si=5,
      sanioff=130,
      sanicycle=300,
    },
    { -- 6:hard rock
      breakable=1,
      pickable=0,
      nextobj=1,
      sta=-1,
      score=30,
      si=6,
    },
    { -- 7:lightning pickup
      breakable=0,
      pickable=1,
      pickupsfx=7,
      nextobj=0,
      onpickup=function(self)
        start_lightning()
      end,
      si=7,
      sanioff=180,
      sanicycle=300,
    },
    { -- 8:gem rock
      breakable=1,
      pickable=0,
      nextobj=9,
      sta=-2,
      score=50,
      si=8,
    },
    { -- 9:gem
      breakable=0,
      pickable=1,
      pickupsfx=3,
      nextobj=0,
      score=100,
      scorepopupcols={9,4},
      si=9,
      sanioff=210,
      sanicycle=300,
    },
    { -- 10:fire ball
      breakable=3,
      pickable=0,
      nextobj=6,
      hp=-1,
      saniseq={10,11,12,13},
      sanispd=25,
      draw=function(self,x,y)
        local f=t()*60%self.sanispd
        local idx=flr(f/self.sanispd*#self.saniseq)+1
        spr(self.saniseq[idx],x,y)
      end,
      onbreak=function(self,x,y)
        spawn_smokep(x+4,y+4)
      end,
    },
    { -- 11: super power-up
      breakable=0,
      pickable=1,
      pickupsfx=4,
      nextobj=0,
      si=14,
      sanioff=235,
      sanicycle=300,
      onpickup=function(self)
        if player.powerups<player.maxpowerups then
          player.powerups+=1
          powerupblink=50
        end
      end,
    }
  }
  lightning={}
end

function draw_obj(o,x,y)
  if o.draw then
    o:draw(x,y)
  else
    if o.pickable==1 then
      x,y=pickuppos(x,y,o.sanioff,o.sanicycle)
    end
    spr(o.si,x,y)
  end
end

function pickup_objscore(o,x,y)
  local c0,c1=unpack(o.scorepopupcols or {4,2})
  increase_score(o.score)
  spawn_scorepopup(x,y,o.score,c0,c1)
end

function break_obj(o,r,c)
  local x,y=get_cell_pos(r,c,board)
  board.grid[r][c]=o.nextobj
  if o.score and o.score>0 then
    pickup_objscore(o,x,y)
  end
  if o.onbreak then
    o:onbreak(x,y)
  else
    spawn_breakp(x+5,y+5)
  end
end

function pickup_obj(o,r,c)
  local x,y=get_cell_pos(r,c,board)
  board.grid[r][c]=o.nextobj
  if o.sta and o.sta>0 then
    set_stamina(player.sta+o.sta)
  end
  if o.hp and o.hp>0 then
    set_hp(player.hp+o.hp)
  end
  if o.score and o.score>0 then
    pickup_objscore(o,x,y)
  end
  if o.onpickup then
    o:onpickup()
  end
  sfx(o.pickupsfx or 2)
end

function charge_obj(o,dr,dc)
  local r,c=player.r+dr,player.c+dc
  if player.super>0 and o.breakable>0 then
    if o.nextobj==0 then -- pass through
      player.ani=create_playerani("charge",dr,dc)
      player.r=r
      player.c=c
    else
      player.ani=create_playerani("charge_bounce",dr,dc)
    end
    break_obj(o,r,c)
    sfx(1)
  elseif o.breakable==1 then
    if player.sta>=abs(o.sta) then
      if o.sta==-1 and o.nextobj==0 then -- pass through
        player.ani=create_playerani("charge",dr,dc)
        player.r=r
        player.c=c
      else
        player.ani=create_playerani("charge_bounce",dr,dc)
      end
      set_stamina(player.sta+o.sta)
      break_obj(o,r,c)
    else
      player.ani=create_playerani("charge_bounce",dr,dc)
    end
    sfx(1)
  elseif o.pickable==1 then
    player.ani=create_playerani("move",dr,dc)
    player.r=r
    player.c=c
    pickup_obj(o,r,c)
  else
    player.ani=create_playerani("charge_bounce",dr,dc)
    if o.hp<0 and player.invul==0 then
      set_hp(player.hp+o.hp)
      sfx(5)
    end
  end
end

function move_obj(o,dr,dc)
  if o.pickable==1 then
    pickup_obj(o,player.r,player.c)
  else
    player.ani=create_playerani("push",dr,dc)
    player.r+=dr
    player.c+=dc
    if o.hp and o.hp<0 and player.invul==0 and player.super==0 then
      set_hp(player.hp+o.hp)
      sfx(5)
    end
  end
end

function pickuppos(x,y,offt,cyct)
  local f=(t()*60+offt)%cyct
  if f<10 then
    local yy=f<5 and lerp(y,y-3,(f+1)/5) or lerp(y-3,y,(f-4)/5)
    return x,yy
  else
    return x,y
  end
end

function start_lightning()
  for i=1,15 do
    add(lightning,{wait=flr(rnd(30))})
  end
end

function update_lightning()
  local breakable={}
  for i=1,board.rows do
    for j=1,board.cols do
      local oi=board.grid[i][j]
      if oi>0 and (objlib[oi].breakable==1 or objlib[oi].breakable==2) then
        add(breakable,{oi,i,j})
      end
    end
  end
  shuffle(breakable)
  for l in all(lightning) do
    l.wait-=1
    if l.wait<=0 then
      del(lightning,l)
      local o=deli(breakable)
      if o then
        local oi,r,c=unpack(o)
        local x,y=get_cell_pos(r,c,board)
        spawn_lightning(x+5,y+5)
        break_obj(objlib[oi],r,c)
        sfx(8)
      end
    end
  end
end
