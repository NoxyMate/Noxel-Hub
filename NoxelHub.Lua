

local ScreenGui = Instance.new("ScreenGui")
local main = Instance.new("ImageLabel")
local Noxeltext = Instance.new("TextLabel")
local combatlabel = Instance.new("TextLabel")
local silentAim = Instance.new("TextButton")
local Killall = Instance.new("TextButton")
local BoxEsp = Instance.new("TextButton")
local Visualslabel = Instance.new("TextLabel")
local Tracers = Instance.new("TextButton")
local Wallbang = Instance.new("TextButton")
local GunMod = Instance.new("TextButton")



ScreenGui.Parent = game.CoreGui

main.Name = "main"
main.Parent = ScreenGui
main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
main.BackgroundTransparency = 1.000
main.Position = UDim2.new(0.350707382, 0, 0.359036148, 0)
main.Size = UDim2.new(0, 400, 0, 222)
main.Image = "rbxassetid://3570695787"
main.ImageColor3 = Color3.fromRGB(30, 30, 30)
main.ScaleType = Enum.ScaleType.Slice
main.SliceCenter = Rect.new(100, 100, 100, 100)
main.SliceScale = 0.050
main.Active = true
main.Draggable = true

Noxeltext.Name = "Noxeltext"
Noxeltext.Parent = main
Noxeltext.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Noxeltext.BorderColor3 = Color3.fromRGB(30, 30, 30)
Noxeltext.Position = UDim2.new(0.0199999996, 0, 0.0257510729, 0)
Noxeltext.Size = UDim2.new(0, 383, 0, 44)
Noxeltext.Font = Enum.Font.GothamBlack
Noxeltext.Text = "Noxel Hub"
Noxeltext.TextColor3 = Color3.fromRGB(255, 255, 255)
Noxeltext.TextSize = 14.000
Noxeltext.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)

combatlabel.Name = "combat label"
combatlabel.Parent = main
combatlabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
combatlabel.BorderColor3 = Color3.fromRGB(30, 30, 30)
combatlabel.Position = UDim2.new(0.00999999978, 0, 0.164153501, 0)
combatlabel.Size = UDim2.new(0, 163, 0, 33)
combatlabel.Font = Enum.Font.GothamBlack
combatlabel.Text = "Combat"
combatlabel.TextColor3 = Color3.fromRGB(255, 255, 255)
combatlabel.TextSize = 14.000

silentAim.Name = "silent Aim"
silentAim.Parent = main
silentAim.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
silentAim.BorderColor3 = Color3.fromRGB(40, 40, 40)
silentAim.Position = UDim2.new(0.00999999978, 0, 0.313304722, 0)
silentAim.Size = UDim2.new(0, 164, 0, 36)
silentAim.Font = Enum.Font.GothamBlack
silentAim.Text = "Silent Aim"
silentAim.TextColor3 = Color3.fromRGB(255, 255, 255)
silentAim.TextSize = 14.000

