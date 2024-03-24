function init_highscores()
  hscorechars="abcdefghijklmnopqrstuvwxyz-"
  hscorecharsnav=calculate_charsnav(hscorechars)
  hscoretbtmpl=split2d"go-,10000|ont,8000|a-o,5000|t-w,3000|-ae,2000|--r,1000"
  if dget(0)==0 then
    for i=1,#hscoretbtmpl do
      local initials,score=unpack(hscoretbtmpl[i])
      dset(i*2,pack_initials(initials))
      dset(i*2+1,score)
    end
    dset(0,pack_initials("aaa"))
  end
end

function draw_highscores(c0,c1,c2,hpos)
  mprint("high scores",xcenter(),40,c0,c1)
  for i=1,6 do
    local initials=unpack_initials(dget(i*2))
    local score=dget(i*2+1)
    local y=50+(i-1)*7
    local c2=hpos==i and c2 or nil
    mprint(tostr(i),35,y,c0,c1,c2)
    mprint(initials,43,y,c0,c1,c2)
    mprint(tostr(score),xright(90),y,c0,c1,c2)
  end
end

function init_inputinitials()
  initials=split(unpack_initials(dget(0)),1,false)
  initialsidx=1
end

function update_inputinitials()
  if btnp(5) then
    if initialsidx==3 then
      return initials[1]..initials[2]..initials[3]
    else
      initialsidx+=1
    end
  end
  if btnp(4) and initialsidx>1 then
    initialsidx-=1
  end
  if btnp(2) then
    initials[initialsidx]=hscorecharsnav[initials[initialsidx]].prev
  end
  if btnp(3) then
    initials[initialsidx]=hscorecharsnav[initials[initialsidx]].next
  end
  return nil
end

function draw_inputinitials(score,c0,c1)
  mprint("score: "..score,xcenter(),50,c0,c1)
  for i=1,3 do
    local c=initialsidx<i and "_" or initials[i]
    mprint("\^w\^t"..c,50+(i-1)*10,60,c0,c1)
  end
end

function get_highscorepos(score)
  for i=1,6 do
    if score>dget(i*2+1) then
      return i
    end
  end
  return 0
end

function add_highscore(initials,score,pos)
  local prev1,prev2=dget(pos*2),dget(pos*2+1)
  dset(pos*2,pack_initials(initials))
  dset(pos*2+1,score)
  for i=pos+1,6 do
    local tmp1,tmp2=dget(i*2),dget(i*2+1)
    dset(i*2,prev1)
    dset(i*2+1,prev2)
    prev1,prev2=tmp1,tmp2
  end
  dset(0,pack_initials(initials))
end

function pack_initials(txt)
  local c1,c2,c3=ord(txt,1,3)
  return (c1<<8)|c2|(c3>>8)
end

function unpack_initials(n)
  local c1=(n>>8)&0xff
  local c2=n&0xff
  local c3=(n<<8)&0xff
  return chr(c1,c2,c3)
end

function calculate_charsnav(str)
  local charsnav={}
  for i=1,#str do
    local c=str[i]
    local p=i==1 and #str or i-1
    local n=i==#str and 1 or i+1
    charsnav[c]={prev=str[p],next=str[n]}
  end
  return charsnav
end
