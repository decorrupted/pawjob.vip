local Config = {
	Visuals = {
		Chams = {
			Enabled = false,
			ShowTeam = false,
            EnemyColor = Color3.fromRGB(255,0,0);
            TeamColor = Color3.fromRGB(0,255,0);
			ItemColor = Color3.fromRGB(0,0,255);
			PartChams = false;

			ShowName = false
		},
	},
}

local rconsolecreate = rconsolecreate or function(...) end
local rconsolesettitle = rconsolesettitle or function(...) end
local rconsoleerror = rconsoleerror or function(...) end
local rconsoleinfo = rconsoleinfo or function(...) end
local rconsoledestroy = rconsoledestroy or function(...) end
local rconsolewarn = rconsolewarn or function(...) end
local Drawing = Drawing or nil

local print = function(str)
    if not _G.Debug then return end
	rconsoleinfo(str .. "\n")
end

local warn = function(str)
    if not _G.Debug then return end
	rconsolewarn(str .. "\n")
end

local error = function(str)
    if not _G.Debug then return end
	rconsoleerror(str .. "\n")
end

local s,e = pcall(function()

	local function newQuad(color)
		local quad = Drawing.new("Quad")
		quad.Visible = false
		quad.PointA = Vector2.new(0, 0)
		quad.PointB = Vector2.new(0, 0)
		quad.PointC = Vector2.new(0, 0)
		quad.PointD = Vector2.new(0, 0)
		quad.Color = color
		quad.Filled = true
		quad.Thickness = 1
		quad.Transparency = 0.25
		return quad
	end

	local function Colorize(color, lib)
		for i, v in pairs(lib) do
			v.Color = color
		end
	end

	local function getPlayerTeam(Player)
		if not Player.Character then
			return "Spectator"
		end

		return Player.Character:GetAttribute("NOTrg_team")
	end

	

	local Config = {
		Visuals = {
			Chams = {
				Enabled = false,
				ShowTeam = false,
				EnemyColor = Color3.fromRGB(255, 0, 0),
				TeamColor = Color3.fromRGB(0, 255, 0),
			},
		},
	}

	local function Box3D(object, plr, character)
		local camera = workspace.CurrentCamera
		local part = object
		--// Quads for 3D box (6)
		local quads = {
			quad1 = newQuad(Color3.fromRGB(255, 0, 0)),
			quad2 = newQuad(Color3.fromRGB(255, 0, 0)),
			quad3 = newQuad(Color3.fromRGB(255, 0, 0)),
			quad4 = newQuad(Color3.fromRGB(255, 0, 0)),
			quad5 = newQuad(Color3.fromRGB(255, 0, 0)),
			quad6 = newQuad(Color3.fromRGB(255, 0, 0)),
		}

		--// Updates ESP in render loop
		local function Updater()
			local connection
			connection = game:GetService("RunService").RenderStepped:Connect(function()
				local s, e = pcall(function()
					if
						plr.Character ~= nil
						and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil
						and plr.Character:FindFirstChild("Humanoid") ~= nil
						and plr.Character.Humanoid.Health > 0
						and plr.Character:FindFirstChild(object.Name) ~= nil
					then
						local partpos, onscreen = camera:WorldToViewportPoint(part.Position)
						if onscreen and getPlayerTeam(plr) ~= "Spectator" then

							if Config.Visuals.Chams.Enabled == false then
								for u, x in pairs(quads) do
									x.Visible = false
								end
                                return
							else
								for u, x in pairs(quads) do
									x.Visible = true
								end
							end

							local size_X = part.Size.X / 2
							local size_Y = part.Size.Y / 2
							local size_Z = part.Size.Z / 2

							local Top1 =
								camera:WorldToViewportPoint((part.CFrame * CFrame.new(-size_X, size_Y, -size_Z)).p)
							local Top2 =
								camera:WorldToViewportPoint((part.CFrame * CFrame.new(-size_X, size_Y, size_Z)).p)
							local Top3 =
								camera:WorldToViewportPoint((part.CFrame * CFrame.new(size_X, size_Y, size_Z)).p)
							local Top4 =
								camera:WorldToViewportPoint((part.CFrame * CFrame.new(size_X, size_Y, -size_Z)).p)

							local Bottom1 =
								camera:WorldToViewportPoint((part.CFrame * CFrame.new(-size_X, -size_Y, -size_Z)).p)
							local Bottom2 =
								camera:WorldToViewportPoint((part.CFrame * CFrame.new(-size_X, -size_Y, size_Z)).p)
							local Bottom3 =
								camera:WorldToViewportPoint((part.CFrame * CFrame.new(size_X, -size_Y, size_Z)).p)
							local Bottom4 =
								camera:WorldToViewportPoint((part.CFrame * CFrame.new(size_X, -size_Y, -size_Z)).p)

							--// Top:
							quads.quad1.PointA = Vector2.new(Top1.X, Top1.Y)
							quads.quad1.PointB = Vector2.new(Top2.X, Top2.Y)
							quads.quad1.PointC = Vector2.new(Top3.X, Top3.Y)
							quads.quad1.PointD = Vector2.new(Top4.X, Top4.Y)

							--//Bottom:
							quads.quad2.PointA = Vector2.new(Bottom1.X, Bottom1.Y)
							quads.quad2.PointB = Vector2.new(Bottom2.X, Bottom2.Y)
							quads.quad2.PointC = Vector2.new(Bottom3.X, Bottom3.Y)
							quads.quad2.PointD = Vector2.new(Bottom4.X, Bottom4.Y)

							--//Sides:
							quads.quad3.PointA = Vector2.new(Top1.X, Top1.Y)
							quads.quad3.PointB = Vector2.new(Top2.X, Top2.Y)
							quads.quad3.PointC = Vector2.new(Bottom2.X, Bottom2.Y)
							quads.quad3.PointD = Vector2.new(Bottom1.X, Bottom1.Y)

							quads.quad4.PointA = Vector2.new(Top2.X, Top2.Y)
							quads.quad4.PointB = Vector2.new(Top3.X, Top3.Y)
							quads.quad4.PointC = Vector2.new(Bottom3.X, Bottom3.Y)
							quads.quad4.PointD = Vector2.new(Bottom2.X, Bottom2.Y)

							quads.quad5.PointA = Vector2.new(Top3.X, Top3.Y)
							quads.quad5.PointB = Vector2.new(Top4.X, Top4.Y)
							quads.quad5.PointC = Vector2.new(Bottom4.X, Bottom4.Y)
							quads.quad5.PointD = Vector2.new(Bottom3.X, Bottom3.Y)

							quads.quad6.PointA = Vector2.new(Top4.X, Top4.Y)
							quads.quad6.PointB = Vector2.new(Top1.X, Top1.Y)
							quads.quad6.PointC = Vector2.new(Bottom1.X, Bottom1.Y)
							quads.quad6.PointD = Vector2.new(Bottom4.X, Bottom4.Y)

                            if Config.Visuals.Chams.ShowTeam then
								if getPlayerTeam(plr) == getPlayerTeam(game.Players.LocalPlayer) then
									Colorize(Config.Visuals.Chams.TeamColor, quads)
								else
                                    if getPlayerTeam(plr) ~= "Traitor" and getPlayerTeam(game.Players.LocalPlayer) == "Spectator" then
                                        Colorize(Config.Visuals.Chams.TeamColor, quads)
                                    else
                                        Colorize(Config.Visuals.Chams.EnemyColor, quads)
                                    end
								end
                            else

                                if getPlayerTeam(plr) == getPlayerTeam(game.Players.LocalPlayer) then
                                    for u, x in pairs(quads) do
                                        x.Visible = false
                                    end
                                else                                    
                                    for u, x in pairs(quads) do
                                        x.Visible = true
                                    end
                                end

                                Colorize(Config.Visuals.Chams.EnemyColor, quads)
                            end

							for u, x in pairs(quads) do
								x.Visible = true
							end
						else
							for u, x in pairs(quads) do
								x.Visible = false
							end
						end
					else
						for u, x in pairs(quads) do
							x.Visible = false
						end
						if game.Players:FindFirstChild(plr.Name) == nil then
							for _, quad in quads do
								quad:Destroy()
							end
							connection:Disconnect()
						end
					end
					if plr.Character ~= character then
						for _, quad in quads do
							quad:Destroy()
						end
						connection:Disconnect()
					end
				end)
				if not s then
					error(e)
				end
			end)
		end
		task.spawn(Updater)
	end

	local Players = game:GetService("Players")
	local Client = Players.LocalPlayer

	if not Drawing then
		Client:Kick("[pawjob.vip] Executor not supported")
		return
	end

	local Players = game:GetService("Players")
	local Client = Players.LocalPlayer

    if _G.Debug then
        rconsolecreate()
        rconsolesettitle("pawjob.vip | debug")
    end

	print("Initalizing")
	print(Client.Name)

	local function playerWrapper(plr)
		local function characterWrapper(char)
			for u, x in pairs(char:GetChildren()) do
				if
					x:IsA("MeshPart")
					or x.Name == "Head"
					or x.Name == "Left Arm"
					or x.Name == "Right Arm"
					or x.Name == "Right Leg"
					or x.Name == "Left Leg"
					or x.Name == "Torso"
				then
					Box3D(x, plr, char)
				end
			end
		end

		plr.CharacterAdded:Connect(characterWrapper)
		if plr.Character then
			characterWrapper(plr.Character)
		end
	end

	for _, v in Players:GetPlayers() do
		if v == Client then
			continue
		end
		playerWrapper(v)
	end

	Players.PlayerAdded:Connect(playerWrapper)

	--[[
	for _,v in workspace.Game.Loot.drops:GetChildren() do
		droppedItemsWrapper(v)
	end

	workspace.Game.Loot.drops.ChildAdded(droppedItemsWrapper)
	]]--

	local UserInputService = game:GetService("UserInputService")

	local Bracket = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Bracket/main/BracketV32.lua"))()

	local Window = Bracket:Window({
		Name = "Pawjob.vip - Retrograd",
		Enabled = true,
		Color = Color3.new(1, 0.5, 0.25),
		Size = UDim2.new(0, 496, 0, 496),
		Position = UDim2.new(0.5, -248, 0.5, -248),
	})

	do
		local Visuals = Window:Tab({ Name = "Visuals" })

		local Chams = Visuals:Toggle({ Name = "Enable Chams", Side = "Left", Value = false, Callback = function(Bool)
			Config.Visuals.Chams.Enabled = Bool
		end })

		local ShowTeam = Visuals:Toggle({ Name = "Show Team", Side = "Left", Value = false, Callback = function(Bool)
			Config.Visuals.Chams.ShowTeam = Bool
		end })

		local isOpen = true

		UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
			if input.KeyCode == Enum.KeyCode.Home then
				Window:Toggle(not isOpen)
				isOpen = not isOpen
			end
		end)
	end

	local HttpService = game:GetService("HttpService")

	request({
		Url = "http://127.0.0.1:6463/rpc?v=1",
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
			["Origin"] = "https://discord.com",
		},
		Body = HttpService:JSONEncode({
			cmd = "INVITE_BROWSER",
			args = {
				code = "d8CQP38Y8s",
			},
			nonce = HttpService:GenerateGUID(false),
		}),
	})

end)

if e then
    error(e)
end