silentAim.MouseButton1Down:connect(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local mouse = LocalPlayer:GetMouse()
	local Camera = workspace.CurrentCamera
	local Debris = game:GetService("Debris")
	local UserInputService = game:GetService("UserInputService")
	local target = false
	local RunService = game:GetService("RunService")


	getfenv().lock = "Head" -- Head or Hitbox or Random

	fov = 250;
	local fovCircle = true;
	local st = tonumber(tick());
	warn("Loading script...")

	if fovCircle then
		function createcircle()
			local a=Drawing.new('Circle');a.Transparency=1;a.Thickness=1.5;a.Visible=true;a.Color=Color3.fromRGB(0,255,149);a.Filled=false;a.Radius=fov;
			return a;
		end;  
		local fovc = createcircle();
		spawn(function()
			RunService:BindToRenderStep("FovCircle",1,function()
				fovc.Position = Vector2.new(mouse.X,mouse.Y)
			end);
		end);
	end;

	function isFfa()
		local am = #Players:GetChildren();
		local amm = 0;
		for i , v in pairs(Players:GetChildren()) do
			if v.Team == LocalPlayer.Team then
				amm = amm + 1;
			end;
		end;
		return am == amm;
	end;
	function getnearest()
		local nearestmagnitude = math.huge
		local nearestenemy = nil
		local vector = nil
		local ffa = isFfa();
		for i,v in next, Players:GetChildren() do
			if ffa == false and v.Team ~= LocalPlayer.Team or ffa == true then
				if v.Character and  v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
					local vector, onScreen = Camera:WorldToScreenPoint(v.Character["HumanoidRootPart"].Position)
					if onScreen then
						local ray = Ray.new(
							Camera.CFrame.p,
							(v.Character["Head"].Position-Camera.CFrame.p).unit*500
						)
						local ignore = {
							LocalPlayer.Character,
						}
						local hit,position,normal=workspace:FindPartOnRayWithIgnoreList(ray,ignore)
						if hit and hit:FindFirstAncestorOfClass("Model") and Players:FindFirstChild(hit:FindFirstAncestorOfClass("Model").Name)then
							local magnitude = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(vector.X, vector.Y)).magnitude
							if magnitude < nearestmagnitude and magnitude <= fov then
								nearestenemy = v
								nearestmagnitude = magnitude
							end
						end
					end
				end
			end
		end
		return nearestenemy
	end


	local meta = getrawmetatable(game)
	setreadonly(meta, false)
	local oldNamecall = meta.__namecall
	meta.__namecall = newcclosure(function(...)

		local method = getnamecallmethod()
		local args = {...}
		if string.find(method,'Ray') then
			if target then
				if args[1].Name ~= "Workspace" then
					print(args[1])
				end;
				args[2] = Ray.new(workspace.CurrentCamera.CFrame.Position, (target.Position + Vector3.new(0,(workspace.CurrentCamera.CFrame.Position-target.Position).Magnitude/500,0) - workspace.CurrentCamera.CFrame.Position).unit * 5000)
			end
		end
		return oldNamecall(unpack(args))
	end)

	warn("Script loaded!\nTime taken: "..math.abs(tonumber(tick())-st))
	RunService:BindToRenderStep("SilentAim",1,function()
		if UserInputService:IsMouseButtonPressed(0) and Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid") and Players.LocalPlayer.Character.Humanoid.Health > 0 then
			local enemy = getnearest()
			if enemy and enemy.Character and enemy.Character:FindFirstChild("Humanoid") and enemy.Character.Humanoid.Health > 0 then                
				local vector, onScreen = Camera:WorldToScreenPoint(enemy.Character["Head"].Position)
				local head = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(vector.X, vector.Y)).magnitude
				local vector, onScreen = Camera:WorldToScreenPoint(enemy.Character["HumanoidRootPart"].Position)
				local hitbox = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(vector.X, vector.Y)).magnitude
				if head <= hitbox then
					magnitude = head
				else
					magnitude = hitbox;
				end;
				if getfenv().lock == "Head" then
					target = workspace[enemy.Name]["Head"]
				else
					if getfenv().lock == "Random" then
						if magnitude == hitbox then
							target = workspace[enemy.Name]["HumanoidRootPart"];
						else
							target = workspace[enemy.Name]["Head"]
						end;
					else
						target = workspace[enemy.Name]["HumanoidRootPart"];
					end;

				end;
			else
				target = nil
			end
		end
	end)
end)

Killall.Name = "Kill all"
Killall.Parent = main
Killall.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Killall.BorderColor3 = Color3.fromRGB(40, 40, 40)
Killall.Position = UDim2.new(0.00999999978, 0, 0.50350225, 0)
Killall.Size = UDim2.new(0, 163, 0, 36)
Killall.Font = Enum.Font.GothamBlack
Killall.Text = "Kill All(E)"
Killall.TextColor3 = Color3.fromRGB(255, 255, 255)
Killall.TextSize = 14.000

