function init_bmoves()
  bmoves={next=new_bmove(),count=0,minspd=30,spd=120,acc=1,fr=0}
  bmovearrows={}
end

function update_bmoves()
  bmoves.fr=(bmoves.fr+1)%bmoves.spd
  if bmoves.fr==0 then
    local dir=bmoves.next
    bmoves.next=new_bmove(bmoves.next)
    bmoves.count+=1
    bmoves.spd=max(bmoves.minspd,bmoves.spd-bmoves.acc)
    move_board(dir)
    update_bstats()
    push_player(dir)
    return true
  end
  return false
end

function update_nextbmovehint()
  local spawnr={0.4,0.7,0.95}
  for i=1,#spawnr do
    local fr=flr(spawnr[i]*bmoves.spd)
    if bmoves.fr==fr then
      if bmoves.next==1 then
        spawn_bmovearrowsl(i)
      elseif bmoves.next==2 then
        spawn_bmovearrowsr(i)
      elseif bmoves.next==3 then
        spawn_bmovearrowsu(i)
      elseif bmoves.next==4 then
        spawn_bmovearrowsd(i)
      end
    end
  end
  update_anis(bmovearrows)
end

function draw_nextbmovehint()
  draw_anis(bmovearrows)
end

function new_bmovearrow(si,x,y)
  return create_ani(0,30,{
    spr=si,x=x,y=y,cols={10,9,4},coli=1,
    upd=function(self,t)
      self.coli=min(#self.cols,flr(#self.cols*t)+1)
    end,
    drw=function(self)
      pal(2,self.cols[self.coli])
      spr(self.spr,self.x,self.y)
      pal(colorpali)
    end,
  });
end

function spawn_bmovearrowsl(step)
  local x=board.x+board.cols*board.cellsz+(3-step)*4+1
  for i=1,board.rows do
    local y=board.y+(i-1)*board.cellsz+1
    add(bmovearrows,new_bmovearrow(32,x,y))
  end
end

function spawn_bmovearrowsr(step)
  local x=board.x-(3-step)*4-5
  for i=1,board.rows do
    local y=board.y+(i-1)*board.cellsz+1
    add(bmovearrows,new_bmovearrow(33,x,y))
  end
end

function spawn_bmovearrowsu(step)
  local y=board.y+board.rows*board.cellsz+(3-step)*4+1
  for i=1,board.cols do
    local x=board.x+(i-1)*board.cellsz+1
    add(bmovearrows,new_bmovearrow(34,x,y))
  end
end

function spawn_bmovearrowsd(step)
  local y=board.y-(3-step)*4-6
  for i=1,board.cols do
    local x=board.x+(i-1)*board.cellsz+1
    add(bmovearrows,new_bmovearrow(35,x,y))
  end
end

function reset_bmovearrows()
  bmovearrows={}
end
