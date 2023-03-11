--[[
    Addons : ByYoSe - Unstuck system
]]

function B_CollisionMap(pPos, minBound, maxBound)
    if not util.IsInWorld(Vector(pPos.x + minBound.x, pPos.y + minBound.y, pPos.z + minBound.z)) then return true end
    if not util.IsInWorld(Vector(pPos.x - minBound.x, pPos.y + minBound.y, pPos.z + minBound.z)) then return true end
    if not util.IsInWorld(Vector(pPos.x - minBound.x, pPos.y - minBound.y, pPos.z + minBound.z)) then return true end
    if not util.IsInWorld(Vector(pPos.x + minBound.x, pPos.y - minBound.y, pPos.z + minBound.z)) then return true end
    if not util.IsInWorld(Vector(pPos.x + maxBound.x, pPos.y + maxBound.y, pPos.z + maxBound.z)) then return true end
    if not util.IsInWorld(Vector(pPos.x - maxBound.x, pPos.y + maxBound.y, pPos.z + maxBound.z)) then return true end
    if not util.IsInWorld(Vector(pPos.x - maxBound.x, pPos.y - maxBound.y, pPos.z + maxBound.z)) then return true end
    if not util.IsInWorld(Vector(pPos.x + maxBound.x, pPos.y - maxBound.y, pPos.z + maxBound.z)) then return true end

    for i = 0.2, 0.8, 0.2 do
        if not util.IsInWorld(Vector(pPos.x, pPos.y, pPos.z + (maxBound.z + minBound.z) * i)) then return true end
    end

    return false
end

function B_CollisionProps(pPos, minBound, maxBound)
    lowerPos = Vector()
    lowerPos:Set(pPos)
    lowerPos:Add(minBound)
    upperPos = Vector()
    upperPos:Set(pPos)
    upperPos:Add(maxBound)
    t = ents.FindInBox(lowerPos, upperPos)

    for key, value in pairs(t) do
        colliding = value:GetSolid() == SOLID_VPHYSICS

        if colliding then return true end
    end

    return false
end

function B_FindNewPos(ply, try)

    local minBound, maxBound = ply:GetCollisionBounds()
    local oldZVelo = ply:GetVelocity().z

    ply:SetVelocity(Vector(0, 0, 250))

    timer.Simple(0.1, function()
        local absZdelta = math.abs((ply:GetVelocity().z - oldZVelo))

        if absZdelta > 30 then return end

        local pos = ply:GetPos()

        if try > 0 then
            pos:Add(Vector(0, 0, 30))
            ply:SetPos(pos)
        end

        for i = 15, 10550.0, 0.1 do
            local Pos = Vector(math.random(-i, i) + pos.x, math.random(-i, i) + pos.y, math.random(-i, i) + pos.z)
            if not B_CollisionMap(Pos, minBound, maxBound) then
                if not B_CollisionProps(Pos, minBound, maxBound) then
                    ply:SetPos(Pos)

                    if try < 5 then
                        try = try + 1
                        B_FindNewPos(ply, try)
                    end

                    return
                end
            end
        end
    end)
end

function B_Unstuck(ply)
    if ply:GetMoveType() == MOVETYPE_OBSERVER or ply:InVehicle() or not ply:Alive() then return end

    B_FindNewPos(ply, 0)
end

hook.Add("PlayerSay", "playersaystuck", function(ply, text)
    if (text == ByYoSe_Unstuck_Command) then
        if ply.UnstuckCurtime == nil then
            ply.UnstuckCurtime = CurTime() - 1
        end
        if (ply.UnstuckCurtime < CurTime()) then
            if ply:Alive() then
                ply.UnstuckCurtime = CurTime() + 10
                B_Unstuck(ply) 
            end
        end
        return ""
    end
end)