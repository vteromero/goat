function init_board()
  board={rows=7,cols=7,x=29,y=24,cellsz=10,grid={},ani=nil}
  bstats={freqs={},lastseen={}}
  for i=1,board.rows do
    local row={}
    for j=1,board.cols do
      add(row,0)
    end
    add(board.grid,row)
  end
  update_bstats()
end

function update_board()
  board.ani=update_ani(board.ani) and board.ani or nil
end

function draw_board()
  local b=board.ani or board
  for i=1,#b.grid do
    for j=1,#b.grid[i] do
      local oi=b.grid[i][j]
      if oi>0 then
        local x,y=get_cell_pos(i,j,b)
        draw_obj(objlib[oi],x+1,y+1)
      end
    end
  end
end

function reset_stats()
  for i=1,#objlib do
    bstats.lastseen[i]=bmoves.count
  end
end

function update_bstats()
  local freqs={}
  for i=1,board.rows do
    for j=1,board.cols do
      local obj=board.grid[i][j]
      freqs[obj]=freqs[obj] and freqs[obj]+1 or 1
      bstats.lastseen[obj]=bmoves.count
    end
  end
  bstats.freqs=freqs
end

function get_cell_pos(r,c,b)
  return b.x+b.cellsz*(c-1),b.y+b.cellsz*(r-1)
end

function move_bleft(newvals)
  for i=1,board.rows do
    for j=1,board.cols-1 do
      board.grid[i][j]=board.grid[i][j+1]
    end
  end
  for i=1,board.rows do
    board.grid[i][board.cols]=newvals[i]
  end
end

function move_bright(newvals)
  for i=1,board.rows do
    for j=board.cols,2,-1 do
      board.grid[i][j]=board.grid[i][j-1]
    end
  end
  for i=1,board.rows do
    board.grid[i][1]=newvals[i]
  end
end

function move_bup(newvals)
  for i=1,board.rows-1 do
    for j=1,board.cols do
      board.grid[i][j]=board.grid[i+1][j]
    end
  end
  for i=1,board.cols do
    board.grid[board.rows][i]=newvals[i]
  end
end

function move_bdown(newvals)
  for i=board.rows,2,-1 do
    for j=1,board.cols do
      board.grid[i][j]=board.grid[i-1][j]
    end
  end
  for i=1,board.cols do
    board.grid[1][i]=newvals[i]
  end
end

function new_bmoveani(mage,x,y,dx,dy,cellsz)
  return create_ani(0,mage,{
    grid={},x=x,y=y,dx=dx,dy=dy,cellsz=cellsz,
    upd=function(self,t)
      self.x+=self.dx
      self.y+=self.dy
    end,
  })
end

function set_bleftani(newvals)
  local x,y,cellsz=board.x,board.y,board.cellsz
  board.ani=new_bmoveani(10,x,y,-cellsz/10,0,cellsz)
  for i=1,board.rows do
    local row={}
    for j=1,board.cols do
      add(row,board.grid[i][j])
    end
    add(row,newvals[i])
    add(board.ani.grid,row)
  end
end

function set_brightani(newvals)
  local x,y,cellsz=board.x,board.y,board.cellsz
  board.ani=new_bmoveani(10,x-cellsz,y,cellsz/10,0,cellsz)
  for i=1,board.rows do
    local row={}
    add(row,newvals[i])
    for j=1,board.cols do
      add(row,board.grid[i][j])
    end
    add(board.ani.grid,row)
  end
end

function set_bupani(newvals)
  local x,y,cellsz=board.x,board.y,board.cellsz
  board.ani=new_bmoveani(10,x,y,0,-cellsz/10,cellsz)
  for i=1,board.rows do
    local row={}
    for j=1,board.cols do
      add(row,board.grid[i][j])
    end
    add(board.ani.grid,row)
  end
  add(board.ani.grid,newvals)
end

function set_bdownani(newvals)
  local x,y,cellsz=board.x,board.y,board.cellsz
  board.ani=new_bmoveani(10,x,y-cellsz,0,cellsz/10,cellsz)
  add(board.ani.grid,newvals)
  for i=1,board.rows do
    local row={}
    for j=1,board.cols do
      add(row,board.grid[i][j])
    end
    add(board.ani.grid,row)
  end
end

function move_board(dir)
  if dir==1 then
    local newvals=new_objline(board.rows)
    set_bleftani(newvals)
    move_bleft(newvals)
  elseif dir==2 then
    local newvals=new_objline(board.rows)
    set_brightani(newvals)
    move_bright(newvals)
  elseif dir==3 then
    local newvals=new_objline(board.cols)
    set_bupani(newvals)
    move_bup(newvals)
  elseif dir==4 then
    local newvals=new_objline(board.cols)
    set_bdownani(newvals)
    move_bdown(newvals)
  end
end
