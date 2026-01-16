--// ZHENIT UI LIBRARY v2.0 VISUAL UPGRADE

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Zhenit = {
	Version = "2.0",
	Windows = {},
	Themes = {
		Default = {
			Bg = Color3.fromRGB(16,16,22),
			Card = Color3.fromRGB(28,28,38),
			Stroke = Color3.fromRGB(45,45,60),
			Text = Color3.fromRGB(235,235,235),
			SubText = Color3.fromRGB(160,160,170),
			Accent = Color3.fromRGB(130,95,255)
		}
	},
	SelectedTheme = "Default",
	Icons = {
		home = "rbxassetid://10723407389",
		settings = "rbxassetid://10723407744",
		user = "rbxassetid://10723407193",
		play = "rbxassetid://10723406988",
		shield = "rbxassetid://10723406625",
		star = "rbxassetid://10723406447",
		bolt = "rbxassetid://10723406063",
		search = "rbxassetid://10723407542",
		key = "rbxassetid://10723406788"
	}
}

--// ================= UTIL =================

function Zhenit:GetTheme()
	return self.Themes[self.SelectedTheme]
end

function Zhenit:GetIcon(icon)
	if typeof(icon) == "string" then
		return self.Icons[string.lower(icon)]
	end
	return icon
end

local function Tween(obj,time,props,style)
	TweenService:Create(obj,TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quint),props):Play()
end

local function ApplyShadow(frame)
	local shadow = Instance.new("ImageLabel", frame)
	shadow.AnchorPoint = Vector2.new(0.5,0.5)
	shadow.Position = UDim2.fromScale(0.5,0.5)
	shadow.Size = UDim2.new(1,40,1,40)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://1316045217"
	shadow.ImageTransparency = 0.85
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(10,10,118,118)
	shadow.ZIndex = frame.ZIndex - 1
end

local function ApplyButtonFX(btn)
	local scale = Instance.new("UIScale", btn)

	btn.MouseEnter:Connect(function()
		Tween(scale,0.15,{Scale = 1.03})
	end)
	btn.MouseLeave:Connect(function()
		Tween(scale,0.15,{Scale = 1})
	end)
	btn.MouseButton1Down:Connect(function()
		Tween(scale,0.08,{Scale = 0.96})
	end)
	btn.MouseButton1Up:Connect(function()
		Tween(scale,0.1,{Scale = 1.03})
	end)
end

--// ================= WINDOW =================

