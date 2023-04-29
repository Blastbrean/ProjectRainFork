local library = {};
library.flags = {};
library.items = {};
library.openkey = Enum.KeyCode.RightControl;
local oldframepos = {}
local uis = game:GetService("UserInputService");
local ts = game:GetService("TweenService");
local mouse = game:GetService("Players").LocalPlayer:GetMouse();
function dragify(Frame)
	local dragToggle,dragInput,dragStart,dragPos,startPos
	Frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragToggle = true
			dragStart = input.Position
			startPos = Frame.Position
			input.Changed:Connect(function()
				if (input.UserInputState == Enum.UserInputState.End) then
					dragToggle = false
				end
			end)
		end
	end)
	Frame.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			dragInput = input
		end
	end)
	uis.InputChanged:Connect(function(input)
		if (input == dragInput and dragToggle) then
			local Delta = input.Position - dragStart
			local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
			ts:Create(Frame, TweenInfo.new(.25), {Position = Position}):Play()
			oldframepos[Frame] = Position
		end
	end)
end
function library:CreateWindow()
	local window = {}
	local uilibtwooo = Instance.new("ScreenGui")
	local Categorys = Instance.new("Folder")
	local categoryindex = 0;
	uilibtwooo.Name = "ui lib twooo"
    if syn then
        syn.protect_gui(uilibtwooo);
    end
	uilibtwooo.Parent = gethui and gethui() or game:GetService("CoreGui");
	uilibtwooo.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    uis.InputBegan:Connect(function(input,t)
        pcall(function()
            if input.KeyCode == library.openkey then
                 uilibtwooo.Enabled = not uilibtwooo.Enabled;
            end
        end)
    end)
	Categorys.Name = "Categorys"
	Categorys.Parent = uilibtwooo
	local KeybindsTabScrollingFrame = nil;
	function window:CreateTab(name)
		local tab = {};
		local Frame = Instance.new("Frame")
		local ScrollingFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local UIPadding = Instance.new("UIPadding")
		local TextLabel = Instance.new("TextLabel")
		categoryindex += 1;
		Frame.Parent = Categorys
		Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		Frame.BorderSizePixel = 0
		Frame.Position = UDim2.new(0.0576158948 + categoryindex/8, 0, 0.165087953, 0)
		Frame.Size = UDim2.new(0, 175, 0, 40)
		Frame.ZIndex = 25
		Frame.Position = Frame.Position + UDim2.new(0,0,0.05,0);
		if name == "Keybinds" then
			KeybindsTabScrollingFrame = ScrollingFrame;
		end
		ScrollingFrame.Parent = Frame
		ScrollingFrame.Active = true
		ScrollingFrame.Visible = false;
		ScrollingFrame.BackgroundColor3 = Color3.fromRGB(61, 61, 61)
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.Position = UDim2.new(0, 0, 1, 0)
		ScrollingFrame.Size = UDim2.new(0, 175, 0, 400)

		UIListLayout.Parent = ScrollingFrame
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 7)

		UIPadding.Parent = ScrollingFrame
		UIPadding.PaddingTop = UDim.new(0, 5)

		TextLabel.Parent = Frame
		TextLabel.Text = name;
		TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.Size = UDim2.new(0, 175, 0, 40)
		TextLabel.Font = Enum.Font.Code
		TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.TextSize = 20.000
		Frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton2 then
				ScrollingFrame.Visible = not ScrollingFrame.Visible;
			end
		end)
		Frame.Active = true;
		Frame.Draggable = true;

		function tab:CreateToggle(name,default,callback,flag)
			local value = default;
			local toggle = {};
			flag = flag or name;
			callback = callback or function(val) end;
			library.flags[flag] = default;
			function toggle:GetValue()
				return value;
			end



			local Toggle = Instance.new("TextLabel")
			local Frame = Instance.new("Frame")

			--Properties:

			Toggle.Name = "Toggle"
			Toggle.Parent = ScrollingFrame
			Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Toggle.BackgroundTransparency = 1.000
			Toggle.Position = UDim2.new(0.128571436, 0, 0.202500001, 0)
			Toggle.Size = UDim2.new(0, 130, 0, 23)
			Toggle.Font = Enum.Font.Code
			Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
			Toggle.TextSize = 15.000
            if not Toggle.TextFits then
                while not Toggle.TextFits do
                    Toggle.TextSize = Toggle.TextSize - 2;
                    task.wait()
                end
            end
			Toggle.TextScaled = false;
			Toggle.TextWrapped = true
			Toggle.Text = name;

			Frame.Parent = Toggle
			Frame.BackgroundColor3 = Color3.fromRGB(69,130,161)
			Frame.BorderSizePixel = 0
			Frame.Position = UDim2.new(0.923978865, 0, -0.0274999999, 0)
			Frame.Size = UDim2.new(0, 25, 0, 25)

			function toggle:Set(bool)
				pcall(callback,bool);
				library.flags[flag] = bool;
				value = bool;
				if bool then
					Frame.BackgroundColor3 = Color3.fromRGB(69,130,161)
				else
					Frame.BackgroundColor3 = Color3.fromRGB(60,60,60)
				end
			end
            toggle:Set(default);
			Frame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					toggle:Set(not value);
				end
			end)
			Toggle.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					toggle:Set(not value);
				end
			end)
			function toggle:CreateKeypicker(name,default,callback,flag)

				local KeyPicker = Instance.new("TextLabel")
				KeyPicker.Name = "KeyPicker"
				KeyPicker.Parent = KeybindsTabScrollingFrame;
				KeyPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				KeyPicker.BackgroundTransparency = 1.000
				KeyPicker.Position = UDim2.new(0.128571436, 0, 0.202500001, 0)
				KeyPicker.Size = UDim2.new(0, 130, 0, 23)
				KeyPicker.Font = Enum.Font.Code
				KeyPicker.TextColor3 = Color3.fromRGB(255, 255, 255)
				KeyPicker.TextSize = 20.000
				KeyPicker.TextWrapped = true
				local value = default;
				local keypicker = {};
				flag = flag or name;
				callback = callback or function(val) end;
				library.flags[flag] = default;
				function keypicker:GetValue()
					return value;
				end
				function keypicker:Set(key)
					pcall(function()
						if key ~= Enum.KeyCode.Unknown then
							KeyPicker.Text = string.format("%s [%s]",name,string.split(tostring(key),"Enum.KeyCode.")[2]);
						else
							KeyPicker.Text = string.format("%s [None]",name);
						end
					end)
					pcall(callback,key);
					library.flags[flag] = key;
					value = key;
				end
				KeyPicker.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						KeyPicker.Text = "[...]";
						task.wait(5)
						if KeyPicker.Text == "[...]" then
							keypicker:Set(default);
						end
					end
				end)
				keypicker:Set(default);
				uis.InputBegan:Connect(function(input,t)
					xpcall(function()
						if not t then
							if KeyPicker.Text == "[...]" then
								if input.UserInputType == Enum.UserInputType.Keyboard then
									print(tostring(input.KeyCode))
									keypicker:Set(input.KeyCode)
								else
									keypicker:Set(Enum.KeyCode.Unknown)
								end
							else

								if keypicker:GetValue() ~= Enum.KeyCode.Unknown and input.KeyCode == keypicker:GetValue() then
									toggle:Set(not toggle:GetValue())
								end
							end
						end
					end,warn)
				end)
                 table.insert(library.items,keypicker);
				return keypicker;
			end
             table.insert(library.items,toggle);
			return toggle;
		end
		function tab:CreateSlider(name,min,val,max,callback,flag)
			local sliders = {};
			local value = val;
			flag = flag or name;
			callback = callback or function(val) end;
			library.flags[flag] = val;
			function sliders:GetValue()
				return value;
			end

			local slider = Instance.new("TextButton")
			local Frame = Instance.new("Frame")
			local Title = Instance.new("TextLabel")
			local Value = Instance.new("TextLabel")
			function sliders:Set(number)
				val = math.round(number*25)/25;
				Value.Text = val .. "/" .. max;
				library.flags[flag] = val;
				pcall(callback,val)
			end
			--Properties:

			slider.Name = "slider"
			slider.Parent = ScrollingFrame;
			slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			slider.BackgroundTransparency = 1.000
			slider.Position = UDim2.new(0.0114285713, 0, 0.205063283, 0)
			slider.Size = UDim2.new(0, 173, 0, 41)
			slider.ZIndex = 5
			slider.Font = Enum.Font.Code
			slider.Text = ""
			slider.TextColor3 = Color3.fromRGB(255, 255, 255)
			slider.TextSize = 20.000

			Frame.Parent = slider
			Frame.BackgroundColor3 = Color3.fromRGB(69,130,161)
			Frame.BorderSizePixel = 0
			Frame.Position = UDim2.new(0, 0, 0.317073166, 0)
			Frame.Size = UDim2.new(0, 173, 0, 14)
			Frame.ZIndex = 0

			Title.Name = "Title"
			Title.Parent = slider
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1.000
			Title.Size = UDim2.new(0, 173, 0, 13)
			Title.Font = Enum.Font.Code
			Title.Text = name
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 14.000

			Value.Name = "Value"
			Value.Parent = slider
			Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Value.BackgroundTransparency = 1.000
			Value.Position = UDim2.new(0, 0, 0.658536613, 0)
			Value.Size = UDim2.new(0, 173, 0, 13)
			Value.Font = Enum.Font.Code
			Value.Text = val .. "/" .. max;
			sliders:Set(val);
			local percent = 1 - ((max - val) / (max - min))
			Frame.Size = UDim2.fromOffset(percent * Frame.AbsoluteSize.X, Frame.AbsoluteSize.Y);
			slider.MouseButton1Down:Connect(function()
				local value = (((tonumber(max) - tonumber(min)) / 173) * Frame.AbsoluteSize.X) + tonumber(min) or 0
				Frame.Size = UDim2.new(0, math.clamp(mouse.X - Frame.AbsolutePosition.X, 0, 173), 0, 14)
				sliders:Set(value);
				local moveconnection;
				moveconnection = mouse.Move:Connect(function()

					value = (((tonumber(max) - tonumber(min)) / 173) * Frame.AbsoluteSize.X) + tonumber(min)
					sliders:Set(value);
					Frame.Size = UDim2.new(0, math.clamp(mouse.X - Frame.AbsolutePosition.X, 0, 173), 0, 14)
				end)
				local releaseconnection;
				releaseconnection = uis.InputEnded:Connect(function(Mouse)
					if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
						value = (((tonumber(max) - tonumber(min)) / 173) * Frame.AbsoluteSize.X) + tonumber(min)
						sliders:Set(value);
						Frame.Size = UDim2.new(0, math.clamp(mouse.X - Frame.AbsolutePosition.X, 0, 173), 0, 14)
						moveconnection:Disconnect()
						releaseconnection:Disconnect()
					end
				end)
			end)
			Value.TextColor3 = Color3.fromRGB(255, 255, 255)
			Value.TextSize = 14.000
            table.insert(library.items,sliders);
		end
		function tab:CreateButton(name,callback)
			callback = callback or function() end;
			local Button = Instance.new("TextButton")

			--Properties:

			Button.Name = name or "Button";
			Button.Parent = ScrollingFrame;
			Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Button.BorderSizePixel = 0
			Button.Position = UDim2.new(0.068571426, 0, 0, 0)
			Button.Size = UDim2.new(0, 136, 0, 31)
			Button.Font = Enum.Font.Code
			Button.Text = name or "Button";
			Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			Button.TextSize = 20.000
			Button.TextWrapped = true
			Button.Activated:Connect(function(input)
				pcall(function()
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						pcall(callback);
					end
				end)
			end)
		end
        function tab:Destroy()
            Frame:Destroy()
        	ScrollingFrame:Destroy()
            tab = {};
        end
		return tab;
	end
	window:CreateTab("Keybinds");
	return window;
end
return library;
