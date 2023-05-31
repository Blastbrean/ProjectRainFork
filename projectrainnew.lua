

xpcall(function()
	pcall(function()
		local uis = game:GetService("UserInputService")
		uis.InputBegan:Connect(function(input,t)
			pcall(function()
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.LeaderboardGui.MainFrame.ScrollingFrame:GetChildren()) do
						if not v:FindFirstChild("Player") then continue; end
						local Player = v.Player;
	
						if Player.TextTransparency > 0 then
							while v.Player.TextTransparency > 0 do workspace.CurrentCamera.CameraSubject = Players[v.Player.Text].Character task.wait() end
						end
					end
				end
			end)
		end)
	end)
	local Lighting = game:GetService("Lighting")

	local GetChildren, GetDescendants = game.GetChildren, game.GetDescendants
	local IsA = game.IsA
	local FindFirstChild, FindFirstChildOfClass, FindFirstChildWhichIsA, WaitForChild = 
		game.FindFirstChild,
	game.FindFirstChildOfClass,
	game.FindFirstChildWhichIsA,
	game.WaitForChild

	local GetPropertyChangedSignal, Changed = 
		game.GetPropertyChangedSignal,
	game.Changed

	local Destroy, Clone = game.Destroy, game.Clone

	xpcall(function() setfpscap(360) end,warn)

	function randomString()
		local length = math.random(10,20)
		local array = {}
		for i = 1, length do
			array[i] = string.char(math.random(32, 126))
		end
		return table.concat(array)
	end

	function DecodeIntPrompt(given)
		local mathop
		if given:find("times") then
			mathop = " times "       
		elseif given:find("plus") then
			mathop = " plus "
		elseif given:find("minus") then
			mathop = " minus "
		elseif given:find("divided") then
			mathop = " divided by "
		end
		local lol = " "
		local decoded = tostring(given:gsub("What is ","")):gsub(mathop," "):gsub("?","");
		local numbers = {};
		numbers[1] = mysplit(decoded," ")[1]; 
		numbers[2] = mysplit(decoded," ")[2];
		local mathText, numberOne, numberTwo = given, tonumber(numbers[1]), tonumber(numbers[2])
		local answer = nil
		if mathText:find("times") then
			answer = numberOne * numberTwo
		elseif mathText:find("plus") then
			answer = numberOne + numberTwo
		elseif mathText:find("minus") then
			answer = numberOne - numberTwo
		elseif mathText:find("divided") then
			answer = numberOne / numberTwo
		end
		return math.round(answer*50)/50
	end

	guiParent = nil -- skidded from inf yield
	local coregui = game:GetService"CoreGui"
	if get_hidden_gui or gethui then
		local hiddenUI = get_hidden_gui or gethui
		local Main = Instance.new("ScreenGui")
		Main.Name = randomString()
		Main.Parent = hiddenUI()
		guiParent = Main
	elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
		local Main = Instance.new("ScreenGui")
		Main.Name = randomString()
		syn.protect_gui(Main)
		Main.Parent = coregui
		guiParent = Main
	elseif coregui:FindFirstChild('RobloxGui') then
		guiParent = coregui.RobloxGui
	else
		local Main = Instance.new("ScreenGui")
		Main.Name = randomString()
		Main.Parent = coregui
		guiParent = Main
	end

	local LoadingText = Instance.new("TextLabel")
	LoadingText.Name = randomString()
	LoadingText.AnchorPoint = Vector2.new(0.5, 0.5)
	LoadingText.Position = UDim2.new(0.5, 0, 0.5, 0)
	LoadingText.Size = UDim2.new(0, 350, 0, 50)
	LoadingText.BackgroundTransparency = 1
	LoadingText.TextScaled = true
	LoadingText.TextStrokeTransparency = 0
	LoadingText.TextColor3 = Color3.new(1,1,1)
	LoadingText.TextStrokeColor3 = Color3.new(0.227450, 0, 0)
	LoadingText.Text = "loading"
	LoadingText.Visible = true
	LoadingText.Parent = guiParent
	LoadingText.Text = "Authorizing..."
	local starttime = tick();
	local authorized = false;
    authorized = true;
	local uilib = game:HttpGet("https://raw.githubusercontent.com/MimiTest2/projectrainfree/main/uilib.lua")
	local _,esplib = pcall(loadstring(game:HttpGet(("https://raw.githubusercontent.com/MimiTest2/projectrainfree/main/esplib.lua"),true)))

	LoadingText.Text = "Reauthorized in: " .. math.abs(math.round((starttime-tick())*1000)) .. "ms.";
	task.wait(0.1)
	LoadingText.Text = "Loading iris instance protect..."
	pcall(loadstring(game:HttpGet("https://raw.githubusercontent.com/MimiTest2/projectrainfree/main/irisinstprotect.lua")));
	if not getgenv().ProtectInstance then
		LoadingText.Text = "Failed iris instance protect..."
		return;
	end
	task.wait(0.1)

	local Registry = {};
	local RegistryMap = {};

	local KillBrickFolder = Instance.new("Folder");
	KillBrickFolder.Name = "KillBricks"
	KillBrickFolder.Parent = guiParent

	local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end);
	local ScreenGui = Instance.new('ScreenGui');
	ProtectGui(ScreenGui);
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
	ScreenGui.Parent = game:GetService("CoreGui");
	function GetTextBounds(Text,Font,Size)
		return game:GetService("TextService"):GetTextSize(Text, Size, Font, Vector2.new(1920, 1080)).X
	end
	function Create(Class, Properties)
		local _Instance = Class;
		if type(Class) == 'string' then
			_Instance = Instance.new(Class);
		end;
		for Property, Value in next, Properties do
			_Instance[Property] = Value;
		end;
		return _Instance;
	end
	function AddToRegistry(Instance, Properties, IsHud)
		local Idx = #Registry + 1;
		local Data = {
			Instance = Instance;
			Properties = Properties;
			Idx = Idx;
		};
		table.insert(Registry, Data);
		RegistryMap[Instance] = Data;
	end;
	function CreateLabel(Properties, IsHud)
		local _Instance = Create('TextLabel', {
			BackgroundTransparency = 1;
			Font = Enum.Font.Code;
			TextColor3 = Color3.fromRGB(255, 255, 255);
			TextSize = 16;
			TextStrokeTransparency = 0;
		});
		AddToRegistry(_Instance, {
			TextColor3 = 'FontColor';
		}, IsHud);
		return Create(_Instance, Properties);
	end;
	local NotificationArea = Create('Frame', {
		BackgroundTransparency = 1;
		Position = UDim2.new(0, 0, 0, 40);
		Size = UDim2.new(0, 300, 0, 200);
		ZIndex = 100;
		Parent = ScreenGui;
	});
	Create('UIListLayout', {
		Padding = UDim.new(0, 4);
		FillDirection = Enum.FillDirection.Vertical;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Parent = NotificationArea;
	})
	function Notify(Text, Time)
		local MaxSize = GetTextBounds(Text, Enum.Font.Code, 14);
		local notclicked = false;
		local NotifyOuter = Create('Frame', {
			BorderColor3 = Color3.new(0, 0, 0);
			Position = UDim2.new(0, 100, 0, 10);
			Size = UDim2.new(0, 0, 0, 20);
			ClipsDescendants = true;
			ZIndex = 100;
			Parent = NotificationArea;
		});
		local NotifyInner = Create('Frame', {
			BackgroundColor3 = Color3.fromRGB(28, 28, 28);
			BorderColor3 = Color3.fromRGB(50, 50, 50);
			BorderMode = Enum.BorderMode.Inset;
			Size = UDim2.new(1, 0, 1, 0);
			ZIndex = 101;
			Parent = NotifyOuter;
		});
		AddToRegistry(NotifyInner, {
			BackgroundColor3 = Color3.fromRGB(28, 28, 28);
			BorderColor3 = Color3.fromRGB(50, 50, 50);
		}, true);
		local InnerFrame = Create('Frame', {
			BackgroundColor3 = Color3.new(1, 1, 1);
			BorderSizePixel = 0;
			Position = UDim2.new(0, 1, 0, 1);
			Size = UDim2.new(1, -2, 1, -2);
			ZIndex = 102;
			Parent = NotifyInner;
		});
		local function inputBegan(input)
			pcall(function() if input.UserInputType == Enum.UserInputType.MouseButton1 then
					task.spawn(function() pcall(function()
							NotifyOuter:TweenSize(UDim2.new(0, 0, 0, 20), 'Out', 'Quad', 0.4, true);
							task.wait(0.4);
							NotifyOuter:Destroy();
						end) end);
					notclicked = false;
				end end)
		end
		InnerFrame.InputBegan:Connect(inputBegan)
		Create('UIGradient', {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(27, 27, 27)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(52, 52, 52))
			});
			Rotation = -90;
			Parent = InnerFrame;
		});
		local NotifyLabel = CreateLabel({
			Position = UDim2.new(0, 4, 0, 0);
			Size = UDim2.new(1, -4, 1, 0);
			Text = Text;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextSize = 14;
			ZIndex = 103;
			Parent = InnerFrame;
		});
		local LeftColor = Create('Frame', {
			BackgroundColor3 = Color3.fromRGB(0, 85, 255);
			BorderSizePixel = 0;
			Position = UDim2.new(0, -1, 0, -1);
			Size = UDim2.new(0, 3, 1, 2);
			ZIndex = 104;
			Parent = NotifyOuter;
		});
		AddToRegistry(LeftColor, {
			BackgroundColor3 = Color3.fromRGB(0, 85, 255);
		}, true);
		NotifyOuter.Size = UDim2.new(0, MaxSize + 8 + 4, 0, 20);
		task.spawn(function() pcall(function()
				task.wait(Time or 5);
				NotifyOuter:TweenSize(UDim2.new(0, 0, 0, 20), 'Out', 'Quad', 0.4, true);
				task.wait(0.4);
				NotifyOuter:Destroy();
			end) end);
	end;

	if game.PlaceId == 4111023553 then
		pcall(function() LoadingText:Destroy() end)
		Notify("Project Rain will not load in title screen, please join a server and re-execute")
		wait(math.huge)
		return
	end

	task.wait(0.1)
	LoadingText.Text = "Loading Moderator detector...";
	local Players = game:GetService("Players")
	local function onPlayerAdded(player)
		pcall(function()
			if player == plr then return end
			Notify("Checking: " .. player.Name)
			local suc,err = pcall(function() 
				repeat task.wait() until player.Parent == Players;
				if player:GetRankInGroup(5212858) > 0 or player:GetRankInGroup(4556484) > 0 then -- dont remove 15326583
					task.spawn(function() 
						xpcall(function()
							local soundy = Instance.new("Sound", game:GetService("CoreGui"))
							soundy.SoundId = "rbxassetid://247824088"
							soundy.PlaybackSpeed = 1
							soundy.Playing = true
							soundy.Volume = 5
							task.wait(3)
							soundy:Destroy()
						end,warn) 
					end)
					Notify("Moderator has been detected: " .. player.Name,9e9)
				end 
			end)
			if not suc then
				Notify("Failed to detect if " .. player.Name .. " is a moderator. ERROR (REPORT TO MIST): " .. err);
			end
		end)
	end
	Players.PlayerAdded:Connect(onPlayerAdded)
	for i, v in pairs(Players:GetPlayers()) do
		task.spawn(function() pcall(onPlayerAdded,v) end);
		task.wait(0.3);
	end
	task.wait(0.1)
	LoadingText.Text = "Loading script...";

	local plr = game:GetService("Players").LocalPlayer;
	local backpack = plr:WaitForChild("Backpack")
	local pgui = plr:WaitForChild("PlayerGui")
	local uis = game:GetService("UserInputService");
	local library = loadstring(uilib)();
	local partids = {};

	if pgui:FindFirstChild("LoadingGui") then
		Notify("Project Rain will not run in menu, please spawn in!")
		repeat wait() until not pgui:FindFirstChild("LoadingGui")
	end

	function getRoot()
		return plr.Character.PrimaryPart;
	end
	function doRegion(part)
		local Region = Region3.new(part.Position - Vector3.new(2,1,2), part.Position + Vector3.new(2,1,2))
		local parts = workspace:FindPartsInRegion3WithIgnoreList(Region, {plr.Character}, 10000)
		for i, v in pairs(parts) do
			if not partids[v] then  partids[v] = {Instance = v,Transparency = v.Transparency, CanCollide = v.CanCollide} end
			v.CanCollide = false;
			v.Transparency = 0.75;
		end
		return #parts
	end
    local kownertick = false;
	local bv;
    function getallequippedtools()
		local tbl = {}
		for i, v in pairs(plr.Character:GetChildren()) do
			if v:IsA("Tool") then
				table.insert(tbl,v)
			end
		end
		return tbl
	end
	local CON_FUNCTIONS = {
        KnockedOwnership = function()
            pcall(function()
                if plr.Character.Torso:FindFirstChild("RagdollAttach") and plr.Character.Humanoid.Health < 10 then
                    if #getallequippedtools() > 1 then
                        plr.Character.Humanoid:UnequipTools()
                    end
                    if backpack:FindFirstChild("Weapon") then
                        backpack["Weapon"].Parent = plr.Character
                    else
                        plr.Character:FindFirstChild("Weapon").Parent = backpack
                    end
                    kownertick = true
                else
                    if kownertick then
                        kownertick = false
                        plr.Character.Humanoid:UnequipTools()
                        if backpack:FindFirstChild("Weapon") then
                            backpack["Weapon"].Parent = plr.Character
                        end
                        task.wait(0.5)
                        if backpack:FindFirstChild("Weapon") then
                            backpack["Weapon"].Parent = plr.Character
                        else
                            plr.Character:FindFirstChild("Weapon").Parent = backpack
                        end
                        task.wait(0.5)
                        if backpack:FindFirstChild("Weapon") then
                            backpack["Weapon"].Parent = plr.Character
                        end
                    end
                end
            end)
        end,
		Flight = function()
			xpcall(function()
				local hrp, hum = plr and plr.Character and getRoot(), plr and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
				if not hrp or not hum then return end

				bv.Velocity = Vector3.new();
				if hum.MoveDirection.Magnitude > 0 then
					local travel = Vector3.new(0,0,0)
					local looking = (workspace.CurrentCamera.CFrame.lookVector.Unit) * library.flags["Flight Speed"]
					if uis:IsKeyDown(Enum.KeyCode.W) then
						travel += looking;
					end
					if uis:IsKeyDown(Enum.KeyCode.S) then
						travel -= looking;
					end
					if uis:IsKeyDown(Enum.KeyCode.D) then
						travel += (workspace.CurrentCamera.CFrame.RightVector.Unit) * library.flags["Flight Speed"]
					end
					if uis:IsKeyDown(Enum.KeyCode.A) then
						travel -= (workspace.CurrentCamera.CFrame.RightVector.Unit) * library.flags["Flight Speed"]
					end
					bv.Velocity = travel.Unit * library.flags["Flight Speed"]
				end
				bv.MaxForce = Vector3.new(9e9,9e9,9e9)
			end,warn)
		end,

		["Speed"] = function()
			xpcall(function()
				local hrp, hum = plr.Character:FindFirstChild("HumanoidRootPart"), plr.Character:FindFirstChildOfClass("Humanoid")
				if not hrp or not hum then return end
				hrp.Velocity *= Vector3.new(0,1,0)
				if hum.MoveDirection.Magnitude > 0 then
					hrp.Velocity += hum.MoveDirection.Unit * library.flags["Walk Speed"]
				end
			end,warn)
		end,

		Noclip = function()
			xpcall(function()
				local found = false;
				local raycastParams = RaycastParams.new()
				raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
				raycastParams.FilterDescendantsInstances = {workspace.Map}
				raycastParams.FilterDescendantsInstances = {}
				raycastParams.IgnoreWater = true
				local raycastResult = workspace:Raycast(plr.Character.HumanoidRootPart.Position, ((plr.Character.Torso.Position - plr.Character.HumanoidRootPart.Position) + plr.Character.Torso.CFrame.LookVector) + plr.Character.Humanoid.MoveDirection.Unit * 5, raycastParams)
				if raycastResult and raycastResult.Instance.CanCollide then
					if not partids[raycastResult.Instance] then  partids[raycastResult.Instance] = {Instance = raycastResult.Instance,Transparency = raycastResult.Instance.Transparency, CanCollide = raycastResult.Instance.CanCollide} end
					raycastResult.Instance.CanCollide = false;
					raycastResult.Instance.Transparency = 0.75;
					found = true;
				end
				local parts = 0;
				for i, v in pairs(plr.Character:GetChildren()) do
					if v:IsA("BasePart") and not string.match(v.Name:lower(),"leg") then
						parts += doRegion(v)
					end
				end
				if parts < 1 and found == false then
					for i, v in pairs(partids) do
						v.Instance.Transparency = v.Transparency
						v.Instance.CanCollide = v.CanCollide;
						partids[i] = nil;
					end
				end
			end,warn)
		end,
	}

	LPH_JIT = function(...) return ... end
	LPH_NO_UPVALUES = function(...) return ... end
	LPH_NO_VIRTUALIZE = function(...) return ... end

	--------------------------------------------------
	pcall(function()
		LPH_JIT(function()
			pcall(function()
				local call
				call = hookmetamethod(game,'__namecall', LPH_NO_UPVALUES(function(Self,...)
					local args = {...}
					if not checkcaller() then
						local getname = getnamecallmethod()
						if getgenv().Nofall then
							if tostring(getname) == "FireServer" and getcallingscript().Name == "WorldClient" and type(args[1]) == "number" and type(args[2]) == "boolean" then
								return args[1] == (math.random(2,29)/100)
							end
						end
					end
					return call(Self,...)
				end))
				local oldnewindex
				oldnewindex = hookmetamethod(game, "__newindex", LPH_NO_UPVALUES(function(self,prop,val)
					if not checkcaller() then
						if self.Name == "Lighting" and getgenv().FullBright then
							if prop == "Brightness" then
								return oldnewindex(self, prop, 2);
							elseif prop == "ClockTime" then
								return oldnewindex(self, prop, 14)
							elseif prop == "GlobalShadows" then
								return oldnewindex(self, prop, false)
							end
							oldnewindex(self,prop,val) 
						end
						if self:IsA("Atmosphere") and self.Parent.Name == "Lighting" and getgenv().NoFog then
							if prop == "Density" then
								return oldnewindex(self, prop, .002)
							end
							return;
						end
						if self.Name == "Lighting" and getgenv().NoFog then
							if prop == "FogEnd" then
								return oldnewindex(self, prop, 90000)
							elseif prop == "Ambient" then
								return oldnewindex(self, prop, Color3.fromRGB(0.17, 0.23, 0.2))
							elseif prop == "OutdoorAmbient" then
								return oldnewindex(self, prop, Color3.fromRGB(128,128,128))
							end
							oldnewindex(self,prop,val)
						end
					end 
					return oldnewindex(self,prop,val)
				end))
			end) 
		end)();
	end)
	--------------------------------------------------

	function click(button)
		xpcall(function()
			for _,v in pairs(getconnections(button.MouseButton1Click)) do
				xpcall(function()
					v:Fire()
				end,warn)
			end
		end,warn)
	end

	--pcall(function()
	--    pgui.SharkoPet.Frame.TextBubble.TextLabel.Text = "Thank you for using Project Rain!"
	--    pgui.SharkoPet.Frame.TextBubble.Visible = true
	--end) safety

	xpcall(function()
		local sfx = Instance.new("Sound")
		game:GetService("Debris"):AddItem(sfx,5)
		sfx.Parent = guiParent
		sfx.SoundId = "rbxassetid://12935727919"
		sfx.Volume = 10
		sfx.PlaybackSpeed = 1.5
		sfx:Play()
	end,warn)

	local window = library:CreateWindow();
	local tabs = {
		["Movement"] = window:CreateTab("Movement"),
		["Misc"] = window:CreateTab("Misc"),
		["Combat"] = window:CreateTab("Combat"),
		["ESP"] = window:CreateTab("ESP"),
		["World"] = window:CreateTab("World"),
		["Settings"] = window:CreateTab("Settings"),
		["Temp"] = window:CreateTab('')
	}
    tabs["Settings"]:CreateButton("Save Config",function()
        pcall(function()
			local flags = library.flags
			for i, v in pairs(flags) do
				flags[i] = tostring(v)
			end
			local e = game:GetService("HttpService"):JSONEncode(flags)
			writefile("config.txt",e)
		end)
    end)
    tabs["Settings"]:CreateButton("Load Config",function()
        pcall(function()  
			local fixed = game:GetService("HttpService"):JSONDecode(readfile("config.txt"))
			for i, v in pairs(fixed) do
				if string.match(tostring(v),"Enum.KeyCode.") then
					fixed[i] = Enum.KeyCode[string.split(tostring(v),"Enum.KeyCode.")[2]]
				elseif v == "false" then
					fixed[i] = false
				elseif v == "true" then
					fixed[i] = true;
                elseif tonumber(string.split(tostring(v),'"')[1]) then
                    fixed[i] = tonumber(string.split(tostring(v),'"')[1]);
                end			
            end
			library.flags = fixed
			for i,v in pairs(library.items) do
				pcall(function()
					v:Set(library.flags[v.flag])
				end)
			end
		end)
    end)
	tabs["Temp"]:CreateToggle("",false,function() end):CreateKeypicker("UI",Enum.KeyCode.RightControl,function(key)
		library.openkey = key;
	end)
	tabs["Temp"]:Destroy();
	tabs["Temp"] = nil;
	function addToggle(name,funcname,default,tab,togglef,keypicker,keypickerdefault,keypickername)
		local conn;
		togglef = togglef or function() end;
		keypicker = keypicker or false;
		keypickerdefault = keypickerdefault or Enum.KeyCode.Unknown;
		keypickername = keypickername or "Keypicker";
		funcname = funcname or ""
		local tog = tabs[tab]:CreateToggle(name,default,function(toggled) 
			pcall(function()
				task.spawn(function() pcall(togglef,toggled) end)
				if toggled and CON_FUNCTIONS[funcname] then
					conn = game:GetService("RunService").RenderStepped:Connect(CON_FUNCTIONS[funcname]);
				else
					if conn then
						conn:Disconnect()
						conn = nil;
					end
				end
			end)
		end)
		if keypicker then
			local key = tog:CreateKeypicker(keypickername,keypickerdefault,function() end);
			library.items[keypickername] = key;
		end
		print(name,library.items,tog);
		library.items[name] = tog;
	end
	function addSlider(tab,name,min,val,max,flag,callback)
		callback = callback or function() end;
		flag = flag or name;
		min = min or 1;
		val = val or 1;
		max = max or max;
		name = name or "test slider"
		local slider = tabs[tab]:CreateSlider(name,min,val,max,callback,flag)
		library.items[flag] = slider;
	end
    --        name,funcname,default,tab,togglef,keypicker,keypickerdefault,keypickername
	addToggle("Fastwalk","Speed",false,"Movement",function(e) end,true,Enum.KeyCode.F3,"Fastwalk");
    addToggle("Knocked Ownership","KnockedOwnership",false,"Misc",function(e) end,false,nil,nil);
	addToggle("Noclip","Noclip",false,"Movement",function(e)
		if not e then
			for i, v in pairs(partids) do
				pcall(function()
					v.Instance.Transparency = v.Transparency
					v.Instance.CanCollide = v.CanCollide
					partids[i] = nil
				end)
			end
		end
	end,true,Enum.KeyCode.N,"Noclip");
	addToggle("Fly","Flight",false,"Movement",function(enabled)
		if enabled then
			bv = Instance.new("BodyVelocity")
			getgenv().ProtectInstance(bv);
			bv.Parent = getRoot();
			bv.MaxForce = Vector3.new(4000000, 4000000, 4000000)
			bv.velocity = Vector3.new(0,0,0)
		else
            if bv then
			bv:Destroy();
			getgenv().UnProtectInstance(bv);
			task.wait()
			bv = nil;
            end
		end
	end,true,Enum.KeyCode.F4,"Flight");
	addSlider("Movement","Walk Speed",1,150,250,"Walk Speed");
	addSlider("Movement","Flight Speed",1,150,250,"Flight Speed");
	getgenv().agilityspooferenabled = false
	addToggle("Agility Spoofer","",false,"Movement",function(val)
		getgenv().agilityspooferenabled = val

		task.spawn(function()
			while getgenv().agilityspooferenabled == true do
				wait()
				pcall(function()
					plr.Character.Agility.Value = library.flags["Agility"]
				end)
			end
		end)
	end)
	addSlider("Movement","Agility",1,35,100,"Agility")

	spoofedAirDashFolder = nil
	addToggle("Dash+","",false,"Movement",function(val)
		xpcall(function()
			if spoofedAirDashFolder then
				pcall(function() spoofedAirDashFolder:Destroy() end)
			end
			if val then
				xpcall(function()
					spoofedAirDashFolder = Instance.new("Folder")
					spoofedAirDashFolder.Name = "Talent:Aerial Assault"
					spoofedAirDashFolder.Parent = backpack
				end,warn)
			end
		end,warn)
	end)

	--

	local function GetClosest()
		local Character = plr.Character
		if not Character then return end

		local TargetDistance = 250
		local Target

		for i,v in ipairs(game:GetService("Players"):GetPlayers()) do
			if v ~= game:GetService("Players").LocalPlayer and v.Character then
				local TargetHRP = v.Character:GetPivot()
				local mag = (game:GetService("Players").LocalPlayer.Character:GetPivot().Position - TargetHRP.Position).magnitude
				if mag < TargetDistance then
					TargetDistance = mag
					Target = v
				end
			end
		end

		return Target
	end

	local nearbyconnection = nil
	local Indicator do
		Indicator = Instance.new("TextLabel", guiParent)
		Indicator.AnchorPoint = Vector2.new(0.5, 0.5)
		Indicator.Position = UDim2.new(0.5, 0, 0.25, 0)
		Indicator.Size = UDim2.new(0, 200, 0, 50)
		Indicator.BackgroundTransparency = 1
		Indicator.TextScaled = true
		Indicator.TextStrokeTransparency = 0
		Indicator.TextColor3 = Color3.new(0, 0, 0)
		Indicator.TextStrokeColor3 = Color3.new(1, 1, 1)
		Indicator.Text = ""
		Indicator.Visible = false
	end

	addToggle("Player Nearby Indicator","",true,"Misc",function(e)
		xpcall(function()
			Indicator.Visible = e
			if e then
				nearbyconnection = game:GetService("RunService").RenderStepped:Connect(function()
					pcall(function()
						local closest = GetClosest();
						if closest ~= nil then
							Indicator.Text = closest.Name .. " is nearby!"
							Indicator.TextStrokeColor3 = Color3.fromRGB(255,194,194)
						else
							Indicator.Text = "Nobody is nearby"
							Indicator.TextStrokeColor3 = Color3.new(1,1,1)
						end
					end)
				end)
			else
				if nearbyconnection ~= nil then
					nearbyconnection:Disconnect()
				end
			end
		end,warn)
	end)

	addToggle("No Fall","",true,"Misc",function(val)
		xpcall(function()
			getgenv().Nofall = val
		end,warn)
	end)

	tabs["Misc"]:CreateButton("Server Hop",function()
		pcall(function()
			math.randomseed(os.clock())
			local plrs = Players:GetPlayers()
			local plr = Players.LocalPlayer
			local targetPlayer
			repeat task.wait()
				targetPlayer = plrs[math.random(1,#plrs)]
				if targetPlayer == plr or targetPlayer:IsFriendsWith(plr.UserId) then targetPlayer = nil end
			until targetPlayer
			game.StarterGui:SetCore("PromptBlockPlayer", targetPlayer)
			task.delay(math.random(36,71)/100,function()
				xpcall(function()
					click(game:GetService("CoreGui").RobloxGui:WaitForChild'PromptDialog':WaitForChild'ContainerFrame':WaitForChild'ConfirmButton')
				end,warn)
			end)
			game:GetService("CoreGui").RobloxGui:WaitForChild'PromptDialog':WaitForChild'ContainerFrame':WaitForChild'ConfirmButton'.MouseButton1Click:Connect(function()
				pcall(function()
					game:GetService('TeleportService'):Teleport(game.PlaceId)
					task.wait()
					plr:Kick("Server Hopping...")
				end)
			end)
		end)
	end)


    getgenv().autosprintenabled = false;
    addToggle("Auto Sprint","",false,"Misc",function(enabled)
        pcall(function()
            getgenv().autosprintenabled = enabled;
        end)
    end)
	local keypressed = false;
    game:GetService("UserInputService").InputBegan:Connect(function(k,t)
		pcall(function() 
            if getgenv().autosprintenabled and not t and k.KeyCode == Enum.KeyCode.W and not keypressed then
				keypressed = true;
				task.wait()
				keyrelease(0x57)
				task.wait()
				keypress(0x57)
				task.wait(0.07)
				keypressed = false;
			end 
        end)
	end)

	addToggle("Int Farm","",false,"Misc",function(enabled)
		getgenv().INTFARMENABLED = enabled;
		pcall(function()
			while getgenv().INTFARMENABLED do
				task.wait()	
				xpcall(function()
					repeat task.wait() until pgui:FindFirstChild'ChoicePrompt'
					repeat task.wait() until pgui:FindFirstChild'ChoicePrompt':FindFirstChild'ChoiceFrame'
					local Options = pgui.ChoicePrompt.ChoiceFrame.Options;
					local given = pgui.ChoicePrompt.ChoiceFrame.DescSheet.Desc.Text;
					task.wait(math.random(259,378)/98.63)
					local answer = Options:FindFirstChild(tostring(DecodeIntPrompt(given)))
					click(answer);
					task.wait();
				end,warn)
			end
		end)
	end)

	atModOffice = false
    tabs["Misc"]:CreateButton("Mod Office",function()
        if not Lighting:FindFirstChild("FragmentSky") then
            Notify("You must be in Fragments of Self to teleport")
            return
        end

        xpcall(function()
            local char, hrp = plr and plr.Character, plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if not plr or not char or not hrp then return end
            if not atModOffice then
                xpcall(function()
                    hrp.CFrame = CFrame.new(40000,40012.5,40000)
                end,warn)
                Notify("Click the Mod Office button again to return to Fragments of Self spawn")
                atModOffice = true
            else
                xpcall(function()
                    hrp.CFrame = CFrame.new(2910.23046875, 1133.0269775390625, 1474.47900390625)
                end,warn)
                atModOffice = false
            end
        end,warn)
    end)

	--

	addToggle("No Kill Bricks","",false,"World",function(enabled)
		pcall(function()
			if enabled then
				while library.flags["No Kill Bricks"] do
					pcall(function()
                        if (workspace:FindFirstChild("Layer2Floor1")) then
						    for i, v in pairs(workspace.Layer2Floor1:GetChildren()) do
						    	if v.Name == "SuperWall" then
						    		v.CanTouch = false;
						    	end
						    end
                        end
					end)
					pcall(function()
						for i, v in pairs(workspace:GetChildren()) do
							if v.Name == "KillPlane" or v.Name == "ChasmBrick" then
								v.Parent = KillBrickFolder
							end
						end
					end)
					task.wait(1)
				end
			else
				pcall(function()
                    if (workspace:FindFirstChild("Layer2Floor1")) then
					    for i, v in pairs(workspace.Layer2Floor1:GetChildren()) do
					    	if v.Name == "SuperWall" then
					    		v.CanTouch = true;
					    	end
					    end
                    end
				end)
				pcall(function()
					for i, v in pairs(KillBrickFolder:GetChildren()) do
						v.Parent = workspace;
					end
				end)
			end
		end)
	end)

	addToggle("No Fog","",true,"World",function(val)
		xpcall(function()
			getgenv().NoFog = val
		end,warn)
	end)

	addToggle("Fullbright","",true,"World",function(val)
		xpcall(function()
			getgenv().FullBright = val
		end,warn)
	end)

	--
	LPH_NO_VIRTUALIZE(function() 
        xpcall(function()
			task.spawn(function()
				xpcall(function()
					addToggle("Enabled","",true,"ESP",function(val)
						xpcall(function()
							esplib.options.enabled = val
						end,warn)
					end)
					--local mobesptoggle = espsec:AddToggle("Mobs",true, function(val) end)

					addToggle("Distance","",true,"ESP",function(val)
						xpcall(function()
							esplib.options.distance = val
						end,warn)
					end)

					addToggle("Arrows","",false,"ESP",function(val)
						xpcall(function()
							esplib.options.outOfViewArrows = val
						end,warn)
					end)


					addToggle("Health","",true,"ESP",function(val)
						xpcall(function()
							esplib.options.healthBars = val
						end,warn)
					end)

					addSlider("ESP","Arrow Size",1,10,48,"EspArrowSize",function(val)
						xpcall(function()
							esplib.options.outOfViewArrowsSize = val
						end,warn)
					end)


					addSlider("ESP","Text Size",4,24,32,"EspTextSize",function(val)
						xpcall(function()
							esplib.options.fontSize = val
						end,warn)
					end)

                --[[local esparrowscolor = espsec:AddColorpicker("Arrows Color",Color3.fromRGB(60,255,60),function(val)
                    xpcall(function()
                        esplib.options.outOfViewArrowsColor = val
                        pcall(function() esplib.options.outOfViewArrowsOutlineColor = Color3.fromRGB(val.R - 30, val.G - 30, val.B - 30) end)
                    end,warn)
                end)
                local esptracerscolor = espsec:AddColorpicker("Tracers Color",Color3.fromRGB(60,255,60),function(val)
                    xpcall(function()
                        esplib.options.tracerColor = val
                    end,warn)
                end)
                local esptextcolor = espsec:AddColorpicker("Color",Color3.fromRGB(60,255,60),function(val)
                    xpcall(function()
                        esplib.options.boxesColor = val
                        esplib.options.nameColor = val
                        esplib.options.distanceColor = val
                        esplib.options.healthTextColor = val
                    end,warn)
                end)]]

					esplib:Load()

					pcall(function()
						esplib.options.enabled = true
						esplib.options.maxDistance = 10000
						esplib.options.nameColor = Color3.fromRGB(255,255,255)
						esplib.options.healthText = false
						esplib.options.healthTextColor = Color3.fromRGB(255,255,255)
						esplib.options.distance = true
						esplib.options.distanceColor = Color3.fromRGB(255,255,255)
						esplib.options.fontSize = 24
						esplib.options.font = 1
						esplib.options.healthBarsSize = 2
						esplib.options.healthBarsColor = Color3.fromRGB(115,255,115)
						esplib.options.outOfViewArrows = false
						esplib.options.outOfViewArrowsOutline = false;
						esplib.options.outOfViewArrowsColor = Color3.fromRGB(255,255,255)
						esplib.options.outOfViewArrowsSize = 10
					end)
				end,warn)
			end)
			local camera = workspace.CurrentCamera
			local runservice = game:GetService("RunService")
			function esp(drop)
				local dropesp = Drawing.new("Text")
				dropesp.Visible = false
				dropesp.Center = true
				dropesp.Outline = true
				dropesp.Font = 2
				dropesp.Color = Color3.fromRGB(255,255,255)
				dropesp.Size = 16

				local renderstepped
				renderstepped = runservice.Heartbeat:Connect(LPH_JIT(function()
					local suc, err = pcall(function() 
						if drop and workspace.Live[drop.Name] and drop:FindFirstChild("Humanoid") and drop:FindFirstChild("HumanoidRootPart") then
							local drop_pos, drop_onscreen = camera:WorldToViewportPoint(drop.HumanoidRootPart.Position)
							local humanoid = drop.Humanoid
							if library.flags["Mobs"] and drop_onscreen  then
								dropesp.Position = Vector2.new(drop_pos.X, drop_pos.Y)
								dropesp.Text = "[" .. drop.Name .. "]" .. " [" .. math.round(humanoid.Health) .. "/" .. math.round(humanoid.MaxHealth) .. "]"
								dropesp.Visible = true
							else 
								dropesp.Visible = false
							end
						else
							dropesp.Visible = false
						end 
					end)
					pcall(function()
						if not suc then
							dropesp.Visible = false
							dropesp:Remove()
							renderstepped:Disconnect()
						end
					end)
				end))
			end
			pcall(function()
				workspace.Live.ChildAdded:Connect(function(v)
					pcall(function()
						if string.match(v.Name,".") and not Players:GetPlayerFromCharacter(v) then
							v:WaitForChild("HumanoidRootPart",9e9)
							esp(v);
						end
					end)
				end)
				for i, v in pairs(workspace.Live:GetChildren()) do
					task.spawn(function() 
						pcall(function()
							if string.match(v.Name,".") and not Players:GetPlayerFromCharacter(v) then
								v:WaitForChild("HumanoidRootPart",9e9)
								esp(v);
							end
						end) 
					end)
				end
			end)
			addToggle("Mobs","",true,"ESP",function() end)
		end,warn) 
    end)()

	--
    local config = game:HttpGet("https://raw.githubusercontent.com/MimiTest2/projectrainfree/main/apdata.json")
    local data = game:GetService("HttpService"):JSONDecode(config)
    function roll()
        keypress(0x51)
        task.wait(0.05)
        keyrelease(0x51)
    end;
    function parry()
        keypress(0x46)
        task.wait(0.05)
        keyrelease(0x46)
    end;
    local animationhandler = function(character,animation)
        xpcall(function()
            local anim = tostring(animation.Animation.AnimationId);
            if data[anim] and library.flags["AP"] then
                local info = data[anim];
                if (character:GetPivot().Position - game.Players.LocalPlayer.Character:GetPivot().Position).Magnitude > info.Range then
                    return;
                end
                --print("wait " .. info.Wait .. "ms")
                if library.flags["APA"] then
                    info.Wait = info.Wait - game:GetService("Stats"):WaitForChild("PerformanceStats"):WaitForChild("Ping"):GetValue();
                end
                info.Wait = info.Wait - library.flags["PA"]/100;
                if info.Wait < 0 then
                    info.Wait = 0;
                end
                Notify("Waiting " .. info.Wait .. "ms before parrying.");
                task.wait(info.Wait/1000);
                Notify("Parrying...");
                if info.Roll or library.flags["OR"] then
                    roll();
                else
                    parry();
                end
                --print("parry normal");
                if info.RepeatParryAmount and info.RepeatParryAmount > 0 then
                    for i = 1,info.RepeatParryAmount+1 do
                        --print("wait " .. info.RepeatParryDelay .. "ms")
                        Notify("Waiting " .. info.Wait .. "ms before parrying.");
                        task.wait(info.RepeatParryDelay/1000)
                        Notify("Parrying...");
                        --print("repeat parry");
                        parry();
                    end
                end
            end
        end,warn)
    end
    function charHandler(character)
        xpcall(function()
            if character == game:GetService("Players").LocalPlayer.Character then
                return;
            end
            repeat task.wait() until character:FindFirstChild("Humanoid");
            local humanoid = character:FindFirstChild("Humanoid");
            humanoid:FindFirstChild("Animator").AnimationPlayed:Connect(function(e)
                pcall(function()
                    animationhandler(character,e);
                end);
            end);
        end,warn)
    end
    workspace.Live.ChildAdded:Connect(charHandler);
    for i, v in pairs(workspace.Live:GetChildren()) do
        task.spawn(function() charHandler(v) end);
    end
    addToggle("AP","",false,"Combat",function(val)
		
	end)
    addSlider("Combat","PA",-25,0,100,"PA");
    addToggle("APA","",true,"Combat",function(val)
		
	end)

    addToggle("OR","",false,"Combat",function(val)
		
	end)
	LoadingText:Destroy()
		Notify("To remove this notification. Click it. To open tabs. right click them " .. player.Name,9e9)
end,warn)
