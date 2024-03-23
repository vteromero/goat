function init_scheduler()
  -- objects:
  -- 0: empty cell
  -- 1: rock
  -- 2: tree
  -- 3: stamina ball
  -- 4: spiky tree
  -- 5: heart
  -- 6: hard rock
  -- 7: ligghtning
  -- 8: gem rock
  -- 9: gem
  -- 10: fire ball
  -- 11: super power-up
  chapters={
    {
      title="DO NOT FALL",
      objdist=split"0,0,0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2,6,6,6,8",
      objextra={
        {obj=3,freq=1,sincelast=1},
        {obj=7,freq=1,sincelast=8},
        {obj=11,freq=1,sincelast=30},
      },
      spd=100,
      acc=1,
      moves=50,
      pal=split"1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0",
      bgcols=split"12,7,6,1,0",
      goverfade1=split2d[[
        129,130,131,2,133,6,15,8,134,15,134,5,141,14,15,0|
        129,130,131,2,133,6,15,8,5,134,134,5,141,14,134,0|
        129,130,1,2,133,6,134,8,5,5,5,5,141,14,134,0
      ]],
      goverfade2=split2d[[
        129,128,129,130,130,134,5,141,133,133,133,133,130,141,5,0|
        129,128,128,128,128,5,130,130,128,128,128,128,128,130,130,0|
        129,0,0,0,0,130,0,0,0,0,0,0,0,128,128,0|
        0,0,0,0,0,128,0,0,0,0,0,0,0,0,0,0|
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      ]],
    }, {
      title="DO NOT DIE",
      objdist=split"0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,4,4,4,4,4,6,6,6,8",
      objextra={
        {obj=3,freq=1,sincelast=1},
        {obj=5,freq=1,sincelast=3},
        {obj=7,freq=1,sincelast=8},
        {obj=11,freq=1,sincelast=25},
      },
      spd=100,
      acc=1,
      moves=60,
      pal=split"1,2,3,4,133,134,15,8,9,10,11,140,5,14,6,0",
      bgcols=split"12,7,6,1,0",
      goverfade1=split2d[[
        129,130,131,2,133,6,15,8,134,15,134,140,141,14,134,0|
        129,130,131,2,133,6,134,8,5,134,134,1,141,14,134,0|
        129,130,1,2,133,6,134,8,5,5,5,1,141,14,5,0
      ]],
      goverfade2=split2d[[
        129,128,129,130,130,134,5,141,133,133,133,129,130,141,5,0|
        129,128,128,128,128,5,130,130,128,128,128,128,128,130,130,0|
        129,0,0,0,0,130,0,0,0,0,0,0,0,128,128,0|
        0,0,0,0,0,128,0,0,0,0,0,0,0,0,0,0|
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      ]],
    }, {
      title="HELL",
      objdist=split"0,0,0,0,0,0,0,0,1,1,1,2,2,2,4,4,4,6,6,6,8,10,10,10,10",
      objextra={
        {obj=3,freq=1,sincelast=1},
        {obj=5,freq=1,sincelast=3},
        {obj=7,freq=1,sincelast=8},
        {obj=11,freq=1,sincelast=25},
      },
      spd=90,
      acc=1,
      moves=60,
      pal=split"1,2,3,4,133,134,15,8,9,10,11,130,5,14,6,0",
      bgcols=split"0,13,5,12,0",
      bgani="stars",
      goverfade1=split2d[[
        129,130,131,2,133,6,15,8,134,15,134,130,141,14,134,0|
        129,130,131,2,133,6,134,8,5,134,134,130,141,14,134,0|
        129,130,1,2,133,6,134,8,5,5,5,130,141,14,5,0
      ]],
      goverfade2=split2d[[
        129,128,129,130,130,134,5,141,133,133,133,128,130,141,5,0|
        129,128,128,128,128,5,130,130,128,128,128,128,128,130,130,0|
        129,0,0,0,0,130,0,0,0,0,0,0,0,128,128,0|
        0,0,0,0,0,128,0,0,0,0,0,0,0,0,0,0|
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      ]],
    }
  }
  mv2bmvdist=split2d[[
    1,1,1,1,2,3,3,4,4|
    1,2,2,2,2,3,3,4,4|
    1,1,2,2,3,3,3,3,4|
    1,1,2,2,3,4,4,4,4
  ]]
end

function set_chapter(n)
  chapter=mid(1,n,#chapters)
  local ch=chapters[chapter]
  chapter_title=ch.title
  objdist=ch.objdist
  objextra=ch.objextra
  chapter_moves=ch.moves
  bmoves.spd=ch.spd
  bmoves.acc=ch.acc
  bgcols=ch.bgcols
  goverfade1=ch.goverfade1
  goverfade2=ch.goverfade2
  set_colorpal(ch.pal)
  set_bgani(ch.bgani)
  set_gstate("chapter_intro")
end

function new_objline(len)
  local row={}
  for sch in all(objextra) do
    local o=sch.obj
    local freq=bstats.freqs[o] or 0
    local lastseen=bstats.lastseen[o] or 0
    if freq<sch.freq and bmoves.count-lastseen>=sch.sincelast then
      add(row,o)
    end
  end
  for i=#row+1,len do
    add(row,rnd(objdist))
  end
  shuffle(row)
  return row
end

function new_bmove(last)
  if last then
    return rnd(mv2bmvdist[last])
  else
    return rnd({1,2,3,4})
  end
end
