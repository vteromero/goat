function init_chintro()
  chintroani=create_ani(0,160,{
    y0=64,
    y1=64,
    chtext=chapter==#chapters and "final chapter" or "chapter "..chapter,
    showtext=false,
    upd=function(self,t)
      if t<=0.25 then
        local tt=t/0.25
        local dy=15*easeoutquad(tt)
        self.y0=64-dy
        self.y1=64+dy
      else
        self.showtext=true
      end
    end,
    drw=function(self)
      rectfill(0,self.y0,127,self.y1,2)
      line(0,self.y0,127,self.y0,0)
      line(0,self.y1,127,self.y1,0)
      if self.showtext then
        cprint(self.chtext,57,4)
        cprint(chapter_title,66,9)
      end
    end
  })
  music(0)
end

function upd_chintro()
  if update_ani(chintroani) then
    update_player()
    update_board()
    update_hud()
    update_bg()
    update_lightning()
    update_particles()
  else
    set_gstate("chapter")
  end
end

function drw_chintro()
  draw_bg()
  draw_board()
  draw_player()
  draw_particles()
  draw_hud({showscore=true})
  chintroani:drw()
end

function init_chapter()
  reset_stats()
  reset_bmovearrows()
  set_stamina(player.maxsta)
  reset_stastreak()
end

function upd_chapter()
  if chapter_moves==0 then
    if chapter==#chapters then
      set_gstate("game_won1")
    else
      set_chapter(chapter+1)
    end
  else
    if btnp(4) and player.powerups>0 and player.super==0 then
      player.powerups-=1
      player.super=player.maxsuper
    end
    move_player()
    if update_bmoves() then
      chapter_moves-=1
      update_stastreak()
    end
    if dead then
      set_gstate("game_over1")
    else
      update_player()
      update_board()
      update_nextbmovehint()
      update_hud()
      update_bg()
      update_lightning()
      update_particles()
    end
  end
end

function drw_chapter()
  draw_bg()
  draw_nextbmovehint()
  draw_board()
  draw_player()
  draw_particles()
  draw_hud({showtitle=true,showscore=true})
end

function reset_stastreak()
  stastreak={sta=player.sta,moves=0}
end

function update_stastreak()
  if stastreak.sta==player.sta then
    stastreak.moves+=1
  else
    stastreak.moves=0
    stastreak.sta=player.sta
  end
  if stastreak.moves == 3 then
    set_stamina(player.sta+1)
    reset_stastreak()
  end
end
