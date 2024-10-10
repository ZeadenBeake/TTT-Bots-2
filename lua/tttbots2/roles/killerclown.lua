if not TTTBots.Lib.IsTTT2() then return false end
if not ROLE_CLOWN then return false end

local _bh = TTTBots.Behaviors
local _prior = TTTBots.Behaviors.PriorityNodes
local bTree = {
    _prior.FightBack,
    _bh.Stalk,
    _bh.InvestigateCorpse,
    _prior.Restore,
    _bh.Interact,
    _prior.Minge,
    _prior.Investigate,
    _prior.Patrol
}

local killerclown = TTTBots.RoleData.New("killerclown", TEAM_JESTER)
killerclown:SetDefusesC4(false)
killerclown:SetStartsFights(true)
killerclown:SetCanHaveRadar(true)
killerclown:SetUsesSuspicion(false)
killerclown:SetTeam(TEAM_NONE)
killerclown:SetBTree(bTree)
killerclown:SetKnowsLifeStates(true)
TTTBots.Roles.RegisterRole(killerclown)

return true
