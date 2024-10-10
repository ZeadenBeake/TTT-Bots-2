if not (TTT2 and ROLE_LEECH) then return end

---@class BLinger
TTTBots.Behaviors.Linger = {}

local lib = TTTBots.Lib

---@class BLinger
local Linger = TTTBots.Behaviors.Linger
Linger.Name = "Linger"
Linger.Description = "Linger close to another person, uncomfortably close."
Linger.Interruptible = true

---@class Bot

local STATUS = TTTBots.STATUS

---@param bot Bot
function Linger.OnStart(bot)
    return STATUS.RUNNING
end

---@param bot Bot
function Linger.GetTarget(bot)
    local players = lib.GetAllWitnessesBasic(bot:GetPos(), nil, bot)
    local closest = lib.GetClosest(players, bot:GetPos())

    if closest then
        return closest
    else
        print("Nobody around!")
    end
end

---@param bot Bot
function Linger.OnRunning(bot)
    print("Linger is running")
    local target = Linger.GetTarget(bot)
    print(target)

    if not (target and IsValid(target)) then return STATUS.FAILURE end

    local loco = bot:BotLocomotor()

    local distToTarget = bot:GetPos():Distance(target:GetPos())
    local maxDist = 100

    if distToTarget > maxDist then
        print(target:GetPos())
        loco:SetGoal(target:GetPos())
        loco:DisableAvoid()
    else
        loco:StopMoving()
    end

    return STATUS.RUNNING
end

---@param bot Bot
function Linger.OnEnd(bot)
    local loco = bot:BotLocomotor()
    loco:StopMoving()
    loco:EnableAvoid()
end