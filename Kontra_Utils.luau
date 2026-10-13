local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Utils = {}

function Utils.getSoundList(): {[string]: {Group: string, CleanName: string}}

    return {
        ["Footsteps.ConcreteCt"] = { Group = "Footstep", CleanName = "Concrete Footstep" },
        ["Footsteps.LandConcrete"] = { Group = "Footstep", CleanName = "Concrete Landing Footstep" },
        ["Impacts.Body.BodyImpactCt"] = { Group = "BodyImpact", CleanName = "Body Impact" },
        ["Impacts.Body.BodyImpactTSoft"] = { Group = "BodyImpact", CleanName = "Body Impact" },
        ["Impacts.Body.BodyMediumImpactSoft"] = { Group = "BodyImpact", CleanName = "Body Impact" },
        ["Impacts.Cardboard.CardboardBoxImpactBullet"] = { Group = "BulletImpact", CleanName = "Bullet Impact" },
        ["Impacts.Concrete.ConcreteImpactBullet"] = { Group = "BulletImpact", CleanName = "Bullet Impact" },
        ["Impacts.Concrete.ConcreteImpactHard"] = { Group = "HardImpact", CleanName = "Hard Impact" },
        ["Impacts.Concrete.ConcreteImpactSoft"] = { Group = "SoftImpact", CleanName = "Soft Impact" },
        ["Impacts.Glass.GlassImpactBullet"] = { Group = "BulletImpact", CleanName = "Bullet Impact" },
        ["Impacts.Metal.MetalBoxImpactBullet"] = { Group = "BulletImpact", CleanName = "Bullet Impact" },
        ["Impacts.Metal.MetalSolidImpactBullet"] = { Group = "BulletImpact", CleanName = "Bullet Impact" },
        ["Impacts.Rubber.RubberTireImpactBullet"] = { Group = "BulletImpact", CleanName = "Bullet Impact" },
        ["Impacts.Surfaces.DefaultImpactBullet"] = { Group = "BulletImpact", CleanName = "Bullet Impact" },
        ["Impacts.Weapon.WeaponC4Impact"] = { Group = "WeaponImpact", CleanName = "Weapon Impact" },
        ["Impacts.Weapon.WeaponRifleImpact"] = { Group = "WeaponImpact", CleanName = "Weapon Impact" },
        ["Items.pickup-ammo"] = { Group = "ItemPickup", CleanName = "Ammo Pickup" },
        ["Items.pickup-weapon"] = { Group = "ItemPickup", CleanName = "Weapon Pickup" },
        ["Misc.Death"] = { Group = "Death", CleanName = "Player Death" },
        ["Misc.HeadshotArmorE"] = { Group = "Headshot", CleanName = "Armored Headshot" },
        ["Misc.HeadshotArmorFlesh"] = { Group = "Headshot", CleanName = "Flesh Headshot" },
        ["Misc.Land"] = { Group = "Landing", CleanName = "Landing" },
        ["Other.Debris"] = { Group = "Debris", CleanName = "Debris" },
        ["Weapons.AK-47.Fire"] = { Group = "WeaponFire", CleanName = "AK-47 Fire" },
        ["Weapons.AWP.Fire"] = { Group = "WeaponFire", CleanName = "AWP Fire" },
        ["Weapons.Desert Eagle.Fire"] = { Group = "WeaponFire", CleanName = "Desert Eagle Fire" },
        ["Weapons.M4A4.Fire"] = { Group = "WeaponFire", CleanName = "M4A4 Fire" },
        ["Weapons.MAC-10.Fire"] = { Group = "WeaponFire", CleanName = "MAC-10 Fire" },
    }

end

function Utils.getSoundGroup(SoundName: string): string
    local soundDict = Utils.getSoundList()

    if not soundDict[SoundName] then
        warn(SoundName, "was passed however there is no entry.")
        return "Unknown"
    end

    return soundDict[SoundName].Group
end

function Utils.cleanSoundName(SoundName: string): string
    local soundDict = Utils.getSoundList()

    if not soundDict[SoundName] then
        warn(SoundName, "was passed however there is no entry.")
        return "Unknown"
    end

    return soundDict[SoundName].CleanName
end

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