function Zhenit:MakeWindow(cfg)
	cfg = cfg or {}
	local title = cfg.Name or "Zhenit"
	local logo = cfg.Logo
	local theme = self:GetTheme()

	local gui = Instance.new("ScreenGui")
	gui.Parent = LocalPlayer.PlayerGui
	gui.ResetOnSpawn = false

	local main = Instance.new("Frame", gui)
	main.Size = UDim2.fromOffset(620,420)
	main.Position = UDim2.fromScale(0.5,0.5)
	main.AnchorPoint = Vector2.new(0.5,0.5)
	main.BackgroundColor3 = theme.Bg
	main.BorderSizePixel = 0
	main.ZIndex = 2
	Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)
	ApplyShadow(main)

	local stroke = Instance.new("UIStroke", main)
	stroke.Color = theme.Stroke
	stroke.Thickness = 1

	-- Drag
	do
		local dragging, dragStart, startPos
		main.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = i.Position
				startPos = main.Position
			end
		end)
		UIS.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)
		UIS.InputChanged:Connect(function(i)
			if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = i.Position - dragStart
				main.Position = startPos + UDim2.fromOffset(delta.X, delta.Y)
			end
		end)
	end

	-- Topbar
	local top = Instance.new("Frame", main)
	top.Size = UDim2.new(1,0,0,54)
	top.BackgroundTransparency = 1

	if logo then
		local img = Instance.new("ImageLabel", top)
		img.Size = UDim2.fromOffset(34,34)
		img.Position = UDim2.fromOffset(14,10)
		img.BackgroundTransparency = 1
		img.Image = self:GetIcon(logo) or logo
	end

	local titleLbl = Instance.new("TextLabel", top)
	titleLbl.Position = UDim2.fromOffset(60,0)
	titleLbl.Size = UDim2.new(1,-120,1,0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title
	titleLbl.TextColor3 = theme.Text
	titleLbl.TextXAlignment = Left
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 17

	-- Minimize
	local mini = Instance.new("TextButton", top)
	mini.Size = UDim2.fromOffset(42,30)
	mini.Position = UDim2.new(1,-52,0,12)
	mini.Text = "–"
	mini.Font = Enum.Font.GothamBold
	mini.TextSize = 20
	mini.BackgroundColor3 = theme.Card
	mini.TextColor3 = theme.Text
	mini.BorderSizePixel = 0
	Instance.new("UICorner", mini).CornerRadius = UDim.new(0,10)
	ApplyButtonFX(mini)

	-- Sidebar
	local tabBar = Instance.new("Frame", main)
	tabBar.Position = UDim2.fromOffset(12,64)
	tabBar.Size = UDim2.fromOffset(150,330)
	tabBar.BackgroundColor3 = theme.Card
	tabBar.BorderSizePixel = 0
	Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0,14)

	local tabLayout = Instance.new("UIListLayout", tabBar)
	tabLayout.Padding = UDim.new(0,8)

	-- Content
	local content = Instance.new("ScrollingFrame", main)
	content.Position = UDim2.fromOffset(178,64)
	content.Size = UDim2.fromOffset(430,330)
	content.CanvasSize = UDim2.new(0,0,0,0)
	content.ScrollBarImageTransparency = 0.4
	content.BackgroundTransparency = 1

	local minimized = false
	mini.MouseButton1Click:Connect(function()
		minimized = not minimized
		Tween(main,0.25,{
			Size = minimized and UDim2.fromOffset(620,54) or UDim2.fromOffset(620,420)
		})
		tabBar.Visible = not minimized
		content.Visible = not minimized
	end)

	local Window = {Tabs = {}}

	-- ================= TAB =================

	function Window:MakeTab(cfg)
		cfg = cfg or {}
		local name = cfg.Name or "Tab"
		local icon = Zhenit:GetIcon(cfg.Icon)

		local btn = Instance.new("TextButton", tabBar)
		btn.Size = UDim2.fromOffset(134,42)
		btn.Text = ""
		btn.BackgroundColor3 = theme.Bg
		btn.BorderSizePixel = 0
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)
		ApplyButtonFX(btn)

		local indicator = Instance.new("Frame", btn)
		indicator.Size = UDim2.fromOffset(4,0)
		indicator.Position = UDim2.new(0,0,0.5,0)
		indicator.AnchorPoint = Vector2.new(0,0.5)
		indicator.BackgroundColor3 = theme.Accent
		indicator.BorderSizePixel = 0
		indicator.Visible = false
		Instance.new("UICorner", indicator).CornerRadius = UDim.new(1,0)

		local label = Instance.new("TextLabel", btn)
		label.Size = UDim2.new(1,-40,1,0)
		label.Position = UDim2.fromOffset(38,0)
		label.BackgroundTransparency = 1
		label.Text = name
		label.TextColor3 = theme.SubText
		label.TextXAlignment = Left
		label.Font = Enum.Font.Gotham
		label.TextSize = 13

		if icon then
			local ico = Instance.new("ImageLabel", btn)
			ico.Size = UDim2.fromOffset(22,22)
			ico.Position = UDim2.fromOffset(10,10)
			ico.BackgroundTransparency = 1
			ico.Image = icon
		end

		local page = Instance.new("Frame", content)
		page.Size = UDim2.fromScale(1,1)
		page.Visible = false
		page.BackgroundTransparency = 1

		local layout = Instance.new("UIListLayout", page)
		layout.Padding = UDim.new(0,10)

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			content.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 20)
		end)

		local Tab = {Page = page}

		function Tab:Show()
			for _,t in pairs(Window.Tabs) do
				t.Page.Visible = false
				if t.Button then
					t.Button.BackgroundColor3 = theme.Bg
					t.Button.Label.TextColor3 = theme.SubText
					t.Button.Indicator.Visible = false
				end
			end
			page.Visible = true
			btn.BackgroundColor3 = theme.Card
			label.TextColor3 = theme.Text
			indicator.Visible = true
			Tween(indicator,0.25,{Size = UDim2.fromOffset(4,28)})
		end

		btn.MouseButton1Click:Connect(Tab.Show)

		Tab.Button = btn
		btn.Label = label
		btn.Indicator = indicator

		-- ================= ELEMENTS =================

		function Tab:AddLabel(text)
			local lbl = Instance.new("TextLabel", page)
			lbl.Size = UDim2.fromOffset(410,28)
			lbl.BackgroundTransparency = 1
			lbl.Text = text or "Label"
			lbl.TextColor3 = theme.Text
			lbl.Font = Enum.Font.GothamBold
			lbl.TextSize = 14
			lbl.TextXAlignment = Left
		end

		function Tab:AddDivider()
			local line = Instance.new("Frame", page)
			line.Size = UDim2.fromOffset(410,1)
			line.BackgroundColor3 = theme.Stroke
			line.BorderSizePixel = 0
		end

		function Tab:AddButton(cfg)
			local b = Instance.new("TextButton", page)
			b.Size = UDim2.fromOffset(410,42)
			b.Text = cfg.Name or "Button"
			b.BackgroundColor3 = theme.Card
			b.TextColor3 = theme.Text
			b.BorderSizePixel = 0
			b.Font = Enum.Font.Gotham
			b.TextSize = 14
			Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
			ApplyButtonFX(b)

			b.MouseButton1Click:Connect(function()
				if cfg.Callback then
					task.spawn(cfg.Callback)
				end
			end)
		end

		function Tab:AddToggle(cfg)
			local state = cfg.Default or false

			local b = Instance.new("TextButton", page)
			b.Size = UDim2.fromOffset(410,42)
			b.BackgroundColor3 = theme.Card
			b.BorderSizePixel = 0
			b.Text = ""
			Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
			ApplyButtonFX(b)

			local txt = Instance.new("TextLabel", b)
			txt.Size = UDim2.new(1,-70,1,0)
			txt.Position = UDim2.fromOffset(14,0)
			txt.BackgroundTransparency = 1
			txt.TextXAlignment = Left
			txt.Text = cfg.Name or "Toggle"
			txt.TextColor3 = theme.Text
			txt.Font = Enum.Font.Gotham
			txt.TextSize = 14

			local toggle = Instance.new("Frame", b)
			toggle.Size = UDim2.fromOffset(42,22)
			toggle.Position = UDim2.new(1,-56,0.5,-11)
			toggle.BackgroundColor3 = theme.Bg
			Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

			local knob = Instance.new("Frame", toggle)
			knob.Size = UDim2.fromOffset(18,18)
			knob.Position = UDim2.fromOffset(2,2)
			knob.BackgroundColor3 = theme.SubText
			Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

			local function Refresh()
				Tween(knob,0.2,{
					Position = state and UDim2.fromOffset(22,2) or UDim2.fromOffset(2,2),
					BackgroundColor3 = state and theme.Accent or theme.SubText
				})
			end

			Refresh()

			b.MouseButton1Click:Connect(function()
				state = not state
				Refresh()
				if cfg.Callback then
					cfg.Callback(state)
				end
			end)
		end

		table.insert(Window.Tabs, Tab)
		if #Window.Tabs == 1 then
			Tab:Show()
		end

		return Tab
	end

	table.insert(self.Windows, Window)
	return Window
end

return Zhenit
