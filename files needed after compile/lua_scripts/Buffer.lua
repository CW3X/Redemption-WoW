local NPC_ID = 60004

local function OnGossipHello(event, player, object)
    player:GossipClearMenu() -- required for player gossip
	player:GossipMenuAddItem(0, "Buff Me", 1, 1)
	player:GossipMenuAddItem(0, "Heal Me", 1, 2)
	player:GossipMenuAddItem(0, "Remove Sickness", 1, 3)
    player:GossipSendMenu(1, object, MenuId) -- MenuId required for player gossip
end

local function OnGossipSelect(event, player, object, sender, intid, code, menuid)
if (intid == 1) then
	player:CastSpell(player, 48469, true)
	player:CastSpell(player, 48073, true)
	player:CastSpell(player, 48161, true)
	player:CastSpell(player, 56525, true)
elseif (intid == 2) then
	player:CastSpell(player, 69693, true)
elseif (intid == 3) then
	if player:HasAura(15007) then
       player:RemoveAura(15007)
	 end
  end
end

RegisterCreatureGossipEvent(NPC_ID, 1, OnGossipHello)
RegisterCreatureGossipEvent(NPC_ID, 2, OnGossipSelect)