Killall.MouseButton1Down:connect(function()
	game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(k)
		if k == "e" then
			local Gun = game.ReplicatedStorage.Weapons:FindFirstChild(game.Players.LocalPlayer.NRPBS.EquippedTool.Value);
			local Crit = math.random() > .6 and true or false;
			for i,v in pairs(game.Players:GetPlayers()) do
				if v and v.Character and v.Character:FindFirstChild("Head") then
					local Distance = (game.Players.LocalPlayer.Character.Head.Position - v.Character.Head.Position).magnitude
					for i  = 1,10 do
						game.ReplicatedStorage.Events.HitPart:FireServer(v.Character.Head,
							v.Character.Head.Position + Vector3.new(math.random(), math.random(), math.random()),
							Gun.Name,
							Crit and 2 or 1,
							Distance,
							Backstab,
							Crit,
							false,
							1,
							false,
							Gun.FireRate.Value,
							Gun.ReloadTime.Value,
							Gun.Ammo.Value,
							Gun.StoredAmmo.Value,
							Gun.Bullets.Value,
							Gun.EquipTime.Value,
							Gun.RecoilControl.Value,
							Gun.Auto.Value,
							Gun['Speed%'].Value,
							game.ReplicatedStorage.wkspc.DistributedTime.Value);
					end
				end
			end
		end
	end)
end)

BoxEsp.Name = "Box Esp"
BoxEsp.Parent = main
BoxEsp.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BoxEsp.BorderColor3 = Color3.fromRGB(40, 40, 40)
BoxEsp.Position = UDim2.new(0.574999988, 0, 0.313304722, 0)
BoxEsp.Size = UDim2.new(0, 162, 0, 36)
BoxEsp.Font = Enum.Font.GothamBlack
BoxEsp.Text = "Box Esp"
BoxEsp.TextColor3 = Color3.fromRGB(255, 255, 255)
BoxEsp.TextSize = 14.000


