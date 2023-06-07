
---@diagnostic disable: undefined-global

--auth part 2
LPH_NO_VIRTUALIZE = function(...) return ... end
local starttime = tick();
local authorized = false;
if LPH_OBFUSCATED then
	pcall(function()

		function getHwid() 
			local req = request or (syn and syn.request) or (Krnl and Krnl.request) or (fluxus and fluxus.request)
			local hwid = req({
				Url = "https://httpbin.org/get",
				Method = "GET",
				Headers = {
					["Syn-Fingerprint"] = ""
				}
			})
			function getHwid(sex)
				headers = sex.headers
				for i, v in pairs(headers) do
					if string.match(i:lower(),"print") or string.match(i:lower(),"identifier") then
						return v
					end
				end
				return game:GetService("RbxAnalyticsService"):GetClientId()
			end
			if not hwid.Success then
				return game:GetService("RbxAnalyticsService"):GetClientId()
			end

			if hwid.Success then
				local data = game:GetService("HttpService"):JSONDecode(hwid.Body)
				return getHwid(data)
			end
			return nil
		end
		local hwid = getHwid()
		local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

		if request then
			local a = request({
				Url = LPH_ENCSTR('http://rain.qexp.xyz:1087/checkauth/?key=')..getgenv().Key..'&hwid='..hwid..":"..getgenv().DiscordId,
				Method = 'POST',
				Headers = {
					['Content-Type'] = 'application/json',
					Origin = 'http://steamworks.nil'
				},
				Body = game:GetService"HttpService":JSONEncode({
					args = {}
				})
			})
			if string.match(a.Body,"-") then
				return;
			end
			authorized = true;

		end
	end)

	repeat task.wait() until authorized;
