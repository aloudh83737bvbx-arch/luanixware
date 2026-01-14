-- ссылки твои или текст
local links = {
    "YOUR TEXT | YOUR TEXT",
    "YOUR TEXT",
    "YOUR TEXT",
    "YOUR TEXT | YOUR TEXT"
}
-- текст килл сея

-- %p игрок %l ссылка
local normal_phrases = {
    "%p убит YOUR TEXT - BEST CONFIG! %l",
    "%p, хаха, а что такое? Убит YOUR TEXT - лучшей луа! %l",
    "YOUR TEXT | BEST CONFIG - %p убит как нуб! %l",
    "%p, ты позоришься! Купи YOUR TEXT по %l и стань про!",
    "YOUR TEXT | Хаха, а что такое? %p доминирован! %l",
    "%p убит самой лучшей луа YOUR TEXT с уникальным кастомным килл войсом! %l",
    "YOUR TEXT доминирует! %p, купи по %l и не позорься больше!",
    "%p, лол, ты нубас! YOUR TEXT - лучшая луа, купи %l с кастомным килл войсом!"
}

register_callback("player_death", function(event)
    local local_pawn = entitylist.get_local_player_pawn()
    if not local_pawn then return end
    
    local victim_pawn = event:get_pawn("userid")
    if victim_pawn == local_pawn then return end
    
    local attacker_pawn = event:get_pawn("attacker")
    if not attacker_pawn or attacker_pawn ~= local_pawn then return end
    
    local victim_nick = "Unknown"
    local victim_controller = event:get_controller("userid")
    if victim_controller then
        local raw_nick = victim_controller.m_sSanitizedPlayerName
        if raw_nick then
            victim_nick = tostring(raw_nick):gsub("%z.*", ""):gsub("%s+", " "):match("^%s*(.-)%s*$")
        end
    end
    if victim_nick == "Unknown" or victim_nick == "" then
        if victim_pawn then
            local controller_handle = victim_pawn.m_hOriginalControllerOfCurrentPawn
            local fallback_controller = entitylist.get_entity_from_handle(controller_handle)
            if fallback_controller then
                local raw_nick = fallback_controller.m_sSanitizedPlayerName
                if raw_nick then
                    victim_nick = tostring(raw_nick):gsub("%z.*", ""):gsub("%s+", " "):match("^%s*(.-)%s*$")
                end
                if victim_nick == "" then
                    raw_nick = fallback_controller.m_iszPlayerName
                    if raw_nick then
                        victim_nick = tostring(raw_nick):gsub("%z.*", ""):gsub("%s+", " "):match("^%s*(.-)%s*$")
                    end
                end
            end
        end
    end
    if victim_nick == "" or victim_nick == " " then victim_nick = "Unknown" end
    
    local link = links[math.random(1, #links)]
    local phrase = normal_phrases[math.random(1, #normal_phrases)]
    
    phrase = phrase:gsub("%%p", victim_nick):gsub("%%l", link)
    
    engine.execute_client_cmd("say " .. phrase)
end)