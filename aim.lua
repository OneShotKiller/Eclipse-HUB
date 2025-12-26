-- AIM JAILBREAK | AIMLOCK + ALLUSIVE STYLE GUI (FINAL FIX)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

local LP = Players.LocalPlayer

-- ================= SETTINGS =================
local AIM_ON = false
local AIM_KEY = Enum.KeyCode.X
local GUI_KEY = Enum.KeyCode.RightShift
local PREDICTION = 0.08
local lockedPlayer = nil
local GUI_VISIBLE = true
local waitingForKey = false

-- ================= ENEMY CHECK =================
local function isEnemy(p)
	return p.Team and LP.Team and p.Team ~= LP.Team
end

-- ================= GET TARGET =================
local function getPlayerUnderCrosshair()
	local mousePos = UserInputService:GetMouseLocation()
	local nearest, shortest
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LP and isEnemy(p)
			and p.Character
			and p.Character:FindFirstChild("Head")
			and p.Character:FindFirstChild("HumanoidRootPart")
			and p.Character:FindFirstChild("Humanoid")
			and p.Character.Humanoid.Health > 0 then

			local pos, onscreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
			if onscreen then
				local dist = (Vector2.new(pos.X,pos.Y)-mousePos).Magnitude
				if not shortest or dist < shortest then
					shortest = dist
					nearest = p
				end
			end
		end
	end
	return nearest
end

-- ================= INPUT =================
UserInputService.InputBegan:Connect(function(i,gp)
	if gp then return end

	if waitingForKey and i.UserInputType == Enum.UserInputType.Keyboard then
		GUI_KEY = i.KeyCode
		waitingForKey = false
		return
	end

	if i.KeyCode == AIM_KEY then
		if not AIM_ON then
			lockedPlayer = getPlayerUnderCrosshair()
		end
		AIM_ON = not AIM_ON
	end

	if i.KeyCode == GUI_KEY then
		GUI_VISIBLE = not GUI_VISIBLE
	end
end)

-- ================= AIM =================
RunService.RenderStepped:Connect(function()
	if AIM_ON and lockedPlayer and lockedPlayer.Character then
		local h = lockedPlayer.Character:FindFirstChild("Head")
		local hrp = lockedPlayer.Character:FindFirstChild("HumanoidRootPart")
		local hum = lockedPlayer.Character:FindFirstChild("Humanoid")

		if h and hrp and hum and hum.Health > 0 and isEnemy(lockedPlayer) then
			Camera.CFrame = CFrame.new(
				Camera.CFrame.Position,
				h.Position + hrp.Velocity * PREDICTION
			)
		end
	end
end)

-- ================= NOTIFICATION =================
local function notify(txt)
	local g = Instance.new("ScreenGui",game.CoreGui)
	g.IgnoreGuiInset = true

	local f = Instance.new("Frame",g)
	f.Size = UDim2.new(0,260,0,70)
	f.Position = UDim2.new(1,-280,1,-90)
	f.BackgroundColor3 = Color3.fromRGB(35,35,35)
	f.BackgroundTransparency = 1
	f.BorderSizePixel = 0
	Instance.new("UICorner",f).CornerRadius = UDim.new(0,12)

	local t = Instance.new("TextLabel",f)
	t.Size = UDim2.new(1,0,1,0)
	t.BackgroundTransparency = 1
	t.Text = "Eclipse HUB\n"..txt
	t.Font = Enum.Font.Gotham
	t.TextSize = 14
	t.TextColor3 = Color3.new(1,1,1)
	t.TextTransparency = 1

	TweenService:Create(f,TweenInfo.new(.4),{BackgroundTransparency=.1}):Play()
	TweenService:Create(t,TweenInfo.new(.4),{TextTransparency=0}):Play()

	task.delay(5,function()
		TweenService:Create(f,TweenInfo.new(.3),{BackgroundTransparency=1}):Play()
		TweenService:Create(t,TweenInfo.new(.3),{TextTransparency=1}):Play()
		task.delay(.4,function()
			g:Destroy()
		end)
	end)
