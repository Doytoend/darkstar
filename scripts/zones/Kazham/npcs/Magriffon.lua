-----------------------------------
-- Area: Kazham
--  NPC: Magriffon
-- Involved in Quest: Gullible's Travels, Even More Gullible's Travels,
-- Location: (I-7)
-----------------------------------
package.loaded["scripts/zones/Kazham/TextIDs"] = nil;
-----------------------------------
require("scripts/globals/settings");
require("scripts/globals/quests");
require("scripts/globals/titles");
require("scripts/globals/keyitems");
require("scripts/zones/Kazham/TextIDs");


function onTrade(player,npc,trade)
    if (player:getQuestStatus(OUTLANDS, GULLIBLES_TRAVELS) == QUEST_ACCEPTED) then
        if (trade:getGil() >= player:getVar("MAGRIFFON_GIL_REQUEST")) then
            player:startEvent(146);
        end
    elseif (player:getQuestStatus(OUTLANDS, EVEN_MORE_GULLIBLES_TRAVELS) == QUEST_ACCEPTED and player:getVar("EVEN_MORE_GULLIBLES_PROGRESS") == 0) then
        if (trade:getGil() >= 35000) then
            player:startEvent(150, 0, 256);
        end
    end
end;

function onTrigger(player,npc)
    local gulliblesTravelsStatus = player:getQuestStatus(OUTLANDS, GULLIBLES_TRAVELS);
    local evenmoreTravelsStatus = player:getQuestStatus(OUTLANDS, EVEN_MORE_GULLIBLES_TRAVELS);

    if (gulliblesTravelsStatus == QUEST_ACCEPTED) then
        local magriffonGilRequest = player:getVar("MAGRIFFON_GIL_REQUEST");
        player:startEvent(145, 0, magriffonGilRequest);
    elseif (gulliblesTravelsStatus == QUEST_AVAILABLE and player:getFameLevel(KAZHAM) >= 6) then
        local gil = math.random(10, 30) * 1000;
        player:setVar("MAGRIFFON_GIL_REQUEST", gil);
        player:startEvent(144, 0, gil);
    elseif (evenmoreTravelsStatus == QUEST_ACCEPTED and player:getVar("EVEN_MORE_GULLIBLES_PROGRESS") == 0) then
        player:startEvent(149, 0, 256, 0, 0, 0, 35000);
    elseif (evenmoreTravelsStatus == QUEST_ACCEPTED and player:getVar("EVEN_MORE_GULLIBLES_PROGRESS") == 1) then
        player:startEvent(151);
    elseif (evenmoreTravelsStatus == QUEST_ACCEPTED and player:getVar("EVEN_MORE_GULLIBLES_PROGRESS") == 2) then
        player:startEvent(152, 0, 1144, 256);
    elseif (gulliblesTravelsStatus == QUEST_COMPLETED) then
        if (evenmoreTravelsStatus == QUEST_AVAILABLE and player:getFameLevel(KAZHAM) >= 7 and player:needToZone() == false) then
        player:startEvent(148, 0, 256, 0, 0, 35000);
        else
            player:startEvent(147);
        end

    else
        player:startEvent(143);
    end

end;

function onEventUpdate(player,csid,option)
end;

function onEventFinish(player,csid,option)
    if (csid == 144 and option == 1)  then                     -- Gullible's Travels: First CS
        player:addQuest(OUTLANDS, GULLIBLES_TRAVELS);
    elseif (csid == 146) then                                  -- Gullible's Travels: Final CS
        player:confirmTrade();
        player:delGil(player:getVar("MAGRIFFON_GIL_REQUEST"));
        player:setVar("MAGRIFFON_GIL_REQUEST", 0);
        player:addFame(KAZHAM, 30);
        player:setTitle(285);                                     -- Global Variable not working for this quest
        player:completeQuest(OUTLANDS, GULLIBLES_TRAVELS);
        player:needToZone(true);
    elseif (csid == 148 and option == 1) then                  -- Even More Guillible's Travels First CS
        player:addQuest(OUTLANDS, EVEN_MORE_GULLIBLES_TRAVELS);
    elseif (csid == 150) then                                  -- Even More Guillible's Travels Second CS
        player:confirmTrade();
        player:delGil(35000);
        player:setVar("EVEN_MORE_GULLIBLES_PROGRESS", 1);
        player:setTitle(286);
        player:addKeyItem(dsp.ki.TREASURE_MAP);
        player:messageSpecial(KEYITEM_OBTAINED,dsp.ki.TREASURE_MAP);
    elseif (csid == 152) then
        player:setVar("EVEN_MORE_GULLIBLES_PROGRESS", 0);
        player:addFame(KAZHAM, 30);
        player:completeQuest(OUTLANDS, EVEN_MORE_GULLIBLES_TRAVELS);
    end
end;