BoxEsp.MouseButton1Down:connect(function()
	local plr = game.Players.LocalPlayer
	local camera = game.Workspace.CurrentCamera

	for i, v in pairs(game.Players:GetChildren()) do
		local Top = Drawing.new("Line")
		Top.Visible = false
		Top.From = Vector2.new(0, 0)
		Top.To = Vector2.new(200, 200)
		Top.Color = Color3.fromRGB(255, 0, 0)
		Top.Thickness = 2
		Top.Transparency = 1

		local Bottom = Drawing.new("Line")
		Bottom.Visible = false
		Bottom.From = Vector2.new(0, 0)
		Bottom.To = Vector2.new(200, 200)
		Bottom.Color = Color3.fromRGB(255, 0, 0)
		Bottom.Thickness = 2
		Bottom.Transparency = 1

		local Left = Drawing.new("Line")
		Left.Visible = false
		Left.From = Vector2.new(0, 0)
		Left.To = Vector2.new(200, 200)
		Left.Color = Color3.fromRGB(255, 0, 0)
		Left.Thickness = 2
		Left.Transparency = 1

		local Right = Drawing.new("Line")
		Right.Visible = false
		Right.From = Vector2.new(0, 0)
		Right.To = Vector2.new(200, 200)
		Right.Color = Color3.fromRGB(255, 0, 0)
		Right.Thickness = 2
		Right.Transparency = 1

		function ESP()
			local connection
			connection = game:GetService("RunService").RenderStepped:Connect(function()
				if v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v.Name ~= plr.Name  and v.Character.Humanoid.Health > 0 then 
					local ScreenPos, OnScreen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
					if OnScreen then
						local Scale = v.Character.Head.Size.Y/2
						local Size = Vector3.new(2, 3, 0) * (Scale * 2)
						local humpos = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
						local TL = camera:WorldToViewportPoint((v.Character.HumanoidRootPart.CFrame * CFrame.new(Size.X, Size.Y, 0)).p)
						local TR = camera:WorldToViewportPoint((v.Character.HumanoidRootPart.CFrame * CFrame.new(-Size.X, Size.Y, 0)).p)
						local BL = camera:WorldToViewportPoint((v.Character.HumanoidRootPart.CFrame * CFrame.new(Size.X, -Size.Y, 0)).p)
						local BR = camera:WorldToViewportPoint((v.Character.HumanoidRootPart.CFrame * CFrame.new(-Size.X, -Size.Y, 0)).p)

						Top.From = Vector2.new(TL.X, TL.Y)
						Top.To = Vector2.new(TR.X, TR.Y)

						Left.From = Vector2.new(TL.X, TL.Y)
						Left.To = Vector2.new(BL.X, BL.Y)

						Right.From = Vector2.new(TR.X, TR.Y)
						Right.To = Vector2.new(BR.X, BR.Y)

						Bottom.From = Vector2.new(BL.X, BL.Y)
						Bottom.To = Vector2.new(BR.X, BR.Y)

						if v.TeamColor == plr.TeamColor then
							Top.Color = Color3.fromRGB(0, 255, 0)
							Left.Color = Color3.fromRGB(0, 255, 0)
							Bottom.Color = Color3.fromRGB(0, 255, 0)
							Right.Color = Color3.fromRGB(0, 255, 0)
						else 
							Top.Color = Color3.fromRGB(255, 0, 0)
							Left.Color = Color3.fromRGB(255, 0, 0)
							Bottom.Color = Color3.fromRGB(255, 0, 0)
							Right.Color = Color3.fromRGB(255, 0, 0)
						end

						Top.Visible = true
						Left.Visible = true
						Bottom.Visible = true
						Right.Visible = true
					else 
						Top.Visible = false
						Left.Visible = false
						Bottom.Visible = false
						Right.Visible = false
					end
				else 
					Top.Visible = false
					Left.Visible = false
					Bottom.Visible = false
					Right.Visible = false
					if game.Players:FindFirstChild(v.Name) == nil then
						connection:Disconnect()
					end
				end
			end)
		end
		coroutine.wrap(ESP)()
	end

	game.Players.PlayerAdded:Connect(function(newplr) --Parameter gets the new player that has been added
		local Top = Drawing.new("Line")
		Top.Visible = false
		Top.From = Vector2.new(0, 0)
		Top.To = Vector2.new(200, 200)
		Top.Color = Color3.fromRGB(255, 0, 0)
		Top.Thickness = 2
		Top.Transparency = 1

		local Bottom = Drawing.new("Line")
		Bottom.Visible = false
		Bottom.From = Vector2.new(0, 0)
		Bottom.To = Vector2.new(200, 200)
		Bottom.Color = Color3.fromRGB(255, 0, 0)
		Bottom.Thickness = 2
		Bottom.Transparency = 1

		local Left = Drawing.new("Line")
		Left.Visible = false
		Left.From = Vector2.new(0, 0)
		Left.To = Vector2.new(200, 200)
		Left.Color = Color3.fromRGB(255, 0, 0)
		Left.Thickness = 2
		Left.Transparency = 1

		local Right = Drawing.new("Line")
		Right.Visible = false
		Right.From = Vector2.new(0, 0)
		Right.To = Vector2.new(200, 200)
		Right.Color = Color3.fromRGB(255, 0, 0)
		Right.Thickness = 2
		Right.Transparency = 1

		function ESP()
			local connection
			connection = game:GetService("RunService").RenderStepped:Connect(function()
				if newplr.Character ~= nil and newplr.Character:FindFirstChild("HumanoidRootPart") ~= nil and newplr.Name ~= plr.Name  and newplr.Character.Humanoid.Health > 0 then
					local ScreenPos, OnScreen = camera:WorldToViewportPoint(newplr.Character.HumanoidRootPart.Position)
					if OnScreen then
						local Scale = newplr.Character.Head.Size.Y/2
						local Size = Vector3.new(2, 3, 0) * (Scale * 2)
						local humpos = camera:WorldToViewportPoint(newplr.Character.HumanoidRootPart.Position)
						local TL = camera:WorldToViewportPoint((newplr.Character.HumanoidRootPart.CFrame * CFrame.new(Size.X, Size.Y, 0)).p)
						local TR = camera:WorldToViewportPoint((newplr.Character.HumanoidRootPart.CFrame * CFrame.new(-Size.X, Size.Y, 0)).p)
						local BL = camera:WorldToViewportPoint((newplr.Character.HumanoidRootPart.CFrame * CFrame.new(Size.X, -Size.Y, 0)).p)
						local BR = camera:WorldToViewportPoint((newplr.Character.HumanoidRootPart.CFrame * CFrame.new(-Size.X, -Size.Y, 0)).p)

						Top.From = Vector2.new(TL.X, TL.Y)
						Top.To = Vector2.new(TR.X, TR.Y)

						Left.From = Vector2.new(TL.X, TL.Y)
						Left.To = Vector2.new(BL.X, BL.Y)

						Right.From = Vector2.new(TR.X, TR.Y)
						Right.To = Vector2.new(BR.X, BR.Y)

						Bottom.From = Vector2.new(BL.X, BL.Y)
						Bottom.To = Vector2.new(BR.X, BR.Y)

						if newplr.TeamColor == plr.TeamColor then
							Top.Color = Color3.fromRGB(0, 255, 0)
							Left.Color = Color3.fromRGB(0, 255, 0)
							Bottom.Color = Color3.fromRGB(0, 255, 0)
							Right.Color = Color3.fromRGB(0, 255, 0)
						else 
							Top.Color = Color3.fromRGB(255, 0, 0)
							Left.Color = Color3.fromRGB(255, 0, 0)
							Bottom.Color = Color3.fromRGB(255, 0, 0)
							Right.Color = Color3.fromRGB(255, 0, 0)
						end

						Top.Visible = true
						Left.Visible = true
						Bottom.Visible = true
						Right.Visible = true
					else 
						Top.Visible = false
						Left.Visible = false
						Bottom.Visible = false
						Right.Visible = false
					end
				else 
					Top.Visible = false
					Left.Visible = false
					Bottom.Visible = false
					Right.Visible = false
					if game.Players:FindFirstChild(newplr.Name) == nil then
						connection:Disconnect()
					end
				end
			end)
		end
		coroutine.wrap(ESP)()
	end)
end)

