if not TTTBots.Lib.IsTTT2() then return false end
if not ROLE_LEECH then return false end

local _bh = TTTBots.Behaviors
local _prior = TTTBots.Behaviors.PriorityNodes
local bTree = {
    _prior.FightBack,
    _prior.Restore,
    _bh.Interact,
    _bh.Linger,
    _prior.Investigate,
    _prior.Minge,
    _prior.Patrol
}

local leech = TTTBots.RoleData.New("leech")
leech:SetDefusesC4(false)
leech:SetTeam(TEAM_NONE)
leech:SetBTree(bTree)
leech:SetCanHide(true)
leech:SetIsFollower(true)
leech:SetUsesSuspicion(false)
leech:SetAlliedRoles({})
leech:SetAlliedTeams({})
TTTBots.Roles.RegisterRole(leech)

return true
