-- ссылки твои или текст
local links = {
    "YOUR TEXT | YOUR TEXT",
    "YOUR TEXT",
    "YOUR TEXT",
    "YOUR TEXT | YOUR TEXT"
}
-- текст килл сея

-- %l ссылка
local normal_phrases = {
    "Убит YOUR TEXT - BEST CONFIG! %l",
    "Хаха, а что такое? Убит YOUR TEXT - лучшей луа! %l",
    "YOUR TEXT | BEST CONFIG - убит как нуб! %l",
    "Ты позоришься! Купи YOUR TEXT по %l и стань про!",
    "YOUR TEXT | Хаха, а что такое? Доминирован! %l",
    "Убит самой лучшей луа YOUR TEXT с уникальным кастомным килл войсом! %l",
    "YOUR TEXT доминирует! Купи по %l и не позорься больше!",
    "Лол, ты нубас! YOUR TEXT - лучшая луа, купи %l с кастомным килл войсом!"
}

register_callback("player_death", function(event)
    local local_pawn = entitylist.get_local_player_pawn()
    if not local_pawn then return end
    
    local victim_pawn = event:get_pawn("userid")
    if victim_pawn == local_pawn then return end
    
    local attacker_pawn = event:get_pawn("attacker")
    if not attacker_pawn or attacker_pawn ~= local_pawn then return end
    
    local link = links[math.random(1, #links)]
    local phrase = normal_phrases[math.random(1, #normal_phrases)]
    
    phrase = phrase:gsub("%%l", link)
    
    engine.execute_client_cmd("say " .. phrase)
end)