end
pcall(function()
	for i,v in next, getconnections(game:GetService("ScriptContext").Error) do
		v:Disable()
	end
end)
pcall(function()
	setfpscap(900)
	task.wait(2)
end)
--iris instance protect
pcall(function()
	LPH_NO_VIRTUALIZE(function()
		pcall(function()
			local ProtectedInstances = {};
			local Connections = getconnections or get_connections;
			local HookFunction = HookFunction or hookfunction or hook_function or detour_function;
			local GetNCMethod = getnamecallmethod or get_namecall_method;
			local CheckCaller = checkcaller or check_caller;
			local GetRawMT = get_raw_metatable or getrawmetatable or getraw_metatable;

			if not (HookFunction  and GetNCMethod and CheckCaller and Connections) then
				game:GetService("Players").LocalPlayer:Kick("failed loading irisprotectinstance to prevent fly bodyvelocity bans")
			end
			local function HookMetaMethod(Object, MetaMethod, Function)
				return HookFunction(GetRawMT(Object)[MetaMethod], Function);
			end 

			local TblDataCache = {};
			local FindDataCache = {};
			local PropertyChangedData = {};
			local InstanceConnections = {};
			local NameCall, NewIndex;

			local EventMethods = {
				"ChildAdded",
				"ChildRemoved",
				"DescendantRemoving",
				"DescendantAdded",
				"childAdded",
				"childRemoved",
				"descendantRemoving",
				"descendantAdded",
			}
			local TableInstanceMethods = {
				GetChildren = game.GetChildren,
				GetDescendants = game.GetDescendants,
				getChildren = game.getChildren,
				getDescendants = game.getDescendants,
				children = game.children,
			}
			local FindInstanceMethods = {
				FindFirstChild = game.FindFirstChild,
				FindFirstChildWhichIsA = game.FindFirstChildWhichIsA,
				FindFirstChildOfClass = game.FindFirstChildOfClass,
				findFirstChild = game.findFirstChild,
				findFirstChildWhichIsA = game.findFirstChildWhichIsA,
				findFirstChildOfClass = game.findFirstChildOfClass,
			}
			local NameCallMethods = {
				Remove = game.Remove;
				Destroy = game.Destroy;
				remove = game.remove;
				destroy = game.destroy;
			}

			for MethodName, MethodFunction in next, TableInstanceMethods do
				TblDataCache[MethodName] = HookFunction(MethodFunction, function(...)
					if not CheckCaller() then
						local ReturnedTable = TblDataCache[MethodName](...);

						if ReturnedTable then
							table.foreach(ReturnedTable, function(_, Inst)
								if table.find(ProtectedInstances, Inst) then
									table.remove(ReturnedTable, _);
								end
							end)

							return ReturnedTable;
						end
					end

					return TblDataCache[MethodName](...);
				end)
			end

			for MethodName, MethodFunction in next, FindInstanceMethods do
				FindDataCache[MethodName] = HookFunction(MethodFunction, function(...)
					if not CheckCaller() then
						local FindResult = FindDataCache[MethodName](...);

						if table.find(ProtectedInstances, FindResult) then
							FindResult = nil
						end
						for _, Object in next, ProtectedInstances do
							if Object == FindResult then
								FindResult = nil
							end
						end
					end
					return FindDataCache[MethodName](...);
				end)
			end

			local function GetParents(Object)
				local Parents = { Object.Parent };

				local CurrentParent = Object.Parent;

				while CurrentParent ~= game and CurrentParent ~= nil do
					CurrentParent = CurrentParent.Parent;
					table.insert(Parents, CurrentParent)
				end

				return Parents;
			end

			NameCall = HookMetaMethod(game, "__namecall", function(...)
				if not CheckCaller() then
					local ReturnedData = NameCall(...);
					local NCMethod = GetNCMethod();
					local self, Args = ...;

					if typeof(self) ~= "Instance" then return ReturnedData end
					if not ReturnedData then return nil; end;

					if TableInstanceMethods[NCMethod] then
						if typeof(ReturnedData) ~= "table" then return ReturnedData end;

						table.foreach(ReturnedData, function(_, Inst)
							if table.find(ProtectedInstances, Inst) then
								table.remove(ReturnedData, _);
							end
						end)

						return ReturnedData;
					end

					if FindInstanceMethods[NCMethod] then
						if typeof(ReturnedData) ~= "Instance" then return ReturnedData end;

						if table.find(ProtectedInstances, ReturnedData) then
							return nil;
						end
					end
				elseif CheckCaller() then
					local self, Args = ...;
					local Method = GetNCMethod();

					if NameCallMethods[Method] then
						if typeof(self) ~= "Instance" then return NewIndex(...) end

						if table.find(ProtectedInstances, self) and not PropertyChangedData[self] then
							local Parent = self.Parent;
							InstanceConnections[self] = {}

							if tostring(Parent) ~= "nil" then
								for _, ConnectionType in next, EventMethods do
									for _, Connection in next, Connections(Parent[ConnectionType]) do
										table.insert(InstanceConnections[self], Connection);
										Connection:Disable();
									end
								end
							end
							for _, Connection in next, Connections(game.ItemChanged) do
								table.insert(InstanceConnections[self], Connection);
								Connection:Disable();
							end
							for _, Connection in next, Connections(game.itemChanged) do
								table.insert(InstanceConnections[self], Connection);
								Connection:Disable();
							end
							for _, ParentObject in next, GetParents(self) do
								if tostring(ParentObject) ~= "nil" then
									for _, ConnectionType in next, EventMethods do
										for _, Connection in next, Connections(ParentObject[ConnectionType]) do
											table.insert(InstanceConnections[self], Connection);
											Connection:Disable();
										end
									end
								end
							end

							PropertyChangedData[self] = true;
							self[Method](self);
							PropertyChangedData[self] = false;

							table.foreach(InstanceConnections[self], function(_,Connect) 
								Connect:Enable();
							end)
						end
					end
				end
				return NameCall(...);
			end)
			NewIndex = HookMetaMethod(game , "__newindex", function(...)
				if CheckCaller() then
					local self, Property, Value, UselessArgs = ...

					if typeof(self) ~= "Instance" then return NewIndex(...) end

					if table.find(ProtectedInstances, self) and not PropertyChangedData[self] then
						if rawequal(Property, "Parent") then
							local NewParent = Value;
							local OldParent = self.Parent;
							InstanceConnections[self] = {}

							for _, ConnectionType in next, EventMethods do
								if NewParent and NewParent.Parent ~= nil then
									for _, Connection in next, Connections(NewParent[ConnectionType]) do
										table.insert(InstanceConnections[self], Connection);
										Connection:Disable();
									end
								end
								if OldParent and OldParent ~= nil then
									for _, Connection in next, Connections(OldParent[ConnectionType]) do
										table.insert(InstanceConnections[self], Connection);
										Connection:Disable();
									end
								end
							end

							for _, ParentObject in next, GetParents(self) do
								if ParentObject and ParentObject.Parent ~= nil then
									for _, ConnectionType in next, EventMethods do
										for _, Connection in next, Connections(ParentObject[ConnectionType]) do
											table.insert(InstanceConnections[self], Connection);
											Connection:Disable();
										end
									end
								end
							end

							for _, ParentObject in next, GetParents(NewParent) do
								if ParentObject and ParentObject.Parent ~= nil then
									for _, ConnectionType in next, EventMethods do
										for _, Connection in next, Connections(ParentObject[ConnectionType]) do
											table.insert(InstanceConnections[self], Connection);
											Connection:Disable();
										end
									end
								end
							end

							for _, Connection in next, Connections(game.ItemChanged) do
								table.insert(InstanceConnections[self], Connection);
								Connection:Disable();
							end
							for _, Connection in next, Connections(game.itemChanged) do
								table.insert(InstanceConnections[self], Connection);
								Connection:Disable();
							end

							PropertyChangedData[self] = true;
							self.Parent = NewParent;
							PropertyChangedData[self] = false;


							table.foreach(InstanceConnections[self], function(_,Connect) 
								Connect:Enable();
							end)

						end
					end
				end
				return NewIndex(...)
			end)

			getgenv().ProtectInstance = function(NewInstance)
				table.insert(ProtectedInstances, NewInstance)
			end
			getgenv().UnProtectInstance = function(NewInstance)
				table.remove(ProtectedInstances, table.find(ProtectedInstances, NewInstance));
			end	
		end)
	end)()

end)
LPH_JIT = function(...) return ... end
LPH_NO_UPVALUES = function(...) return ... end
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
							return args[1] == 0.1
						end
					end
				end
				return call(Self,...)
			end))
			local oldnewindex
			oldnewindex = hookmetamethod(game, "__newindex", LPH_NO_UPVALUES(function(self,prop,val)
				if not checkcaller() then
					if self:IsA("Humanoid") then
						if prop == "WalkSpeed" and getgenv().HumMods then
							return oldnewindex(self, prop, getgenv().WS)
						elseif prop == "JumpPower" and getgenv().HumMods then
							return oldnewindex(self, prop, getgenv().JP)
						elseif prop == "WalkSpeed" and val < 16 and getgenv().NoStun then
							return oldnewindex(self, prop, 16)
						end
						oldnewindex(self,prop,val)
					end
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
					if self.Name == "Atmosphere" and self.Parent.Name == "Lighting" and getgenv().NoFog then
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
xpcall(function()
	repeat wait() until game:IsLoaded();
	local Registry = {};
	local RegistryMap = {};
	local KillBrickFolder = Instance.new("Folder",game:GetService("CoreGui"));
	KillBrickFolder.Name = "KillBricks"
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
	local lp = game:GetService("Players").LocalPlayer;
	local Typing = false;
	local uis = game:GetService("UserInputService")
	local bv;
	uis.TextBoxFocused:Connect(function()
		pcall(function() Typing = true end)
	end)

	uis.TextBoxFocusReleased:Connect(function()
		pcall(function() Typing = false end)
	end)	
	local HttpService = game:GetService("HttpService")
	if not getgenv().ProtectInstance then
		lplr:Kick("We are sorry but executor is not supported: " .. identifyexecutor())
	end
	function randomChance(percent)
		return percent >= math.random(1, 100)
	end
	function getmobname(v)
		return string.sub(string.gsub(string.gsub(v.Name,"%d+",""),"_"," "),2,#string.gsub(string.gsub(v.Name,"%d+",""),"_"," "))
	end
	pcall(function()
		pcall(function()
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
	end)
	getgenv().MobToggleds = false
	local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/MimiTest2/ILOVEROGUELINEAGEANDDEEPWOKEN/main/m.py"))() --you can go into the github link and copy all of it and modify it for yourself.
	local _, esplib = pcall(loadstring(game:HttpGet(("https://raw.githubusercontent.com/MimiTest2/ILOVEROGUELINEAGEANDDEEPWOKEN/main/ambatukamsocks.lua"),true)))
	local Players = game:GetService("Players")
	local function onPlayerAdded(player)
		pcall(function()    
			local suc,err = pcall(function() 
				repeat task.wait() until player.Parent == Players;
				if player:GetRankInGroup(5212858) > 0 or player:GetRankInGroup(4556484) > 0 or player:GetRankInGroup(15326583) > 0 then -- dont remove 15326583
					task.spawn(function() xpcall(function()
						local soundy = Instance.new("Sound", game:GetService("CoreGui"))
						soundy.SoundId = "rbxassetid://247824088"
						soundy.PlaybackSpeed = 1
						soundy.Playing = true
						soundy.Volume = 5
						task.wait(3)
						soundy:Remove()
					end,warn) end)
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
	end
	local keypressed = false;
	local Stats = game:GetService("Stats")
	local lplr = Players.LocalPlayer
	local FrameRateManager = Stats and Stats:FindFirstChild("FrameRateManager")
	local RenderAverage = FrameRateManager and FrameRateManager:FindFirstChild("RenderAverage")

	SetCFrame = function(cf)
		lplr.Character:PivotTo(cf)
	end
	GetCFrame = function(plr)
		return plr.Character:GetPivot()
	end
	AddCFrame = function(cf)
		lplr.Character:PivotTo(lplr.Character:GetPivot():GetCFrame() + cf)
	end
	GetHum = function(plr)
		local hum = plr.Character:FindFirstChildOfClass("Humanoid") or plr:FindFirstChildOfClass("Humanoid")
		return hum
	end
	GetRoot = function(plr)
		local hum = plr.Character:FindFirstChildOfClass("Humanoid") or plr:FindFirstChildOfClass("Humanoid")
		return hum.RootPart or plr.Character.PrimaryPart
	end
	function GetFramerate()
		return 1000 / RenderAverage:GetValue()
	end
	local RunService = game:GetService"RunService"
	local Window = Library:CreateWindow("project rain: deepwoken", Vector2.new(500, 600), Enum.KeyCode.RightControl) --you can change your UI keybind
	local MoveTab = Window:CreateTab("Deepwoken")
	local visualstab = Window:CreateTab("ESP")
	local CombatSection = MoveTab:CreateSector("Combat Section", "left")
	local MovementSection = MoveTab:CreateSector("Movement Section", "left")  --you can  change the section code, for example "testsection" can be changed to "FunnyCoolSection" etc.
	local RiskySection = MoveTab:CreateSector("Miscellaneous","right")
	local speedconnection;
	local flightconnection;
	local animconnection;
	local koconnection;
	local autolootconnection;
	local nearbyconnection;
	local infjumpconnection;
	local streamermodeconnection;
	local nofogconnection;
	local cancollideparts = {}
	local function FireSignalFunc(button)
		for i,v in pairs(getconnections(button.MouseButton1Click)) do
			v:Fire()
		end
	end
	game:GetService("UserInputService").InputBegan:Connect(function(k,t)
		pcall(function() if Library.flags["Auto Sprint"] and not t and k.KeyCode == Enum.KeyCode.W and not keypressed then
				keypressed = true;
				task.wait()
				keyrelease(0x57)
				task.wait()
				keypress(0x57)
				task.wait(0.07)
				keypressed = false;
			end end)
	end)
	local autopickup = LPH_JIT(function()
		pcall(function()
			if lplr.PlayerGui:FindFirstChild("ChoicePrompt") then
				for i, v in pairs(lplr.PlayerGui:FindFirstChild("ChoicePrompt").ChoiceFrame.Options:GetChildren()) do
					pcall(function()
						if v:IsA("TextButton") then
							FireSignalFunc(v)
						end
					end)
				end
			end
		end)
	end)
	local streamermode = LPH_JIT(function()
		pcall(function()
			lp.PlayerGui.LeaderboardGui.MainFrame.ScrollingFrame.Visible = false;
			lp.PlayerGui.BackpackGui.JournalFrame.Visible = false;
			for i, v in pairs(lp.PlayerGui.WorldInfo.InfoFrame:GetDescendants()) do
				if v.Name == "ServerHelp" then
					v.Visible = false;
				end

				if v.Parent.Name == "HelpFrame" or v.Parent.Name == "ServerTitle" then
					continue;
				end
				if v.ClassName == "TextLabel" then
					v.Transparency = 1;
					v.TextTransparency = 1;
					v.BackgroundTransparency = 1;
					v.Visible = false;
				end
				if v.ClassName == "ImageLabel" then
					v.ImageTransparency = 1;
				end
			end
		end)
	end)
	local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
	Indicator = Instance.new("TextLabel", ScreenGui)
	Indicator.AnchorPoint = Vector2.new(0.5, 0.5)
	Indicator.Position = UDim2.new(0.5, 0, 0.25, 0)
	Indicator.Size = UDim2.new(0, 200, 0, 50)
	Indicator.BackgroundTransparency = 1
	Indicator.TextScaled = true
	Indicator.TextStrokeTransparency = 0
	Indicator.TextColor3 = Color3.new(0, 0, 0)
	Indicator.TextStrokeColor3 = Color3.new(1, 1, 1)
	Indicator.Text = "No Players are nearby!"
	Indicator.Visible = false;
	local function GetClosest()
		local Character = game:GetService("Players").LocalPlayer.Character
		if not (Character) then return end

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
	local nearby = function()
		pcall(function()
			local closest = GetClosest();
			if closest ~= nil then
				Indicator.Text = closest.Name .. " Is nearby!"
			else
				Indicator.Text = " No One Is nearby!"
			end
		end)
	end
	local noclip = LPH_JIT(function()
		pcall(function()
			for i, v in pairs(lplr.Character:GetChildren()) do
				pcall(function()
					if v.CanCollide == true then
						v.CanCollide = false
						cancollideparts[v] = true
					end
				end)
			end
		end)
	end)
	lplr:GetMouse().Button1Down:Connect(function()
		pcall(function()
			math.randomseed(tick())
			if Library.flags["Auto Feint"] and randomChance(Library.flags["Feint Chance"]) then
				task.wait(0.2)
				if isrbxactive() then
					mouse2click()
				end
			end
		end)
	end)
	local players = {};
	pcall(function()
		for i, v in pairs(workspace.Live:GetChildren()) do
			task.spawn(function() xpcall(function()
					v:WaitForChild("HumanoidRootPart",9e9)
					players[v] = v;
				end,print) end)
		end
		workspace.Live.ChildAdded:Connect(function(v)
			task.spawn(function() xpcall(function()
					v:WaitForChild("HumanoidRootPart",9e9)
					players[v] = v;
				end,print) end)
		end)
		workspace.Live.ChildRemoved:Connect(function(v)
			task.spawn(function() xpcall(function()
					players[v] = nil
				end,print) end)
		end)
	end)
	local pingadjust = 0;
	local cansendapnotirn = true;
	local function IsLooking(A, B, FOV)
		-- // Default
		FOV = FOV or math.rad(85)

		-- // Get the angle between A and B
		local Angle = math.acos(A.Unit:Dot(B.Unit))
		-- // Return if within FOV
		return Angle < FOV
	end
	game:GetService("RunService").Heartbeat:Connect(LPH_JIT(function()
		pcall(function() 
			if Library.flags["Auto Parry"] then
				for i, player in pairs(players) do
					if player and player.Name ~= lplr.Name  and player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid")  and (lplr.Character:WaitForChild("HumanoidRootPart").Position - player.HumanoidRootPart.Position).Magnitude <= 25  then
						--start player auto parry
						if player.RightHand:FindFirstChild("HandWeapon") then
							local swingspeed = player.RightHand.HandWeapon.Stats.SwingSpeed.Value
							local trail = player.RightHand.HandWeapon:FindFirstChild("WeaponTrail")
							--check if attacking then parry
							if Library.flags["Auto Ping Adjustment"] then
								if game:GetService("Stats"):WaitForChild("PerformanceStats"):WaitForChild("Ping"):GetValue() > 130 then
									pingadjust = 0+(game:GetService("Stats"):WaitForChild("PerformanceStats"):WaitForChild("Ping"):GetValue()/130);
								else
									pingadjust = -0.1;
								end
								pingadjust += Library.flags["Ping Adjustment"];
							end
							if trail.Enabled == true then
								local val = ((0.325/swingspeed)/(6+(pingadjust+0.025)));
								task.wait(val-(val/4))
								local bool = false;
								if Library.flags["Facing Only"] then
									bool = IsLooking(GetRoot(lplr).CFrame.LookVector, player:FindFirstChild("HumanoidRootPart").CFrame.LookVector,Library.flags["FOV (Facing Only)"]);
								else
									bool = true;
								end
								if bool then
									task.wait(Library.flags["Delay"]/1000);
									if player.RightHand.HandWeapon:FindFirstChild("Requirements") and player.RightHand.HandWeapon:FindFirstChild("Requirements"):FindFirstChild("TotalWeaponHeavy") then
										task.wait(Library.flags["Extra Heavy Delay"]/1000)
									end
									if not Typing and isrbxactive() and trail.Enabled == true and (lplr.Character:WaitForChild("RightHand").Position - player.RightHand.Position).Magnitude <= (player.RightHand.HandWeapon.Stats.Length.Value) then
										keypress(0x46)
										task.wait(0.05)
										keyrelease(0x46)
										if Library.flags["Auto Parry Debug"] and cansendapnotirn then task.spawn(function() xpcall(function()
													Notify("[Pressed F] Ping Adjust: " .. tostring(pingadjust) .. " Swing Speed: " .. swingspeed .. " Time waited: " .. val+(Library.flags["Delay"]/1000)+0.05 .. " Ping: " .. game:GetService("Stats"):WaitForChild("PerformanceStats"):WaitForChild("Ping"):GetValue())
													cansendapnotirn = false;
													repeat task.wait() until not trail.Enabled or player == nil
													task.wait(0.65)
													cansendapnotirn = true;
												end,print) end) end
									end
								end
								repeat task.wait() until not trail.Enabled or player == nil
							end
						end
					end
				end
			end
		end)
	end))
	local noanimations = LPH_JIT(function()
		pcall(function()
			local Humanoid = GetHum(lplr)
			local ActiveTracks = Humanoid:GetPlayingAnimationTracks()
			for _,v in pairs(ActiveTracks) do
				v:Stop()
			end
		end)
	end)
	local speed = LPH_JIT(function()
		pcall(function()
			local hum = GetHum(lplr)
			local root = GetRoot(lplr)

			if hum and root and not getgenv().Flight then
				root.Velocity *= Vector3.new(0,1,0)
				if hum.MoveDirection.Magnitude > 0 then
					root.Velocity += hum.MoveDirection.Unit*Library.flags["Walkspeed"]
				end
			end
		end)
	end)
	local infinitejump = LPH_JIT(function()
		pcall(function()
			if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
				GetRoot(lplr).Velocity *= Vector3.new(1,0,1)
				GetRoot(lplr).Velocity += Vector3.new(0,Library.flags["Jump Power"],0)
			end
		end)
	end)
	local flight = LPH_JIT(function()
		pcall(function()
			local y = workspace.CurrentCamera.CFrame.LookVector.Unit.Y*Library.flags["Flight Speed"]
			bv.Velocity = Vector3.new()
			if GetHum(lp).MoveDirection.Magnitude > 0 then
				local travel = Vector3.new(0,0,0)
				local looking = (workspace.CurrentCamera.CFrame.lookVector.Unit)*Library.flags["Flight Speed"];
				if uis:IsKeyDown(Enum.KeyCode.W) then
					travel += looking;
				end
				if uis:IsKeyDown(Enum.KeyCode.S) then
					travel -= looking;
				end
				if uis:IsKeyDown(Enum.KeyCode.D) then
					travel += (workspace.CurrentCamera.CFrame.RightVector.Unit)*Library.flags["Flight Speed"];
				end
				if uis:IsKeyDown(Enum.KeyCode.A) then
					travel -= (workspace.CurrentCamera.CFrame.RightVector.Unit)*Library.flags["Flight Speed"];
				end
				bv.Velocity = travel.Unit * Library.flags["Flight Speed"];
			end
			bv.MaxForce = Vector3.new(9e9,9e9,9e9)
		end)
	end)
	local NoclipBind = MovementSection:AddToggle("Noclip", false, function(e)
		pcall(function()
			if e then
				noclipconnection = RunService.Stepped:Connect(noclip)
			else
				if noclipconnection ~= nil then
					noclipconnection:Disconnect()
					pcall(function()
						for i, v in pairs(lplr.Character:GetChildren()) do
							if cancollideparts[v] then
								pcall(function()
									v.CanCollide = true
								end)
							end
						end
					end)
				end

			end
		end)
	end)
	NoclipBind:AddKeybind()
	RiskySection:AddToggle("Auto Loot", false, function(e)
		pcall(function()
			if e then
				autolootconnection = RunService.RenderStepped:Connect(autopickup)
			else
				if autolootconnection ~= nil then
					autolootconnection:Disconnect()
				end
			end
		end)
	end)
	RiskySection:AddToggle("Player Nearby Indicator", false, function(e)
		pcall(function()
			Indicator.Visible = e
			if e then
				nearbyconnection = RunService.RenderStepped:Connect(nearby)
			else
				if nearbyconnection ~= nil then
					nearbyconnection:Disconnect()
				end
			end
		end)
	end)
	local SpeedBind = MovementSection:AddToggle("Speed", false, function(e)
		pcall(function()
			if e then
				speedconnection = RunService.RenderStepped:Connect(speed)
			else
				if speedconnection ~= nil then
					speedconnection:Disconnect()
				end
			end
		end)
	end)
	SpeedBind:AddKeybind()
	MovementSection:AddSlider("Walkspeed", 0, 150, 250, 1, function(State)

	end)

	MovementSection:AddButton("Insta Reset", function()
		pcall(function()
			GetHum(lp):ChangeState(Enum.HumanoidStateType.Dead)
		end)
	end)
	RiskySection:AddToggle("No Kill Bricks", false, function(enabled)
		pcall(function()
			if enabled then
				pcall(function()
					for i, v in pairs(workspace.Layer2Floor1:GetChildren()) do
						if v.Name == "SuperWall" then
							v.CanTouch = false;
						end
					end
				end)
				pcall(function()
					for i, v in pairs(workspace:GetChildren()) do
						if v.Name == "KillPlane" or v.Name == "ChasmBrick" then
							v.Parent = game:GetService("CoreGui").KillBricks;
						end
					end
				end)
			else
				pcall(function()
					for i, v in pairs(workspace.Layer2Floor1:GetChildren()) do
						if v.Name == "SuperWall" then
							v.CanTouch = true;
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
	RiskySection:AddButton("Low Graphics (IRREVERSIBLE)", function()
		LPH_JIT(function() pcall(function()
				settings().Rendering.QualityLevel = "Level01"
				local index = 0;
				local function decreaseGraphics()
					for i, v in pairs(workspace:GetDescendants()) do
						if v:IsA("Decal") then 
							v.Transparency = 1
						elseif v:IsA("BasePart") then
							v.Reflectance = 0
							v.Material = "Plastic"
						end
						index += 1;
						if index == 1000 then
							index = 0;
							task.wait()
						end
					end
				end
				decreaseGraphics()
				workspace.DescendantAdded:Connect(function(v)
					pcall(function()
						if v:IsA("Decal") then 
							v.Transparency = 1
						elseif v:IsA("BasePart") then
							v.Reflectance = 0
							v.Material = "Plastic"
						end
					end)
				end)
			end) end)
	end)

	local loadconfig = RiskySection:AddButton("Load Config",function(e)
		pcall(function()  
			local fixed = HttpService:JSONDecode(readfile("config.txt"))
			for i, v in pairs(fixed) do
				if string.match(tostring(v),"Enum.KeyCode.") then
					fixed[i] = Enum.KeyCode[string.split(tostring(v),"Enum.KeyCode.")[2]]
				elseif v == "false" then
					fixed[i] = false
				elseif v == "true" then
					fixed[i] = true;
				elseif typeof(v) == "table" then
					if typeof(v[1]) == "number" then
						fixed[i] = Color3.new(v[1], v[2], v[3])
					end
				end
			end
			Library.flags = fixed
			for i,v in pairs(Library.items) do
				pcall(function()
					v:Set(Library.flags[v.flag])
				end)
			end
		end)
	end)
	RiskySection:AddButton("Server Hop", function()
		pcall(function()
			math.randomseed(os.clock())
			local plrs = Players:GetChildren()
			local lplr = Players.LocalPlayer
			local targetPlayer
			repeat task.wait()
				targetPlayer = plrs[math.random(1,#plrs)]
				if targetPlayer == lplr or targetPlayer:IsFriendsWith(lplr.UserId) then targetPlayer = nil end
			until targetPlayer
			game.StarterGui:SetCore("PromptBlockPlayer", targetPlayer)
			game:GetService("CoreGui").RobloxGui:WaitForChild'PromptDialog':WaitForChild'ContainerFrame':WaitForChild'ConfirmButton'.MouseButton1Click:Connect(function()
				pcall(function()
					lplr:Kick("Server Hopping...")
					task.wait()
					game:GetService'TeleportService':Teleport(game.PlaceId)
				end)
			end)
		end)
	end)
	local saveconfig = RiskySection:AddButton("Save Config",function()
		pcall(function()
			local flags = Library.flags
			for i, v in pairs(flags) do
				if typeof(v) == "Color3" then
					flags[i] = {v.R,v.G,v.B}
				else
					flags[i] = tostring(v)
				end
			end
			local e = HttpService:JSONEncode(flags)
			writefile("config.txt",e)
		end)
	end)
	local FlyBind = MovementSection:AddToggle("Flight", false, function(e)
		pcall(function()
			getgenv().Flight = e
			if e then
				bv = Instance.new("BodyVelocity")
				getgenv().ProtectInstance(bv);
				bv.Parent = lplr.Character.PrimaryPart
				bv.MaxForce = Vector3.new(4000000, 4000000, 4000000)
				bv.velocity = Vector3.new(0,0,0)
				flightconnection = RunService.RenderStepped:Connect(flight)
			else
				bv:Destroy()
				bv = nil;

				if flightconnection ~= nil then
					flightconnection:Disconnect()
				end
			end
		end)
	end)

	FlyBind:AddKeybind()
	MovementSection:AddSlider("Flight Speed", 0, 150, 250, 1, function(State)

	end)
	local InfiniteJumps = MovementSection:AddToggle("Infinite Jump", false, function(e)
		pcall(function()
			if e then
				infjumpconnection = RunService.RenderStepped:Connect(infinitejump)
			else
				if infjumpconnection ~= nil then
					infjumpconnection:Disconnect()
				end
			end
		end)
	end)
	MovementSection:AddSlider("Jump Power", 0, 50, 750, 1, function(State)

	end)
	InfiniteJumps:AddKeybind()
	MovementSection:AddToggle("Agility Spoofer", false, function(e) end)
	MovementSection:AddSlider("Agility", 0, 35, 450, 1, function(State)
		pcall(function()
			if Library.flags["Agility Spoofer"] then
				lplr.Character.Agility.Value = State
			end
		end)    
	end)
	MovementSection:AddToggle("Auto Sprint", false, function() end)
	CombatSection:AddToggle("Auto Feint", false, function() end)
	CombatSection:AddToggle("Auto Parry", false, function() end)
	CombatSection:AddToggle("Facing Only", true, function() end);
	CombatSection:AddToggle("Auto Parry Debug", false, function() end)
	CombatSection:AddToggle("Auto Ping Adjustment", true, function(e) end)
	CombatSection:AddSlider("Delay", 0, 150, 500, 1)
	CombatSection:AddSlider("Extra Heavy Delay", 0, 100, 500, 1)
	CombatSection:AddSlider("Ping Adjustment", -5, 0, 10, 2, function(e) end)
	CombatSection:AddSlider("Feint Chance", 0, 25, 100, 1)
	CombatSection:AddSlider("FOV (Facing Only)", 0, 80, 180, 1)
	CombatSection:AddToggle("No Stun", false, function(e) getgenv().NoStun = e; end)

	RiskySection:AddToggle("Full Bright", false ,function(e)
		pcall(function()
			getgenv().FullBright = e;
		end)
	end)

	RiskySection:AddToggle("No Fog", false ,function(e)
		pcall(function()
			getgenv().NoFog = e;
		end)
	end)
	local streamermode = RiskySection:AddToggle("Streamer Mode", false, function(e)
		xpcall(function()
			if not e then
				if streamermodeconnection ~= nil then
					streamermodeconnection:Disconnect()
					pcall(function()
						local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
						playerGui.LeaderboardGui.MainFrame.ScrollingFrame.Visible = true;
						for i, v in pairs(playerGui.WorldInfo.InfoFrame:GetDescendants()) do
							if v.Name == "ServerHelp" then
								v.Visible = true;
							end
							if v.Parent.Name == "HelpFrame" or v.Parent.Name == "ServerTitle" then
								continue;
							end
							if v.ClassName == "TextLabel" then
								if v.Name == "Character" or v.Name == "VersionTitle" or v.Name == "AgeTitle" or v.Name == "ServerTitle" or v.Name == "Realm" then
									v.Transparency = 0
									v.Visible = true;
								else
									v.Visible = true;
									v.Transparency = 0.2
								end
								v.BackgroundTransparency = 1;

							end
							if v.ClassName == "ImageLabel" then
								v.ImageTransparency = 0;
							end
						end
					end)
				end
			else
				streamermodeconnection = RunService.RenderStepped:Connect(streamermode)
			end
		end,print)
	end)
	local Nofall = RiskySection:AddToggle("Nofall", false, function(e)
		getgenv().Nofall = e
	end)
	function getallequipedtools()
		local tbl = {}
		for i, v in pairs(lplr.Character:GetChildren()) do
			if v:IsA("Tool") then
				table.insert(tbl,v)
			end
		end
		return tbl
	end
	local kownertick = false;
	function kowner()
		pcall(function()
			if lplr.Character.Torso:FindFirstChild("RagdollAttach") and lplr.Character.Humanoid.Health < 10 then
				if #getallequipedtools() > 1 then
					lplr.Character.Humanoid:UnequipTools()
				end
				if lplr.Backpack:FindFirstChild("Weapon") then
					lplr.Backpack["Weapon"].Parent = lplr.Character
				else
					lplr.Character:FindFirstChild("Weapon").Parent = lplr.Backpack
				end
				kownertick = true
			else
				if kownertick then
					kownertick = false
					lplr.Character.Humanoid:UnequipTools()
					if lplr.Backpack:FindFirstChild("Weapon") then
						lplr.Backpack["Weapon"].Parent = lplr.Character
					end
					task.wait(0.5)
					if lplr.Backpack:FindFirstChild("Weapon") then
						lplr.Backpack["Weapon"].Parent = lplr.Character
					else
						lplr.Character:FindFirstChild("Weapon").Parent = lplr.Backpack
					end
					task.wait(0.5)
					if lplr.Backpack:FindFirstChild("Weapon") then
						lplr.Backpack["Weapon"].Parent = lplr.Character
					end
				end
			end
		end)
	end

	local KnockedOwnership = RiskySection:AddToggle("Knocked Ownership",false,function(e)
		pcall(function()
			if e then
				koconnection = RunService.RenderStepped:Connect(kowner)
			else
				if koconnection ~= nil then
					koconnection:Disconnect()
					kownertick = false;
				end
			end
		end)
	end)

	local NoAnims = RiskySection:AddToggle("No Anims",false,function(e)
		pcall(function()
			if e then
				animconnection = RunService.RenderStepped:Connect(noanimations)
			else
				if animconnection ~= nil then
					animconnection:Disconnect()
				end
			end
		end)
	end)
	NoAnims:AddKeybind()


	--SettingsTab:CreateConfigSystem("right") --this is the config system

	--Attach To Back;
	local TweenService = game:GetService("TweenService")
	local function moveto(obj, speed)
		local info = TweenInfo.new(((lplr.Character.HumanoidRootPart.Position - obj.Position).Magnitude)/ speed,Enum.EasingStyle.Linear)
		local tween = TweenService:Create(lplr.Character.HumanoidRootPart, info, {CFrame = obj})
		tween:Play()
	end
	local function GetClosest()
		local Character = game:GetService("Players").LocalPlayer.Character
		local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
		if not (Character or HumanoidRootPart) then return end

		local TargetDistance = 100
		local Target

		for i,v in ipairs(workspace.Live:GetChildren()) do
			if string.match(v.Name,".") and v ~= lplr.Character and v:FindFirstChild("HumanoidRootPart") then
				local TargetHRP = v.HumanoidRootPart
				local mag = (HumanoidRootPart.Position - TargetHRP.Position).magnitude
				if mag < TargetDistance then
					TargetDistance = mag
					Target = v
				end
			end
		end

		return Target
	end
	local attachtobackconnection;
	RiskySection:AddSlider("Attach To Back Offset", -25, 0, 25, 1, function(State)

	end)

	RiskySection:AddSlider("Attach To Back Speed", 5, 150, 200, 1, function(State)

	end)
	RiskySection:AddSlider("Attach To Back Height", -25, 0, 25, 1, function(State)

	end) 
	local attachtoback = LPH_JIT(function()
		local suc, err = pcall(function()
			if target ~= nil and workspace.Live:FindFirstChild(target.Name) and workspace.Live:FindFirstChild(target.Name).Torso then
				moveto(target.Torso.CFrame * CFrame.new(0,Library.flags["Attach To Back Height"],Library.flags["Attach To Back Offset"]),Library.flags["Attach To Back Speed"])
			else
				target = nil;
			end
		end)
	end)
	local AttachToBackBind = RiskySection:AddToggle("Attach To Back", false, function(e)
		pcall(function()

			if e then
				target = GetClosest()
				attachtobackconnection = RunService.RenderStepped:Connect(attachtoback)
			else
				if attachtobackconnection ~= nil then
					attachtobackconnection:Disconnect()
				end
			end
		end)
	end)
	LPH_NO_VIRTUALIZE(function()
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
				local suc, err = pcall(function() if drop and workspace.Live[drop.Name] and drop.Humanoid and drop.HumanoidRootPart then
						local drop_pos, drop_onscreen = camera:WorldToViewportPoint(drop.HumanoidRootPart.Position)
						local humanoid = drop.Humanoid
						if Library.flags["Mobs"] and drop_onscreen  then
							dropesp.Position = Vector2.new(drop_pos.X, drop_pos.Y)
							dropesp.Text = "[" .. drop.Name .. "]" .. " [" .. math.round(humanoid.Health) .. "/" .. math.round(humanoid.MaxHealth) .. "]"
							dropesp.Visible = true
						else 
							dropesp.Visible = false
						end
					else
						dropesp.Visible = false
						dropesp:Remove()
						renderstepped:Disconnect()
					end end)
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
		AttachToBackBind:AddKeybind()
		local espsec = visualstab:CreateSector("ESP","left")
		local esptoggle = espsec:AddToggle("Enabled",true,function(val)
			xpcall(function()
				esplib.options.enabled = val
			end,warn)
		end)
		local mobesptoggle = espsec:AddToggle("Mobs",true, function(val) end)

		local esptextsize = espsec:AddSlider("Text Size",4,18,32,1,function(val)
			xpcall(function()
				esplib.options.fontSize = val
			end,warn)
		end)
		local espdistanceenabled = espsec:AddToggle("Show Distance",true,function(val)
			xpcall(function()
				esplib.options.distance = val
			end,warn)
		end)
		local esparrowstoggle = espsec:AddToggle("Arrows Enabled",false,function(val)
			xpcall(function()
				esplib.options.outOfViewArrows = val
			end,warn)
		end)
		local esparrowssize = espsec:AddSlider("Arrow Size",1,10,48,1,function(val)
			xpcall(function()
				esplib.options.outOfViewArrowsSize = val
			end,warn)
		end)
		local esptracers = espsec:AddToggle("Tracers Enabled",true,function(val)
			xpcall(function()
				esplib.options.tracers = val
			end,warn)
		end)
		local esphealthenabled = espsec:AddToggle("Health Bars",true,function(val)
			xpcall(function()
				esplib.options.healthBars = val
			end,warn)
		end)
		local esphealthtexttoggle = espsec:AddToggle("Health Text Enabled",true,function(val)
			xpcall(function()
				esplib.options.healthTextEnabled = val
			end,warn)
		end)
		local esparrowscolor = espsec:AddColorpicker("Arrows Color",Color3.fromRGB(60,255,60),function(val)
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
		end)
	end)()
	esplib:Load()
	LPH_JIT(function()
		pcall(function()
			esplib.options.enabled = true
			esplib.options.maxDistance = 10000
			esplib.options.chams = false
			esplib.options.tracers = true
			esplib.options.tracerOrigin = "Mouse"
			esplib.options.boxes = true
			esplib.options.boxesColor = Color3.fromRGB(60,255,60)
			esplib.options.nameColor = Color3.fromRGB(60,255,60)
			esplib.options.healthText = true
			esplib.options.healthTextColor = Color3.fromRGB(60,255,60)
			esplib.options.distance = true
			esplib.options.distanceColor = Color3.fromRGB(60,255,60)
			esplib.options.fontSize = 18
			esplib.options.healthBarsSize = 8
			esplib.options.healthBarsColor = Color3.fromRGB(115,255,115)
			esplib.options.outOfViewArrows = false
			esplib.options.outOfViewArrowsOutline = false;
			esplib.options.outOfViewArrowsColor = Color3.fromRGB(60,255,60)
			esplib.options.outOfViewArrowsSize = 10
		end)
		local chat_logger = Instance.new("ScreenGui")
		local template_message = Instance.new("TextLabel")
		local lol;
		task.spawn(function()
			pcall(function()
				chat_logger.IgnoreGuiInset = true
				chat_logger.ResetOnSpawn = false
				chat_logger.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				chat_logger.Name = "Lannis [Ragoozer]: hi im real ragoozer Rogue Lineage"
				chat_logger.Parent = game:GetService("CoreGui");

				local frame = Instance.new("ImageLabel")
				frame.Image = "rbxassetid://1327087642"
				frame.ImageTransparency = 0.6499999761581421
				frame.BackgroundColor3 = Color3.new(1, 1, 1)
				frame.BackgroundTransparency = 1
				frame.Position = UDim2.new(0.0766663328, 0, 0.594427288, 0)
				frame.Size = UDim2.new(0.28599999995, 0, 0.34499999, 0)
				frame.Visible = false
				frame.ZIndex = 99999000
				frame.Name = "Frame"
				frame.Parent = chat_logger
				frame.Draggable = true
				frame.Active = true
				frame.Selectable = true
				lol = frame;
				local title = Instance.new("TextLabel")
				title.Font = Enum.Font.Code
				title.Text = "Chat Logger"
				title.TextColor3 = Color3.new(1, 1, 1)
				title.TextSize = 32
				title.TextStrokeTransparency = 0.20000000298023224
				title.BackgroundColor3 = Color3.new(1, 1, 1)
				title.BackgroundTransparency = 1
				title.Size = UDim2.new(1, 0, 0.075000003, 0)
				title.Visible = true
				title.ZIndex = 99999001
				title.Name = "Title"
				title.Parent = frame

				local frame_2 = Instance.new("ScrollingFrame")
				frame_2.CanvasPosition = Vector2.new(0, 99999)
				frame_2.BackgroundColor3 = Color3.new(1, 1, 1)
				frame_2.BackgroundTransparency = 1
				frame_2.Position = UDim2.new(0.0700000003, 0, 0.100000001, 0)
				frame_2.Size = UDim2.new(0.870000005, 0, 0.800000012, 0)
				frame_2.Visible = true
				frame_2.ZIndex = 99999000
				frame_2.Name = "Frame"
				frame_2.Parent = frame

				local uilist_layout = Instance.new("UIListLayout")
				uilist_layout.SortOrder = Enum.SortOrder.LayoutOrder
				uilist_layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
				uilist_layout.Parent = frame_2

				template_message.Font = Enum.Font.Code
				template_message.Text = "Lannis [Ragoozer]: hi im real ragoozer Rogue Lineage"
				template_message.TextColor3 = Color3.new(1, 1, 1)
				template_message.TextScaled = true
				template_message.TextSize = 18
				template_message.TextStrokeTransparency = 0.20000000298023224
				template_message.TextWrapped = true
				template_message.TextXAlignment = Enum.TextXAlignment.Left
				template_message.BackgroundColor3 = Color3.new(1, 1, 1)
				template_message.BackgroundTransparency = 1
				template_message.Position = UDim2.new(0, 0, -0.101166956, 0)
				template_message.Size = UDim2.new(0.949999988, 0, 0.035, 0)
				template_message.Visible = false
				template_message.ZIndex = 99999010
				template_message.RichText = true
				template_message.Name = "TemplateMessage"
				template_message.Parent = chat_logger

				task.spawn(function()
					pcall(function()
						coroutine.resume(coroutine.create(function()
							pcall(function()
								local ChatEvents = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents", math.huge)
								local OnMessageEvent = ChatEvents:WaitForChild("OnMessageDoneFiltering", math.huge)
								if OnMessageEvent:IsA("RemoteEvent") then
									OnMessageEvent.OnClientEvent:Connect(function(data)
										pcall(function()
											if data ~= nil then
												local player = tostring(data.FromSpeaker)
												local message = tostring(data.Message)
												local originalchannel = tostring(data.OriginalChannel)
												if string.find(originalchannel, "To ") then
													message = "/w " .. string.gsub(originalchannel, "To ", "") .. " " .. message
												end
												if originalchannel == "Team" then
													message = "/team " .. message
												end

												local displayname = "?"
												local realplayer = game:GetService("Players")[player];
												local firstname = realplayer:GetAttribute('FirstName') or ""
												local lastname = realplayer:GetAttribute('LastName') or "" 
												displayname = firstname .. " " .. lastname
												frame_2.CanvasPosition = Vector2.new(0, 99999)
												local messagelabel = template_message:Clone()
												game:GetService("Debris"):AddItem(messagelabel,300)
												if realplayer == game:GetService("Players").LocalPlayer then
													messagelabel.Text = "<b> ["..tostring(BrickColor.random()).."] ["..tostring(BrickColor.random()).."]:</b> "..message
												else
													messagelabel.Text = "<b> ["..displayname.."] ["..realplayer.Name.."]:</b> "..message
												end
												messagelabel.Visible = true
												messagelabel.Parent = frame_2
											end
										end)
									end)
								end
							end)
						end))
					end)
				end)
			end)
		end)
		RiskySection:AddToggle("Chat Logger", false, function(e)
			lol.Visible = e;
		end)
	end)()
	Notify("Project Rain V3 Has been loaded!")
	Notify("Please log if you see any notifications with moderator detected.",60)
	Notify("Loaded in: " .. math.round((tick()-starttime)*5)/5 .. "s")
end,warn)