end

notify("Please wait 5 seconds...")
task.wait(5)

-- ================= GUI =================
local gui = Instance.new("ScreenGui",game.CoreGui)
gui.IgnoreGuiInset = true

local board = Instance.new("Frame",gui)
board.Size = UDim2.new(0,340,0,150)
board.Position = UDim2.new(.5,-170,.56,-75)
board.BackgroundColor3 = Color3.fromRGB(30,30,30)
board.BackgroundTransparency = 1
board.BorderSizePixel = 0
board.Visible = false

Instance.new("UICorner",board).CornerRadius = UDim.new(0,14)

local stroke = Instance.new("UIStroke",board)
stroke.Color = Color3.fromRGB(90,180,255)
stroke.Transparency = 1

local title = Instance.new("TextLabel",board)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Eclipse HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(90,180,255)
title.BackgroundTransparency = 1
title.TextTransparency = 1

local status = Instance.new("TextLabel",board)
status.Position = UDim2.new(0,0,0,40)
status.Size = UDim2.new(1,0,0,25)
status.Font = Enum.Font.Gotham
status.TextSize = 16
status.BackgroundTransparency = 1
status.TextTransparency = 1

local keybtn = Instance.new("TextButton",board)
keybtn.Position = UDim2.new(0.1,0,0.65,0)
keybtn.Size = UDim2.new(0.8,0,0,30)
keybtn.Text = "GUI KEY : "..GUI_KEY.Name
keybtn.Font = Enum.Font.Gotham
keybtn.TextSize = 14
keybtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
keybtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",keybtn)

keybtn.MouseButton1Click:Connect(function()
	waitingForKey = true
end)

-- ================= GUI ANIMATION =================
local guiTween

local function showGUI()
	if guiTween then guiTween:Cancel() end
	board.Visible = true
	board.Position = UDim2.new(.5,-170,.53,-75)

	guiTween = TweenService:Create(
		board,
		TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{
			BackgroundTransparency = 0.15,
			Position = UDim2.new(.5,-170,.5,-75)
		}
	)
	guiTween:Play()

	TweenService:Create(title,TweenInfo.new(.35),{TextTransparency=0}):Play()
	TweenService:Create(status,TweenInfo.new(.35),{TextTransparency=0}):Play()
	TweenService:Create(stroke,TweenInfo.new(.35),{Transparency=0}):Play()
end

local function hideGUI()
	if guiTween then guiTween:Cancel() end

	guiTween = TweenService:Create(
		board,
		TweenInfo.new(0.18, Enum.EasingStyle.Linear),
		{
			BackgroundTransparency = 1,
			Position = UDim2.new(.5,-170,.56,-75)
		}
	)
	guiTween:Play()

	TweenService:Create(title,TweenInfo.new(.15),{TextTransparency=1}):Play()
	TweenService:Create(status,TweenInfo.new(.15),{TextTransparency=1}):Play()
	TweenService:Create(stroke,TweenInfo.new(.15),{Transparency=1}):Play()

	task.delay(0.18,function()
		board.Visible = false
	end)
end

-- ================= UPDATE =================
RunService.RenderStepped:Connect(function()
	if GUI_VISIBLE then
		if not board.Visible then showGUI() end
	else
		if board.Visible then hideGUI() end
	end

	status.Text = AIM_ON and "AIMLOCK : ON ["..AIM_KEY.Name.."]"
		or "AIMLOCK : OFF ["..AIM_KEY.Name.."]"
	status.TextColor3 = AIM_ON and Color3.fromRGB(80,255,120)
		or Color3.fromRGB(255,80,80)

	keybtn.Text = waitingForKey and "PRESS ANY KEY..."
		or ("GUI KEY : "..GUI_KEY.Name)
end)

print("Eclipse HUB loaded ✅")