Visualslabel.Name = "Visuals label"
Visualslabel.Parent = main
Visualslabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Visualslabel.BorderColor3 = Color3.fromRGB(30, 30, 30)
Visualslabel.Position = UDim2.new(0.574999988, 0, 0.164153501, 0)
Visualslabel.Size = UDim2.new(0, 163, 0, 33)
Visualslabel.Font = Enum.Font.GothamBlack
Visualslabel.Text = "Visual"
Visualslabel.TextColor3 = Color3.fromRGB(255, 255, 255)
Visualslabel.TextSize = 14.000

Tracers.Name = "Tracers"
Tracers.Parent = main
Tracers.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Tracers.BorderColor3 = Color3.fromRGB(40, 40, 40)
Tracers.Position = UDim2.new(0.57249999, 0, 0.50350219, 0)
Tracers.Size = UDim2.new(0, 162, 0, 36)
Tracers.Font = Enum.Font.GothamBlack
Tracers.Text = "Tracers"
Tracers.TextColor3 = Color3.fromRGB(255, 255, 255)
Tracers.TextSize = 14.000

Tracers.MouseButton1Down:connect(function()
	local plr = game.Players.LocalPlayer
	local camera = game.Workspace.CurrentCamera

	for i, v in pairs(game.Players:GetChildren()) do
		local TEXT = Drawing.new("Text")
		TEXT.Visible = false
		TEXT.Transparency = 1
		TEXT.Color = Color3.fromRGB(255, 0, 0)
		TEXT.Text = v.Name
		TEXT.Size = 15
		TEXT.Position = Vector2.new(200,200)

		local TRACER = Drawing.new("Line")
		TRACER.Visible = false
		TRACER.From = Vector2.new(0, 0)
		TRACER.To = Vector2.new(200, 200)
		TRACER.Color = Color3.fromRGB(255, 0, 0)
		TRACER.Thickness = 2
		TRACER.Transparency = 1

		function ESP()
			game:GetService("RunService").RenderStepped:Connect(function()
				if v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v.Name ~= plr.Name  and v.Character.Humanoid.Health > 0 then 
					local ScreenPos, OnScreen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
					if OnScreen then
						TRACER.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
						TRACER.To = Vector2.new(ScreenPos.X, ScreenPos.Y)
						TEXT.Position = Vector2.new(ScreenPos.X- 20, ScreenPos.Y)

						if v.TeamColor == plr.TeamColor then
							TRACER.Color = Color3.fromRGB(0, 255, 0)
							TEXT.Color = Color3.fromRGB(0, 255, 0)
						else 
							TRACER.Color = Color3.fromRGB(255, 0, 0)
							TEXT.Color = Color3.fromRGB(255, 0, 0)
						end

						TRACER.Visible = true
						TEXT.Visible = false
					else 
						TRACER.Visible = false
						TEXT.Visible = false
					end
				else 
					TRACER.Visible = false
					TEXT.Visible = false
					if game.Players:FindFirstChild(v.Name) then
					else
						Disconnect()
					end
				end
			end)
		end
		coroutine.wrap(ESP)()
	end

	game.Players.PlayerAdded:Connect(function(newplr)
		local TEXT = Drawing.new("Text")
		TEXT.Visible = false
		TEXT.Transparency = 1
		TEXT.Color = Color3.fromRGB(255, 0, 0)
		TEXT.Text = newplr.Name
		TEXT.Size = 15
		TEXT.Position = Vector2.new(200,200)

		local TRACER = Drawing.new("Line")
		TRACER.Visible = false
		TRACER.From = Vector2.new(0, 0)
		TRACER.To = Vector2.new(200, 200)
		TRACER.Color = Color3.fromRGB(255, 0, 0)
		TRACER.Thickness = 2
		TRACER.Transparency = 1

		function ESP()
			game:GetService("RunService").RenderStepped:Connect(function()
				if newplr.Character ~= nil and newplr.Character:FindFirstChild("HumanoidRootPart") ~= nil and newplr.Name ~= plr.Name  and newplr.Character.Humanoid.Health > 0 then
					local ScreenPos, OnScreen = camera:WorldToViewportPoint(newplr.Character.HumanoidRootPart.Position)
					if OnScreen then
						TRACER.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y) -- Gets bottom center of screen for tracers
						TRACER.To = Vector2.new(ScreenPos.X, ScreenPos.Y)
						TEXT.Position = Vector2.new(ScreenPos.X - 20, ScreenPos.Y)

						if newplr.TeamColor == plr.TeamColor then
							TRACER.Color = Color3.fromRGB(0, 255, 0)
							TEXT.Color = Color3.fromRGB(0, 255, 0)
						else 
							TRACER.Color = Color3.fromRGB(255, 0, 0)
							TEXT.Color = Color3.fromRGB(255, 0, 0)
						end

						TRACER.Visible = true
						TEXT.Visible = false
					else 
						TRACER.Visible = false
						TEXT.Visible = false
					end
				else 
					TRACER.Visible = false
					TEXT.Visible = false
					if game.Players:FindFirstChild(newplr.Name) then
					else
						Disconnect()
					end
				end
			end)
		end
		coroutine.wrap(ESP)()
	end)
