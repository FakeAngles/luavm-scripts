_G.tween_speed = 200000
local player = Players.LocalPlayer
local character = player.Character
if not character then return end

local rootPart = character:FindFirstChild("HumanoidRootPart")
if not rootPart then return end

local humanoid = character:FindFirstChildOfClass("Humanoid")

function tween_position(object, target_pos, duration)
    local start_time = os.clock()
    local start_pos = object.Position
    local end_time = start_time + duration

    while os.clock() < end_time do
        if not object or not object.Parent then break end

        local alpha = (os.clock() - start_time) / duration
        if alpha > 1 then alpha = 1 end

        object.Position = Vector3.new(
            start_pos.X + (target_pos.X - start_pos.X) * alpha,
            start_pos.Y + (target_pos.Y - start_pos.Y) * alpha,
            start_pos.Z + (target_pos.Z - start_pos.Z) * alpha
        )
        object.Velocity = Vector3.new(0, 0, 0)
    end

    object.Position = target_pos
end

function freeze_in_air(duration)
    local target_pos = rootPart.Position
    local start_time = os.clock()

    while os.clock() - start_time < duration do
        if not rootPart or not rootPart.Parent then break end
        rootPart.Position = target_pos
        rootPart.Velocity = Vector3.new(0, 0, 0)
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        if humanoid then humanoid.PlatformStand = true end
        task.wait()
    end
end

local originalPosition = rootPart.Position
local targetPosition = originalPosition + Vector3.new(0, 770000, 0)
local safeLandingPosition = originalPosition + Vector3.new(0, 2, 0)

notify("Teleporting up 770k", "Teleport", 1)
tween_position(rootPart, targetPosition, 770000 / _G.tween_speed)

notify("Holding 5 seconds", "Teleport", 1)
freeze_in_air(5)

if humanoid then humanoid.PlatformStand = false end

notify("Returning", "Teleport", 1)
tween_position(rootPart, safeLandingPosition, 770000 / _G.tween_speed)

task.wait(0.1)
rootPart.Velocity = Vector3.new(0, -2, 0)

notify("Landed", "Teleport", 1)
