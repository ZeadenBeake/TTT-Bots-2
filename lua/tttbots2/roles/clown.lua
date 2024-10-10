if not TTTBots.Lib.IsTTT2() then return false end
if not ROLE_CLOWN then return false end

local allyTeams = {
    [TEAM_JESTER] = true,
    [TEAM_TRAITOR] = true
}

local _bh = TTTBots.Behaviors
local _prior = TTTBots.Behaviors.PriorityNodes
local bTree = {
    _prior.FightBack,
    _prior.Restore,
    _prior.Minge,
    _prior.Investigate,
    _prior.Patrol
}

local clown = TTTBots.RoleData.New("clown", TEAM_JESTER)
clown:SetDefusesC4(false)
clown:SetCanHide(true)
clown:SetStartsFights(false) -- Clowns don't *actually* want to die. -Z
clown:SetTeam(TEAM_JESTER)
clown:SetBTree(bTree)
clown:SetAlliedTeams(allyTeams)
TTTBots.Roles.RegisterRole(clown)

-- TTTBotsModifySuspicion hook
hook.Add("TTTBotsModifySuspicion", "TTTBots.jester.sus", function(bot, target, reason, mult)
    local role = target:GetRoleStringRaw()
    if role == 'jester' then
        if TTTBots.Lib.GetConVarBool("cheat_know_jester") then
            return mult * 0.3
        end
    end
end)

return true
