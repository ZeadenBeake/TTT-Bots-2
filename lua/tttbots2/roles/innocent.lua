local innocent = TTTBots.RoleData.New("innocent")
innocent:SetDefusesC4(true)
innocent:SetTeam(TEAM_INNOCENT)
innocent:SetBTree(TTTBots.Behaviors.DefaultTrees.innocent)
innocent:SetCanHide(true)
innocent:SetCanSnipe(true)
TTTBots.Roles.RegisterRole(innocent)

return true
