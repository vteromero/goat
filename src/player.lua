function init_player()
  btnp2dir=split"0,1,2,0,3,0,0,3,4,0,0,4,0,1,2,0"
  player={
    r=4,
    c=2,
    sta=10,
    maxsta=10,
    hp=3,
    maxhp=3,
    ani=nil,
    x=0,
    y=0,
    spr=16,
    dir=1,
    fliph=false,
    invul=0,
    flash=0,
    super=0,
    maxsuper=360,
    powerups=1,
    maxpowerups=3,
  }
  playeranilib={
    idle={
      seq=split2d"16,0,0,25|17,0,0,50",
      loop=true
    },
    move={
      seq=split2d"16,0.1,0.1,3|18,0.1,0.1,5|16,0.1,0.1,7|18,0.1,0.1,10",
    },
    charge={
      seq=split2d"19,0,0,5|20,0.2,0.2,10",
    },
    charge_bounce={
      seq=split2d"19,0,0,4|20,0.1,0.1,7|20,-0.1,-0.1,10",
    },
    push={
      seq=split2d"16,0,0,5|16,0.142,0.142,12",
    },
    fall0={
      seq=split2d"16,0.1,0.1,3|18,0.1,0.1,5|16,0.1,0.1,7|18,0.1,0.1,10|16,0,0,20|50,0,0,27|51,0,0,30|52,0,0,33",
      chain="fall1",
    },
    fall1={
      seq={{0,0,0,60}},
      loop=true,
    },
    dead={
      seq={{21,0,0,60}},
      loop=true
    },
  }
  ploutlines=split2d[[
    64,16,10,9|
    75,16,10,9|
    86,16,10,9|
    97,16,10,9
  ]]
  plsi2outline={[16]=1,[17]=2,[18]=1,[19]=3,[20]=4}
  dustparts={}
  board.grid[player.r][player.c]=0
  player.x,player.y=get_cell_pos(player.r,player.c,board)
  player.ani=create_playerani("idle",0,0)
end

function update_player()
  if player.ani then
    local ani=player.ani
    ani.age+=1
    if ani.age>ani.seq[ani.seqi].mage then
      ani.seqi+=1
      if ani.loop and ani.seqi>#ani.seq then
        ani.seqi=1
        ani.age=0
      end
    end
    if ani.seqi>#ani.seq then
      if ani.chain then
        player.ani=create_playerani(ani.chain,0,0)
      else
        player.x,player.y=get_cell_pos(player.r,player.c,board)
        player.ani=create_playerani(dead and "dead" or "idle",0,0)
      end
    else
      local seq=ani.seq[ani.seqi]
      player.spr=seq.spr
      player.x+=seq.dx
      player.y+=seq.dy
    end
  else
    player.x,player.y=get_cell_pos(player.r,player.c,board)
    player.spr=16
  end
  player.invul=max(0,player.invul-1)
  player.flash=max(0,player.flash-1)
  player.super=max(0,player.super-1)
  update_anis(dustparts)
end

function draw_player()
  draw_anis(dustparts)
  if player.super>0 then
    if player.super\5%2==0 then
      pal(14,player.super<100 and 10 or 7)
    end
    draw_playeroutline(player.x,player.y)
    pal(colorpali)
    spr(player.spr,player.x+1,player.y+1,1,1,player.fliph)
  elseif player.invul==0 or player.invul\3%2==0 then
    if player.flash>0 then
      pal(redflashcpal)
    end
    spr(player.spr,player.x+1,player.y+1,1,1,player.fliph)
    pal(colorpali)
  end
end

function draw_playeroutline(x,y)
  local si=plsi2outline[player.spr]
  if si then
    local sx,sy,sw,sh=unpack(ploutlines[si])
    sspr(sx,sy,sw,sh,x,y,sw,sh,player.fliph)
  end
end

function create_playerani(name,dr,dc)
  local data=playeranilib[name]
  local seq={}
  for s in all(data.seq) do
    local spr,ddx,ddy,mage=unpack(s)
    local dx,dy=ddx*dc*board.cellsz,ddy*dr*board.cellsz
    add(seq,{spr=spr,dx=dx,dy=dy,mage=mage})
  end
  return {
    loop=data.loop,
    chain=data.chain,
    seq=seq,
    seqi=1,
    age=0
  }
end

function move_player()
  local dir=btnp2dir[1+btnp()&0b1111]
  if dir==0 then
    return
  end
  player.dir=dir
  player.fliph=dir==1 or (player.fliph and dir~=2)
  player.x,player.y=get_cell_pos(player.r,player.c,board) -- TODO: review this
  local dr,dc=dir2dr[dir],dir2dc[dir]
  local r,c=player.r+dr,player.c+dc
  if r<1 or r>board.rows or c<1 or c>board.cols then
    player.ani=create_playerani("fall0",dr,dc)
    dead=true
  else
    local oi=board.grid[r][c]
    if oi==0 then
      player.ani=create_playerani("move",dr,dc)
      player.r+=dr
      player.c+=dc
    else
      charge_obj(objlib[oi],dr,dc)
    end
  end
  spawn_dust(player.x+4,player.y+8)
  if player.hp==0 then
    dead=true
  end
end

function push_player(dir)
  if dead then
    return
  end
  player.x,player.y=get_cell_pos(player.r,player.c,board) -- TODO: review this
  local dr,dc=dir2dr[dir],dir2dc[dir]
  local oi=board.grid[player.r][player.c]
  if oi>0 then
    move_obj(objlib[oi],dr,dc)
  end
  if player.r<1 or player.r>board.rows or player.c<1 or player.c>board.cols then
    player.ani=create_playerani("fall0",dr,dc)
    dead=true
  end
  if player.hp==0 then
    dead=true
  end
end

function set_stamina(n)
  local m=mid(0,n,player.maxsta)
  spawn_stabarani(m)
  player.sta=m
end

function set_hp(n)
  local m=mid(0,n,player.maxhp)
  if m<player.hp then
    player.invul=60
    player.flash=10
  elseif m>player.hp then
    lifeblink=50
  end
  player.hp=m
end

function spawn_dust(x,y)
  for i=1,5 do
    add(dustparts,create_ani(0,9+flr(rnd(4)),{
      x=x,
      y=y,
      dx=rnd()*0.5-0.25,
      dy=-0.25*rnd(),
      col=6,
      upd=function(self,t)
        self.x+=self.dx
        self.y+=self.dy
        self.col=t>0.5 and 6 or 7
      end,
      drw=function(self)
        pset(self.x,self.y,self.col)
      end
    }))
  end
end
