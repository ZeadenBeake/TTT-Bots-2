
TTTBots.Behaviors.KillOnSight = {}

local lib = TTTBots.Lib

local KillOnSight = TTTBots.Behaviors.KillOnSight
KillOnSight.Name = "Kill on sight"
KillOnSight.Description = "Wanders around the map, killing anyone they see."
KillOnSight.Interruptible = true
KillOnSight.Debug = false

KillOnSight.CHANCE_TO_HIDE_IF_TRAIT = 3 -- 1 in X chance of hiding (or going to sniper spot) if we have a relevant trait

local STATUS = TTTBots.STATUS

local function printf(...)
    print(string.format(...))
end

--- Validate the behavior
function KillOnSight.Validate(bot)
    return true
end

--- Called when the behavior is started
function KillOnSight.OnStart(bot)
    KillOnSight.UpdateWanderGoal(bot) -- sets bot.wander
    return STATUS.RUNNING
end

--- Called when the behavior's last state is running
function KillOnSight.OnRunning(bot)
    print("KOS is running")
    if not bot.wander then return KillOnSight.OnStart() end -- force reboot :P

    local hasExpired = KillOnSight.HasExpired(bot)
    if hasExpired then return STATUS.SUCCESS end

    local wanderPos = bot.wander.targetPos
    local loco = bot:BotLocomotor()
    loco:SetGoal(wanderPos)

    if loco:IsCloseEnough(wanderPos) then
        KillOnSight.StareAtNearbyPlayers(bot, loco)
    end

    return STATUS.RUNNING
end

---Make the bot stare at the nearest player. Useful for when the bot is standing still.
---@param bot Bot
---@param locomotor CLocomotor
function KillOnSight.StareAtNearbyPlayers(bot, locomotor)
    local players = lib.GetAllVisible(bot:GetPos(), false)
    local closest = lib.GetClosest(players, bot:GetPos())

    if closest then
        bot:SetAttackTarget(closest)
    end
end

--- Called when the behavior returns a success state
function KillOnSight.OnSuccess(bot)
end

--- Called when the behavior returns a failure state
function KillOnSight.OnFailure(bot)
end

--- Called when the behavior ends
function KillOnSight.OnEnd(bot)
    bot.wander = nil
end

function KillOnSight.DestinationCloseEnough(bot)
    if not bot.wander then return true end
    local dest = bot.wander.targetPos
    local pos = bot:GetPos()
    local dist = pos:Distance(dest)
    return dist < 100
end

function KillOnSight.HasExpired(bot)
    local wander = bot.wander
    if not wander then return true end
    local ctime = CurTime()
    local DIST_CLOSE_THRESH = 100
    local closeEnough = (ctime > wander.timeEndClose) and (bot:GetPos():Distance(wander.targetPos))
    return closeEnough or (wander.timeEndFar < ctime)
end

--- Returns a random nav area in the nearest region to the bot
function KillOnSight.GetRandomNavInRegion(bot)
    if not (bot and bot.GetPos) then
        error("Unknown bot ent: " .. tostring(bot), 5)
        return nil
    end
    return lib.GetRandomNavInNearestRegion(bot:GetPos())
end

--- Gets a random nav area from the entire navmesh
function KillOnSight.GetRandomNav()
    return table.Random(navmesh.GetAllNavAreas())
end

---Return if the role can see all C4s inherently, or if it must have someone spot it first
---@param bot Bot
---@return boolean
function KillOnSight.BotCanSeeAllC4(bot)
    local role = TTTBots.Roles.GetRoleFor(bot)
    local canPlant = role:GetPlantsC4()

    return canPlant
end

--- Returns a random nav with preference to the current area
function KillOnSight.GetAnyRandomNav(bot, level)
    level = level or 0
    -- 80% chance of getting a random nav in the nearest region, 20% chance of getting a random nav from the entire navmesh
    local area = (math.random(1, 5) <= 4 and KillOnSight.GetRandomNavInRegion(bot)) or KillOnSight.GetRandomNav()

    if level < 5 then
        -- Test if the area is near a known bomb
        local omniscient = KillOnSight.BotCanSeeAllC4(bot)
        local bombs = (omniscient and TTTBots.Match.AllArmedC4s) or TTTBots.Match.SpottedC4s

        for bomb, _ in pairs(bombs) do
            if not IsValid(bomb) then continue end
            local bombPos = bomb:GetPos()
            local dist = bombPos:Distance(area:GetCenter())
            if dist < 1000 then
                return KillOnSight.GetAnyRandomNav(bot, level + 1)
            end
        end
    end

    return area
