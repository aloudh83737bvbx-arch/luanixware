-- ссылки твои или текст
local links = {
    "YOUR TEXT | YOUR TEXT",
    "YOUR TEXT",
    "YOUR TEXT",
    "YOUR TEXT | YOUR TEXT"
}
-- текст килл сея

-- %s ссылка или %ss игрок
local ks_counter = 0
local last_kill_time = 0
local normal_phrases = {
    "%s убит YOUR TEXT - BEST CONFIG! %s",
    "%s, хаха, а что такое? Убит YOUR TEXT - лучшей луа! %s",
    "YOUR TEXT | BEST CONFIG - %s убит как нуб! %s",
    "%s, ты позоришься! Купи YOUR TEXT по %s и стань про!",
    "YOUR TEXT | Хаха, а что такое? %s доминирован! %s",
    "%s убит самой лучшей луа YOUR TEXT с уникальным кастомным килл войсом! %s",
    "YOUR TEXT доминирует! %s, купи по %s и не позорься больше!",
    "%s, лол, ты нубас! YOUR TEXT - лучшая луа, купи %s с кастомным килл войсом!"
}
-- дабл килл и тд текст
local multi_kill_phrases = {
    "Дабл килл YOUR TEXT %s, купи YOUR TEXT по %s и не позорься!",
    "Трипл килл YOUR TEXT %s, купи YOUR TEXT по %s и не позорься!",
    "Квадро килл YOUR TEXT %s, купи YOUR TEXT по %s и не позорься!",,
    "Мульти килл! %s, хаха, позор! Купи лучшую луа YOUR TEXT купи по %s"
}

register_callback("player_death", function(event)
    local local_pawn = entitylist.get_local_player_pawn()
    if not local_pawn then return end
    
    local victim_pawn = event:get_pawn("userid")
    if victim_pawn == local_pawn then
        ks_counter = 0
        last_kill_time = 0
        return
    end
    
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
    
    local curtime = os.clock()
    if curtime - last_kill_time > 5 then
        ks_counter = 1
    else
        ks_counter = ks_counter + 1
    end
    last_kill_time = curtime
    
    local link = links[math.random(1, #links)]
    local phrase
    
    if ks_counter >= 2 then
        local multi_index = math.min(ks_counter - 1, #multi_kill_phrases)
        phrase = multi_kill_phrases[multi_index]
    else
        phrase = normal_phrases[math.random(1, #normal_phrases)]
    end
    if string.find(phrase, "%%s") then
        phrase = string.format(phrase, victim_nick, link)
    else
        phrase = phrase .. " " .. link
    end
    
    engine.execute_client_cmd("say " .. phrase)
end)