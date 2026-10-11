local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local Utils = {}

function Utils.getLocalPlayerTeam(
    LocalPlayer: Player
): string

    return LocalPlayer:GetAttribute("Team") :: string or "Spectator"
end

function Utils.getCharacterTeam(
    Character: Model
) : string

    local Accessories = Character:FindFirstChild("Accessories")
    if not Accessories then return "Spectator" end

    if Character:FindFirstChild("BeltCT") then return "CT" end
    if Character:FindFirstChild("BeltT") then return "T" end

    return "Spectator"
end

function Utils.isRagdoll(
    Character: Model
): boolean
    if Character == nil then return false end

    if Character.Parent.Name == "Ragdolls" then
        return true
    end

    return false
end

function Utils.getDroppedWeapons(): {Model}

    local Debris = workspace:FindFirstChild("Debris")
    if not Debris then return {} end

    local DroppedWeapons = Debris:FindFirstChild("DroppedWeapons")
    if not DroppedWeapons then return {} end

    return DroppedWeapons:GetChildren()
end

function Utils.getDroppedWeaponData(Weapons: {Model}): {[Model]: {any}}
    local weaponData = {}

    for _,Weapon in Weapons do
        weaponData[Weapon] = {
            Name = Weapon:GetAttribute("WeaponName");
            InBuyZone = Weapon:GetAttribute("InBuyZone")
        }
    end

    return weaponData
end

function Utils.getAdmins(
    Players: {Player}
)
    local Admins: {Player} = {}

    for _,Player in Players do
        if Player:GetAttribute("IsAdmin") then table.insert(Admins, Player) end
    end

    return Admins
end

function Utils.bombPlanted(): boolean
    local Debris = workspace:FindFirstChild("Debris")
    if Debris == nil then return false end

    local Bomb = Debris:FindFirstChild("Bomb")
    if Bomb == nil then return false end

    return #Bomb:GetChildren() >= 1
end

function Utils.bombPosition(): Vector3
    local Debris = workspace:FindFirstChild("Debris")
    if Debris == nil then return Vector3.zero end

    local Bomb = Debris:FindFirstChild("Bomb")
    if Bomb == nil then return Vector3.zero end

    local ActualBomb = Bomb:GetChildren()[1]
    if ActualBomb == nil then return Vector3.zero end

    return ActualBomb.Handle.Position
end

return Utils