end

---Finds a place to hide/snipe at. Returns if we found a spot and where it is (or nil)
---@param bot Bot
---@return boolean foundSpot
---@return Vector? pos pos or nil if we didn't find a spot
function KillOnSight.FindSpotFor(bot)
    local personality = bot:BotPersonality()
    if not personality then return false, nil end

    local randomChance = math.random(1, 10) == 1

    local isHidingRole = TTTBots.Roles.GetRoleFor(bot):GetCanHide()
    local canHide = isHidingRole and (personality:GetTraitBool("hider") or randomChance)

    local isSnipingRole = TTTBots.Roles.GetRoleFor(bot):GetCanSnipe()
    local canSnipe = isSnipingRole and (personality:GetTraitBool("sniper") or randomChance)

    local randomChanceTrait = math.random(1, KillOnSight.CHANCE_TO_HIDE_IF_TRAIT) == 1

    if (canHide or canSnipe) and randomChanceTrait then
        local kindStr = (canHide and "hiding") or "sniper"
        local spot = TTTBots.Spots.GetNearestSpotOfCategory(bot:GetPos(), kindStr)
        if spot then
            if KillOnSight.Debug then
                printf("Bot %s wandering to a %s spot", bot:Nick(), kindStr)
            end
            return true, spot + Vector(0, 0, 64)
        end
    end
    return false, nil
end

function KillOnSight.UpdateWanderGoal(bot)
    local targetArea
    local targetPos
    local isSpot = false
    local personality = bot:BotPersonality()
    if not personality then return end

    ---------------------------------------------
    -- relevant personality traits: loner, lovescrowds
    ---------------------------------------------
    local isLoner = personality:GetTraitBool("loner")
    local lovesCrowds = personality:GetTraitBool("lovesCrowds")
    local popularNavs = TTTBots.Lib.PopularNavsSorted
    local adhereToPersonality = (isLoner or lovesCrowds) and math.random(1, 5) <= 4
    if adhereToPersonality and #popularNavs > 10 then
        local topNNavs = {}
        local bottomNNavs = {}
        local N = 4

        for i = 1, N do
            if not popularNavs[i] then break end
            table.insert(topNNavs, popularNavs[i])
        end
        for i = #popularNavs - N, #popularNavs do
            if not popularNavs[i] then break end
            table.insert(bottomNNavs, popularNavs[i])
        end

        if lovesCrowds then
            targetArea = navmesh.GetNavAreaByID(table.Random(topNNavs)[1])
            if KillOnSight.Debug then
                printf("Bot %s wandering to a popular area", bot:Nick())
            end
        else
            targetArea = navmesh.GetNavAreaByID(table.Random(bottomNNavs)[1])
            if KillOnSight.Debug then
                printf("Bot %s wandering to an unpopular area", bot:Nick())
            end
        end
    end

    ---------------------------------------------
    -- relevant personality traits: hider, sniper
    -- everyone can hide or go to a sniper spot, but the above traits do it more
    ---------------------------------------------
    local isSpot, newPos = KillOnSight.FindSpotFor(bot)
    if newPos then targetPos = newPos end

    if not targetArea then
        targetArea = KillOnSight.GetAnyRandomNav(bot)
    end

    if targetArea and not targetPos then
        targetPos = targetArea:GetRandomPoint()
    elseif targetPos and not targetArea then
        targetArea = navmesh.GetNearestNavArea(targetPos)
    end

    local time = CurTime()

    local wanderTbl = {
        targetArea = targetArea,
        targetPos = targetPos,
        timeStart = time,
        timeEndFar = time + math.random(6, 24) * (isSpot and 1.5 or 1),
        timeEndClose = time + math.random(3, 12) * (isSpot and 1.5 or 1),
    }

    bot.wander = wanderTbl

    return wanderTbl
end
