function create_ani(wait,mage,data)
  local tb={}
  for k,v in pairs(data) do
    tb[k]=v
  end
  tb.wait=wait
  tb.mage=mage
  tb.age=0
  return tb
end

function update_ani(a)
  if a then
    if a.wait>0 then
      a.wait-=1
    else
      a.age+=1
      if a.age>a.mage then
        return false
      else
        a:upd(a.age/a.mage)
      end
    end
    return true
  else
    return false
  end
end

function update_anis(anis)
  for ani in all(anis) do
    if not update_ani(ani) then
      del(anis,ani)
    end
  end
end

function draw_anis(anis)
  for ani in all(anis) do
    if ani.drw then
      ani:drw()
    end
  end
end
