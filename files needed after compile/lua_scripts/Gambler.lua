local NPC_ID = 60005
local TOKEN_ID = 46691
 
function Gambler_Gossip(event, plr, unit)
    plr:GossipMenuAddItem(6, "You ready to gamble, "..plr:GetName().."?", 0, 1, true, "Insert amount of tokens you want to gamble!")
    plr:GossipMenuAddItem(0, "Nevermind", 0, 2)
    plr:GossipSendMenu(1, unit)
end
 
function Gambler_Event(event, plr, unit, sender, intid, code)
    local chance = math.random(1,5) -- This'll give you a 20% chance to win.
    if(intid == 1) then
        if (tonumber(code)) then -- Check if player actually specified an amount in numbers
            if(plr:GetItemCount(TOKEN_ID) < tonumber(code)) then
                plr:SendBroadcastMessage("|cFFFFFF9F"..unit:GetName().." says: You do not have "..tonumber(code).." tokens!")
            else
                if(chance == 1) then
                    plr:SendBroadcastMessage("|cFFFFFF9F"..unit:GetName().." says: Congratulations! You won "..math.ceil(code*0.8).." Tokens!")
                    plr:AddItem(TOKEN_ID, math.ceil(tonumber(code)*0.8))
                else
                    plr:SendBroadcastMessage("|cFFFFFF9F"..unit:GetName().." says: Too bad "..plr:GetName()..", better luck next time!")
                    plr:RemoveItem(TOKEN_ID, tonumber(code))
                end
            end
        else
            plr:SendBroadcastMessage("|cFFFFFF9F"..unit:GetName().." says: You need to use numbers, not letters.")
        end
    end
    plr:GossipComplete()
end
 
RegisterCreatureGossipEvent(NPC_ID, 1, Gambler_Gossip)
RegisterCreatureGossipEvent(NPC_ID, 2, Gambler_Event)