end)

Wallbang.Name = "Wallbang"
Wallbang.Parent = main
Wallbang.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Wallbang.BorderColor3 = Color3.fromRGB(40, 40, 40)
Wallbang.Position = UDim2.new(0.00999999978, 0, 0.691914856, 0)
Wallbang.Size = UDim2.new(0, 163, 0, 36)
Wallbang.Font = Enum.Font.GothamBlack
Wallbang.Text = "WallBang(T)"
Wallbang.TextColor3 = Color3.fromRGB(255, 255, 255)
Wallbang.TextSize = 14.000

Wallbang.MouseButton1Down:connect(function()
	_G.Enable = true
	local MT = getrawmetatable(game)
	local OldIndex = MT.__index
	setreadonly(MT, false)
	MT.__index = newcclosure(function(A, B)
		if B == "Clips" then
			if _G.Enable then
				return workspace.Map
			end
		end
		return OldIndex(A, B)
	end)
	game:GetService("UserInputService").InputBegan:Connect(function(Key, _)
		if not _ and Key.KeyCode == Enum.KeyCode.T then
			_G.Enable = not _G.Enable
		end
	end)
end)

GunMod.Name = "Gun Mod"
GunMod.Parent = main
GunMod.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GunMod.BorderColor3 = Color3.fromRGB(40, 40, 40)
GunMod.Position = UDim2.new(0.57249999, 0, 0.691915035, 0)
GunMod.Size = UDim2.new(0, 162, 0, 36)
GunMod.Font = Enum.Font.GothamBlack
GunMod.Text = "Gun Mod"
GunMod.TextColor3 = Color3.fromRGB(255, 255, 255)
GunMod.TextSize = 14.000

GunMod.MouseButton1Down:connect(function()
	local env = getsenv(game.Players.LocalPlayer.PlayerGui.GUI.Client)


	while wait() do
		env.ammocount = 445
		env.ammocount2 = 445
		env.ammocount4 = 455
		env.ammocount4 = 455
		env.currentspread = 0
		env.recoil = 0
		env.mode = "automatic"
		env.inducefalldamage = function(...) return nil end
	end
end)
