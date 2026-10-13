local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

function Utils.getSounds(): {Part}

    local Debris = workspace:FindFirstChild("Debris")
    if not Debris then return {} end

    local Sounds = Debris:FindFirstChild("Sounds")
    if not Sounds then return {} end

    return Sounds:GetChildren()
end

function Utils.getAudibleSounds(sounds: {Part}): {Part}
    local Listener = workspace.CurrentCamera:FindFirstChild("SoundManagerListener")
    if not Listener then return {} end

    local audibleSounds = {}

    for _,sfx in sounds do
        local emitter: AudioEmitter = sfx:FindFirstChild("AudioEmitter")
        if not emitter then continue end

        if emitter:GetAudibilityFor(Listener) then
            table.insert(audibleSounds, sfx)
        end
    end

    return audibleSounds
end

function Utils.isRagdoll(
    Character: Model
): boolean
    if Character == nil then return false end
    if Character.Parent == nil then return true end

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

function Utils.GetGameState(): {[string]: any}

    local GameStats = ReplicatedStorage:FindFirstChild("GameStats")
    if not GameStats then return {} end

    local currentState = {}

    for _,state in {
        "BuyTime",
        "CanBuy",
        "Gamemode",
        "Map",
        "PreparationEndTick",
        "ServerRegion",
        "State",
        "Time",
    } do
        currentState[state] = GameStats:GetAttribute(state)
    end

    return currentState

end

return Utils

