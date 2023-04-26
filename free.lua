--PROJECT RAIN OPEN SOURCE EDITION. FUCK YOU CITAM marshadow#2336 dubs
--PROJECT RAIN DB: https://pastebin.com/raw/7Tt1abfj

pcall(function()
	task.wait(2.5)
	setfpscap(900)
	task.wait(2.5)
end)
LPH_JIT = function(...) return ... end
LPH_NO_UPVALUES = function(...) return ... end
pcall(function()
	LPH_NO_VIRTUALIZE(function()
		pcall(function()
			local call
			call = hookmetamethod(game,'__namecall', function(Self,...)
				local args = {...}
				if not checkcaller() then
					local getname = getnamecallmethod()
					if getname == "FindFirstChild" and args[1] == "BodyGyro" and getgenv().Flight then
						return nil;
					end
					if getname == "FindFirstChild" and args[1] == "BodyVelocity" and getgenv().Flight then
						return nil;
					end
					if getgenv().Nofall then
						if tostring(getname) == "FireServer" and getcallingscript().Name == "WorldClient" and type(args[1]) == "number" and type(args[2]) == "boolean" then
							return args[1] == 0.1
						end
					end
				end
				return call(Self,...)
			end)
			local oldnewindex
			oldnewindex = hookmetamethod(game, "__newindex", function(self,prop,val)
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
			end)
		end) 
	end)()
end)
	pcall(function()
		pcall(function()
			setfpscap(900)
		end)
		local UserInputService = game:GetService("UserInputService")
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
			 function mysplit (inputstr, sep)
				if sep == nil then
						sep = "%s"
				end
				local t={}
				for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
						table.insert(t, str)
				end
				return t
			end
			 function decode(given)
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
		local KillBrickFolder = Instance.new("Folder",game.CoreGui);
		KillBrickFolder.Name = "KillBricks"
		local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
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
		local starttime = tick();
		function sendnoti(Title,Text,Duration)
			game:GetService"StarterGui":SetCore("SendNotification", {
				Title = Title, 
				Text = Text, 
				Duration = Duration,
			})
		end
		if not game:GetService("Players").LocalPlayer.Character or not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			sendnoti("Waiting...", "Waiting for the game to load...", 10)
			repeat task.wait() until game:GetService("Players").LocalPlayer.Character;
			repeat task.wait() until game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
		end
		local connections = {
			flight = nil,
			infjump = nil,
			nofog = nil,
			noclip = nil,
			autoloot = nil,
			attachtoback = nil,
			knockedownership = nil,
			streamermode = nil,
			nearby = nil,
			iceyfly = nil,
			hpbar = nil,
		}
		function getmobname(v)
			return string.sub(string.gsub(string.gsub(v.Name,"%d+",""),"_"," "),2,#string.gsub(string.gsub(v.Name,"%d+",""),"_"," "))
		end
		local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/MimiTest2/ILOVEROGUELINEAGEANDDEEPWOKEN/main/kanyechangedhislifebutimstillaoldschoolgemini.lua")) or loadstring(game:HttpGet("http://90.206.53.196:1033/uilib")) or loadfile("pepsi.lua");
		pcall(function() library = library(); end)
		local bv;
		local bg;
		local Players = game:GetService"Players"
		local lp = Players.LocalPlayer;
		--click spectate
		pcall(function()
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
		end)
		sendnoti("Loading Character Lib","If script gets stuck here. Please contact mist!", 5);
		local char = {
			SetCFrame = function(cf)
				lp.Character:PivotTo(cf)
			end,
			GetCFrame = function(plr)
				return plr.Character:GetPivot()
			end,
			AddCFrame = function(cf)
				lp.Character:PivotTo(lp.Character:GetPivot():GetCFrame() + cf)
			end,
			GetHum = function(plr)
				local hum = plr.Character:FindFirstChildOfClass("Humanoid") or plr:FindFirstChildOfClass("Humanoid")
				return hum
			end,
			GetRoot = function(plr)
				local hum = plr.Character:FindFirstChildOfClass("Humanoid") or plr:FindFirstChildOfClass("Humanoid")
				return hum.RootPart or plr.Character.PrimaryPart
			end,
		}
		task.spawn(function()
			pcall(function()
				pcall(function()
					sendnoti("Loaded Mod Detector!", "Successfully loaded mod detector! If you see any notification titles with group member. That indicates theres a mod!",13)
				end)
				while task.wait(0.5) do
					pcall(function()
						for _,v in pairs(game:GetService("Players"):GetPlayers()) do
							if v:IsInGroup(5212858) then
								game:GetService("StarterGui"):SetCore("SendNotification", {Title = "GROUP MEMBER", Text = v.Name .. ":" .. v:GetRoleInGroup(5212858), Duration = 1,})
							end
							if v:IsInGroup(4556484) then
								game:GetService("StarterGui"):SetCore("SendNotification", {Title = "GROUP MEMBER", Text = "ROGUE: " .. v.Name .. ":" .. v:GetRoleInGroup(4556484), Duration = 1,})
							end
						end
					end)
				end
			end)
		end)
		sendnoti("Successfully Authorized!", "Thank you for using project rain!",10)
		speed = function()
			pcall(function()
				local hum = char.GetHum(lp)
				local root = char.GetRoot(lp)
	
				if hum and root then
					root.Velocity *= Vector3.new(0,1,0)
					if hum.MoveDirection.Magnitude > 0 then
						root.Velocity += hum.MoveDirection.Unit*library.flags["Walk Speed Speed Speed Speed"]
					end
				end
			end)
		end
		local cancollideparts = {}
		function click(button)
			for i,v in pairs(getconnections(button.MouseButton1Click)) do
				v:Fire()
			end
		end
		icefly = function()
			pcall(function()
				local hum = char.GetHum(lp)
				local root = char.GetRoot(lp)
	
				if hum and root then
					if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
						root.Velocity = Vector3.new(0,300,0);
					else
						root.Velocity = Vector3.new(0,-300,0);
					end
					root.Velocity *= Vector3.new(0,1,0)
					if hum.MoveDirection.Magnitude > 0 then
						root.Velocity += hum.MoveDirection.Unit*library.flags["Flight Speed"]
					end
				end
			end)
		end
		nearby = function()
			pcall(function()
				local closest = GetClosest();
				if closest ~= nil then
					Indicator.Text = closest.Name .. " Is nearby!"
				else
					Indicator.Text = " No One Is nearby!"
				end
			end)
		end
		autoloot = function()
			pcall(function()
				if lp.PlayerGui:FindFirstChild("ChoicePrompt") then
					for i, v in pairs(lp.PlayerGui:FindFirstChild("ChoicePrompt").ChoiceFrame.Options:GetChildren()) do
						pcall(function()
							if v:IsA("TextButton") then
								click(v)
							end
						end)
					end
				end
			end)
		end
		streamermode = function()
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
		end
		nofog = function()
			pcall(function()
				game.Lighting.Atmosphere.Density = 0
			end)
		end
		noclip = function()
			pcall(function()
				for i, v in pairs(lp.Character:GetChildren()) do
					pcall(function()
						if v.CanCollide == true then
							v.CanCollide = false
							cancollideparts[v] = true
						end
					end)
				end
			end)
		end
		flight = function()
			pcall(function()
				local y = workspace.CurrentCamera.CFrame.LookVector.Unit.Y*library.flags["Flight Speed"]
				if library.flags["frtc"] then
					pcall(function()
						bg.CFrame = workspace.CurrentCamera.CFrame
					end)
				end
				bv.Velocity = Vector3.new();
				if char.GetHum(lp).MoveDirection.Magnitude > 0 then
					local travel = Vector3.new(0,0,0)
					local looking = (workspace.CurrentCamera.CFrame.lookVector.Unit)*library.flags["Flight Speed"];
					if UserInputService:IsKeyDown(Enum.KeyCode.W) then
						travel += looking;
					end
					if UserInputService:IsKeyDown(Enum.KeyCode.S) then
						travel -= looking;
					end
					if UserInputService:IsKeyDown(Enum.KeyCode.D) then
						travel += (workspace.CurrentCamera.CFrame.RightVector.Unit)*library.flags["Flight Speed"];
					end
					if UserInputService:IsKeyDown(Enum.KeyCode.A) then
						travel -= (workspace.CurrentCamera.CFrame.RightVector.Unit)*library.flags["Flight Speed"];
					end
					bv.Velocity = travel.Unit * library.flags["Flight Speed"];
				end
				bv.MaxForce = Vector3.new(9e9,9e9,9e9)
			end)
		end
		function getallequipedtools()
			local tbl = {}
			for i, v in pairs(lp.Character:GetChildren()) do
				if v:IsA("Tool") then
					table.insert(tbl,v)
				end
			end
			return tbl
		end
		local kownertick = false;
		function kowner()
			pcall(function()
				if lp.Character.Humanoid.Health < 3 and lp.Character.Torso:FindFirstChild("RagdollAttach") then
					if #getallequipedtools() > 1 then
						lp.Character.Humanoid:UnequipTools()
					end
					if lp.Backpack:FindFirstChild("Weapon") then
						lp.Backpack["Weapon"].Parent = lp.Character
					else
						lp.Character:FindFirstChild("Weapon").Parent = lp.Backpack
					end
					kownertick = true
				else
					if kownertick then
						kownertick = false
						lp.Character.Humanoid:UnequipTools()
						if lp.Backpack:FindFirstChild("Weapon") then
							lp.Backpack["Weapon"].Parent = lp.Character
						end
						task.wait(0.5)
						if lp.Backpack:FindFirstChild("Weapon") then
							lp.Backpack["Weapon"].Parent = lp.Character
						else
							lp.Character:FindFirstChild("Weapon").Parent = lp.Backpack
						end
						task.wait(0.5)
						if lp.Backpack:FindFirstChild("Weapon") then
							lp.Backpack["Weapon"].Parent = lp.Character
						end
					end
				end
			end)
		end
		hpbar = function()
			pcall(function()
				for i, v in pairs(workspace.Live:GetChildren()) do
					pcall(function()
						v.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject
						-- Set health bar display distance to 15 studs
						v.Humanoid.HealthDisplayDistance = 100
						-- Only show health bar when humanoid is damaged
						v.Humanoid.HealthDisplayType = 1
					end)
				end
			end)
		end
		getgenv().WS = 175;
		getgenv().JP = 175;
		
		local ProjectRain = library:CreateWindow({
			Name = "project rain: FREE",
			Themeable = {
				Info = "projectrain.xyz",
				Transparency = 0,
				Visible = false
			}
		})
		
		local GeneralTab = ProjectRain:CreateTab({
			Name = "general"
		})
		local ESPTab = ProjectRain:CreateTab({
			Name = "esp"
		})
		local HumanoidSection = GeneralTab:CreateSection({
			Name = "humanoid"
		})
		local ESPSection = ESPTab:CreateSection({
			Name = "esp"
		})
		local MiscSection = GeneralTab:CreateSection({
			Name = "misc",
			Side = "Left"
		})
		local CombatSection = GeneralTab:CreateSection({
			Name = "combat",
			Side = "Right"
		})
		local MovementSection = GeneralTab:CreateSection({
			Name = "movement",
			Side = "Right"
		})
		local RemovalSection = GeneralTab:CreateSection({
			Name = "removals",
			Side = "Right"
		})
		local FarmingSection = GeneralTab:CreateSection({
			Name = "farming",
			Side = "Right"
		})
		RemovalSection:AddToggle({
			Name = "no stun",
			Flag = "Nostun",
			Callback = function(enabled)
				getgenv().NoStun = enabled;
			end
		})
		RemovalSection:AddToggle({
			Name = "no fall",
			Flag = "Nofall",
			Callback = function(enabled)
				getgenv().Nofall = enabled;
			end
		})
		instantlogkey = Enum.KeyCode.ButtonL3;
		clickdeletekey = Enum.KeyCode.ButtonL3;
		instantlogtomenukey = Enum.KeyCode.ButtonL3;
		game:GetService("UserInputService").InputBegan:Connect(function(key, t)
			pcall(function()
				if key.KeyCode == clickdeletekey and not t then
					local hit = lp:GetMouse().Target;
					if hit:IsA("BasePart") then  
						hit:Destroy()
					end
				end
			end)
		end)
		MiscSection:AddKeybind({
			Name = "click delete",
			Callback = function(val)
				pcall(function()
					task.wait()
					clickdeletekey = val;
				end)
			end
		})
		RemovalSection:AddToggle({
			Name = "full bright",
			Flag = "fb",
			Callback = function(enabled)
				getgenv().FullBright = enabled;
				pcall(function()
					game.Lighting.Brightness = 2
					game.Lighting.ClockTime = 14
					game.Lighting.FogEnd = 100000
					game.Lighting.GlobalShadows = false
					game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
				end)
			end
		})
	
		RemovalSection:AddToggle({
			Name = "no fog",
			Flag = "NoFog",
			Callback = function(enabled)
				getgenv().NoFog = enabled;
				pcall(function()
					if enabled then
						connections.nofog = game:GetService("RunService").RenderStepped:Connect(nofog)
					else
						if connections.nofog then
							kownertick = false;
						end
					end
				end)
			end
		})
		FarmingSection:AddToggle({
			Name = "auto intelligence",
			Flag = "IntelligenceFarm",
			Callback = function(enabled)
				getgenv().INTELLIGENCE = enabled;
				pcall(function()
					while getgenv().INTELLIGENCE do		
						pcall(function()
							repeat task.wait() until lp.PlayerGui:FindFirstChild'ChoicePrompt'
							repeat task.wait() until lp.PlayerGui:FindFirstChild'ChoicePrompt':FindFirstChild'ChoiceFrame'
							local Options = lp.PlayerGui.ChoicePrompt.ChoiceFrame.Options;
							local given = lp.PlayerGui.ChoicePrompt.ChoiceFrame.DescSheet.Desc.Text;
							task.wait(math.random(2.5,3.5))
							local answer = Options:FindFirstChild(tostring(decode(given)))
							click(answer);
							task.wait();
						end)
					end
				end)
			end
		})
		FarmingSection:AddToggle({
			Name = "auto charisma",
			Flag = "CharismaFarm",
			Callback = function(enabled)
				getgenv().CHARISMA = enabled;
				pcall(function()
					while getgenv().CHARISMA do		
						pcall(function()
							repeat task.wait() until lp.PlayerGui:FindFirstChild('SimplePrompt');
							repeat task.wait() until lp.PlayerGui:FindFirstChild('SimplePrompt'):FindFirstChild("Prompt")
							local prompt = lp.PlayerGui:FindFirstChild('SimplePrompt'):FindFirstChild("Prompt")
							task.wait(math.random(2,3.5))
							local whitespace = prompt.Text:find("\n")
							local text = prompt.Text
							if whitespace then
								text = text:sub(whitespace+1):gsub('\'', "")
							else
								text = text:gsub('\'', "")
							end
							Players:Chat(text)
						end)
					end
				end)
			end
		})
		HumanoidSection:AddToggle({
			Name = "humanoid modifier's",
			Flag = "HumMods",
			Keybind = {
				Mode = "toggle" -- Dynamic means to use the 'hold' method, if the user keeps the button pressed for longer than 0.65 seconds; else use toggle method
			},
			Callback = function(enabled)
				pcall(function()
					if HumMods then
						char.GetHum(lp).JumpPower = 50;
					end
				end)
				getgenv().HumMods = enabled;
			end
		})
		MiscSection:AddButton({
			Name = "server hop",
			Callback = function()
				pcall(function()
					math.randomseed(os.clock())
					local plrs = game.Players:GetChildren()
					local lplr = game.Players.LocalPlayer
					local targetPlayer
					repeat task.wait()
						targetPlayer = plrs[math.random(1,#plrs)]
						if targetPlayer == lplr or targetPlayer:IsFriendsWith(lplr.UserId) then targetPlayer = nil end
					until targetPlayer
					game.StarterGui:SetCore("PromptBlockPlayer", targetPlayer)
					game.CoreGui.RobloxGui:WaitForChild'PromptDialog':WaitForChild'ContainerFrame':WaitForChild'ConfirmButton'.MouseButton1Click:Connect(function()
						pcall(function()
							lplr:Kick("Server Hopping...")
							task.wait()
							game:GetService'TeleportService':Teleport(game.PlaceId)
						end)
					end)
				end)
			end
		})
		MiscSection:AddButton({
			Name = "despawn helper",
			Callback = function()
				pcall(function()
					local NetworkAccess = coroutine.create(function()
						pcall(function()
							settings().Physics.AllowSleep = false
							while true do
								pcall(function()
									game:GetService("RunService").RenderStepped:Wait()
									for _, Players in next, game:GetService("Players"):GetChildren() do
										if Players ~= game:GetService("Players").LocalPlayer then
											Players.MaximumSimulationRadius = 0.1
											Players.SimulationRadius = 0
										end
									end
									game:GetService("Players").LocalPlayer.MaximumSimulationRadius = math.pow(math.huge, math.huge)
									game:GetService("Players").LocalPlayer.SimulationRadius = math.huge * math.huge
								end)
							end
						end)
					end)
					coroutine.resume(NetworkAccess)
				end)
			end
		})
		MovementSection:AddToggle({
			Name = "infinite jump",
			Flag = "InfJump",
			Keybind = {
				Mode = "toggle"
			},
			Callback = function(enabled)
				pcall(function()
					if enabled then
						connections.infjump = game:GetService("RunService").RenderStepped:Connect(function()
							pcall(function()
								if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
									char.GetRoot(lp).Velocity *= Vector3.new(1,0,1)
									if not HumMods then
										char.GetRoot(lp).Velocity += Vector3.new(0,50,0)
									else
										char.GetRoot(lp).Velocity += Vector3.new(0,JP,0)
									end
								end
							end)
						end)
					else
						if connections.infjump then
							connections.infjump:Disconnect();
						end
					end
				end)
			end
		})
		MiscSection:AddToggle({
			Name = "player nearby notifier",
			Flag = "Nearby Noti",
			Callback = function(enabled)
				pcall(function()
					Indicator.Visible = enabled;
					if enabled then
						connections.nearby = game:GetService("RunService").RenderStepped:Connect(nearby)
					else
						if connections.nearby then
							kownertick = false;
							connections.nearby:Disconnect();
						end
					end
				end)
			end
		})
		MiscSection:AddToggle({
			Name = "no kill bricks",
			Flag = "No Kill Bricks",
			Callback = function(enabled)
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
									v.Parent = game.CoreGui.KillBricks;
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
			end
		})
		MiscSection:AddToggle({
			Name = "knocked ownership",
			Flag = "knocked ownership",
			Callback = function(enabled)
				pcall(function()
					if enabled then
						connections.knockedownership = game:GetService("RunService").RenderStepped:Connect(kowner)
					else
						if connections.knockedownership then
							kownertick = false;
							connections.knockedownership:Disconnect();
						end
					end
				end)
			end
		})
		MiscSection:AddToggle({
			Name = "auto loot",
			Flag = "al",
			Callback = function(enabled)
				pcall(function()
					if enabled then
						connections.autoloot = game:GetService("RunService").RenderStepped:Connect(autoloot)
					else
						if connections.autoloot then
							connections.autoloot:Disconnect();
						end
					end
				end)
			end
		})
		MiscSection:AddToggle({
			Name = "streamer mode",
			Flag = "sm",
			Callback = function(enabled)
				pcall(function()
					if enabled then
						connections.streamermode = game:GetService("RunService").RenderStepped:Connect(streamermode)
					else
						if connections.streamermode then
							connections.streamermode:Disconnect();
							pcall(function()
								playerGui = game:GetService("Players").LocalPlayer.PlayerGui
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
					end
				end)
			end
		})
		MovementSection:AddToggle({
			Name = "noclip",
			Flag = "nc",
			Keybind = {
				Mode = "toggle"
			},
			Callback = function(enabled)
				pcall(function()
					if enabled then
						connections.noclip = game:GetService("RunService").Stepped:Connect(noclip)
					else
						if connections.noclip then
							connections.noclip:Disconnect();
							pcall(function()
								for i, v in pairs(lp.Character:GetChildren()) do
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
			end
		})
		MovementSection:AddToggle({
			Name = "speed",
			Flag = "speed",
			Keybind = {
				Mode = "toggle"
			},
			Callback = function(enabled)
				pcall(function()
					if enabled then
						connections.speed = game:GetService("RunService").RenderStepped:Connect(speed)
					else
						if connections.speed then
							connections.speed:Disconnect();
						end
					end
				end)
			end
		})
		ESPSection:AddToggle({
			Name = "hp bar",
			Flag = "hpbar",
			Callback = function(enabled)
				pcall(function()
					if enabled then
						connections.hpbar = game:GetService("RunService").RenderStepped:Connect(hpbar)
					else
						if connections.hpbar then
							connections.hpbar:Disconnect();
						end
					end
				end)
			end
		})
		MovementSection:AddSlider({
			Name = "walk speed",
			Flag = "Walk Speed Speed Speed Speed",
			Value = 100,
			Min = 0,
			Max = 250,
			Format = function(Value)
				return "Speed: " .. tostring(Value)
			end
		})
		MovementSection:AddToggle({
			Name = "non lookvector flight",
			Flag = "Non LookVector Flight",
			Keybind = {
				Mode = "toggle" -- Dynamic means to use the 'hold' method, if the user keeps the button pressed for longer than 0.65 seconds; else use toggle method
			},
			Callback = function(enabled)
				pcall(function()
					if enabled then
						connections.iceyfly = game:GetService("RunService").RenderStepped:Connect(icefly)
					else
						if connections.iceyfly then
							connections.iceyfly:Disconnect();
						end
					end
				end)
			end
		})
		MovementSection:AddToggle({
			Name = "fly rotate to camera",
			Flag = "frtc"
		})
		--"Walk Speed Speed Speed Speed"
		MovementSection:AddToggle({
			Name = "flight",
			Flag = "Fly",
			Keybind = {
				Mode = "toggle" -- Dynamic means to use the 'hold' method, if the user keeps the button pressed for longer than 0.65 seconds; else use toggle method
			},
			Callback = function(enabled)
				pcall(function()
					getgenv().Flight = enabled;
					if enabled then
						local Conns = {}
						for _,v in next, getconnections(lp.Character.DescendantAdded) do
							if v.Enabled then
								v:Disable()
								Conns[#Conns+1] = v
							end
						end
						for _,v in next, getconnections(lp.Character.PrimaryPart.DescendantAdded) do
							if v.Enabled then
								v:Disable()
								Conns[#Conns+1] = v
							end
						end
						for _,v in next, getconnections(lp.Character.PrimaryPart.ChildAdded) do
							if v.Enabled then
								v:Disable()
								Conns[#Conns+1] = v
							end
						end
						bv = Instance.new("BodyVelocity")
						bv.Parent = lp.Character.PrimaryPart
						bv.MaxForce = Vector3.new(4000000, 4000000, 4000000)
						bv.velocity = Vector3.new(0,0,0)
						if library.flags["frtc"] then
							pcall(function()
								bg = Instance.new("BodyGyro")
								bg.Parent = lp.Character.PrimaryPart;
								bg.maxTorque = Vector3.new(9e9,9e9,9e9);
								bg.P = 9e4;
								bg.cframe = workspace.CurrentCamera.CFrame;
							end)
						end
						for _,v in next, Conns do
							v:Enable()
						end
						connections.fly = game:GetService("RunService").RenderStepped:Connect(flight)
					else
						if connections.fly then
							connections.fly:Disconnect()
							bv:Destroy()
							bv = nil;
							if bg then
								bg:Destroy();
								bg = nil;
							end
						end
					end
				end)
			end
		})
		local LastRefresh = tick();
		
		MovementSection:AddSlider({
			Name = "flight speed",
			Flag = "Flight Speed",
			Value = 175,
			Min = 0,
			Max = 250,
			Format = function(Value)
				return "flight speed: " .. tostring(Value)
			end
		})
		HumanoidSection:AddSlider({
			Name = "jumppower",
			Flag = "JP",
			Value = 175,
			Min = 0,
			Max = 200,
			Format = function(Value)
				getgenv().JP = Value;
				pcall(function()
					if HumMods then
						char.GetHum(lp).JumpPower = Value;
					end
				end)
				return "jump power: " .. tostring(Value)
			end
		})
		HumanoidSection:AddSlider({
			Name = "walkspeed",
			Flag = "WS",
			Value = 250,
			Min = 0,
			Max = 300,
			Format = function(Value)
				pcall(function()
					if HumMods then
						GetHum(lp).WalkSpeed = Value;
					end
				end)
				getgenv().WS = Value;
				return "walk speed: " .. tostring(Value)
			end
		})
		sendnoti("Loaded", "Loaded In: " .. math.round(math.abs(starttime - tick()) * 100) / 100 .. "s", 5)
		local maxdistance = 10000;
		local refreshrate = 200;
		local lib = LPH_NO_VIRTUALIZE(function()
			local module = {}
			local espindex = {}
			local esps = {
			
			}
			local indexed = {
	
			}
			holder = game.CoreGui
			function initmodule(shouldupdatemanually)
				if not shouldupdatemanually then
					game:GetService("RunService").RenderStepped:Connect(function()
						pcall(function()
							if (tick() - LastRefresh) > (refreshrate/1000) then
								for i, v in pairs(espindex) do
									pcall(function()
										pcall(function()
											v.TextLabel.Visible = v.ESP.Enabled;
										end)
										if v.BillboardGui.Adornee == nil then
											v.BillboardGui:Destroy()
											espindex[i] = nil;
										end
									
										local cf = CFrame.new(0,0,0)
										local other = v.CFrame;
										if v.Character:GetPivot() then
											cf = v.Character:GetPivot()
										elseif other then
											cf = other;
										end;
										local mag = math.round(game:GetService("Players").LocalPlayer:DistanceFromCharacter(cf.Position));
										if mag < maxdistance then
											v.TextLabel.Visible = true;
											v.TextLabel.Text = v.Name .. " ["..mag.."]" 
											pcall(function()
												if v.ESP.showhealth then
													local hum = v.Character.Humanoid
													if not hum then
														v.TextLabel.Text = v.TextLabel.Text .. " [???/???] "
													else
														v.TextLabel.Text = v.TextLabel.Text .. " ["..math.round(hum.Health).."/"..hum.MaxHealth.."] "
													end
												end
											end)
										else
											v.TextLabel.Visible = false;
										end
										if not v.ESP.Enabled then
											v.TextLabel.Text = ""
										end
									end)
								end
								LastRefresh = tick();
							end
						end)
					end)
				end
			end
			function init(foldername)
				local fold = Instance.new("Folder")
				fold.Parent = holder;
				esps[foldername] = {Folder = fold, TextColor = Color3.fromRGB(255,255,255), showhealth = false, showlevel = false, Enabled = false, ScreenGui = Instance.new('ScreenGui')};
				esps[foldername].ScreenGui.Parent = fold;
				esps[foldername].Folder.Name = foldername;
				esps[foldername].ScreenGui.IgnoreGuiInset = true
				return esps[foldername]
			end
			function find(v)
				for i, b in pairs(esps) do
					if b.Folder.ScreenGui:FindFirstChild(v) then
						return true;
					end
				end
				return false;
			end
			function createesp(options, char, esp)
				if not options then
					options = {}
					options.PrimaryPart = char.PrimaryPart;
					options.Name = char.Name
					options.TextSize = 15;
					options.Font = Enum.Font.Ubuntu;
					options.Size = UDim2.new(0, 100, 0, 100);
					options.Color = Color3.fromRGB(65, 255, 160);
					options.Transparency = 0.75;
				end
				local BillboardGui = Instance.new("BillboardGui")
				local TextLabel = Instance.new("TextLabel")
				BillboardGui.Adornee = options.PrimaryPart
				BillboardGui.Name = options.Name
				BillboardGui.Parent = esp.ScreenGui
				BillboardGui.Size = UDim2.new(0, 100, 0, 150)
				BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
				BillboardGui.AlwaysOnTop = true
				TextLabel.Parent = BillboardGui
				TextLabel.BackgroundTransparency = 1
				TextLabel.Position = UDim2.new(0, 0, 0, -50)
				TextLabel.Size = options.Size
				TextLabel.Font = options.Font
				TextLabel.TextSize = options.TextSize
				TextLabel.TextColor3 = Color3.new(1, 1, 1)
				TextLabel.TextStrokeTransparency = 0
				TextLabel.TextColor3 = esp.TextColor;
				TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
				TextLabel.Text = options.Name
				TextLabel.ZIndex = 10
				indexed[char] = true;
				local player = nil;
				local z = game:GetService("Players"):GetPlayerFromCharacter(char);
				if z then
					player = z;
				end
				espindex[char.Name] = {Part = options.PrimaryPart, Character = char, Folder = esp.Folder, ESP = esp, Name = options.Name, BillboardGui = BillboardGui, Player = player, TextLabel = TextLabel}
			end
	
			module.init = init
			module.initmodule = initmodule
			module.createesp = createesp
			module.find = find
			module.espindex = espindex;
			module.esps = esps;
			module.index = indexed
			return module;
		end)()
		lib.initmodule(false)
		local playerlib = lib.init("esp",false);
		local chestlib = lib.init("chestesp",false);
		local moblib = lib.init("mobesp",false);
		local arealib = lib.init("areaesp",false);
		moblib.TextColor = Color3.fromRGB(111, 224, 19)
		moblib.showhealth = true;
		playerlib.showhealth = true;
		Players.PlayerAdded:Connect(function(v)
			pcall(function()
				task.spawn(function()
					pcall(function()
						if not v.Character then
							repeat task.wait() until v.Character
						end
						if not v.Character:FindFirstChild("HumanoidRootPart") then
							repeat task.wait() until v.Character:FindFirstChild("HumanoidRootPart")
						end
						if not lib.index[v.Character] and v.Character:FindFirstChild("HumanoidRootPart") and v ~= lp then
							local part = v.Character;
							lib.createesp({PrimaryPart = part, Name = v.Name,  Font = Enum.Font.Code, Size = UDim2.new(0, 100, 0, 100), TextSize = 14, Color = Color3.fromRGB(65, 255, 160), Transparency = 0.75}, part, playerlib)
						end
					end)
				end)
			end)
		end)
		pcall(function()
			pcall(function()
				for i, v in pairs(Players:GetPlayers()) do
					task.spawn(function()
						pcall(function()
							if not v.Character then
								repeat task.wait() until v.Character
							end
							if not v.Character:FindFirstChild("HumanoidRootPart") then
								repeat task.wait() until v.Character:FindFirstChild("HumanoidRootPart")
							end
							if not lib.index[v.Character] and v.Character:FindFirstChild("HumanoidRootPart") and v ~= lp  then
								local part = v.Character;
								lib.createesp({PrimaryPart = part, Name = v.Name,  Font = Enum.Font.Code, Size = UDim2.new(0, 100, 0, 100), TextSize = 14, Color = Color3.fromRGB(65, 255, 160), Transparency = 0.75}, part, playerlib)
							end
						end)
					end)
				end
			end)
		end)
		for i, v in pairs(workspace.Thrown:GetChildren()) do
			task.spawn(function()
				pcall(function()
					repeat task.wait() until v:FindFirstChild("Lid")
					if v:FindFirstChild("Lid") then
						lib.createesp({PrimaryPart = v:FindFirstChild("Lid"), Name = "Chest",  Font = Enum.Font.Code, Size = UDim2.new(0, 100, 0, 100), TextSize = 14, Color = Color3.fromRGB(65, 255, 160), Transparency = 0.75}, v, chestlib)
					end
				end)
			end)
		end
		workspace.Thrown.ChildAdded:Connect(function(v)
			pcall(function()
				repeat task.wait() until v:FindFirstChild("Lid")
				if v:FindFirstChild("Lid") then
					lib.createesp({PrimaryPart = v:FindFirstChild("Lid"), Name = "Chest",  Font = Enum.Font.Code, Size = UDim2.new(0, 100, 0, 100), TextSize = 14, Color = Color3.fromRGB(65, 255, 160), Transparency = 0.75}, v, chestlib)
				end
			end)
		end)
		local esped = {}
		pcall(function()
			for i, v in pairs(game:GetService("ReplicatedStorage").MarkerWorkspace.AreaMarkers:GetDescendants()) do
				pcall(function()
					if v.Name == "AreaMarker" and not esped[v.Parent.Name] and not lib.index[v] then
						lib.createesp({PrimaryPart = v, Name = v.Parent.Name,  Font = Enum.Font.Code, Size = UDim2.new(0, 100, 0, 100), TextSize = 14, Color = Color3.fromRGB(65, 255, 160), Transparency = 0.75}, v, arealib)
						esped[v.Parent.Name] = true;
					end
				end)
			end
		end)
		task.spawn(function()
			pcall(function()
				pcall(function()
					for i, v in pairs(workspace.Live:GetChildren()) do
						task.spawn(function()
							pcall(function()
								repeat task.wait() until v:FindFirstChild("HumanoidRootPart")
								if string.match(v.Name,".") and not esped[v.Name] and not Players:GetPlayerFromCharacter(v) and v:FindFirstChild("HumanoidRootPart") then
									lib.createesp({PrimaryPart = v, Name = getmobname(v),  Font = Enum.Font.Code, Size = UDim2.new(0, 100, 0, 100), TextSize = 14, Color = Color3.fromRGB(65, 255, 160), Transparency = 0.75}, v, moblib)
									esped[v.Name] = true;
								end
							end)
						end)
					end
				end)
			end)
		end)
		workspace.Live.ChildAdded:Connect(function(v)
			task.spawn(function()
				pcall(function()
					repeat task.wait(1.5) until v:FindFirstChild("HumanoidRootPart")
					pcall(function()
						if string.match(v.Name,".") and not esped[v.Name] and not Players:GetPlayerFromCharacter(v) and v:FindFirstChild("HumanoidRootPart") then
							lib.createesp({PrimaryPart = v, Name = getmobname(v),  Font = Enum.Font.Code, Size = UDim2.new(0, 100, 0, 100), TextSize = 14, Color = Color3.fromRGB(65, 255, 160), Transparency = 0.75}, v, moblib)
							esped[v.Name] = true;
						end
					end)
				end)
			end)

		end)
		ESPSection:AddToggle({
			Name = "mob esp",
			Flag = "MOB ESP",
			Enabled = true,
			Callback = function(enabled)
				moblib.Enabled = enabled;
			end
		})
		ESPSection:AddToggle({
			Name = "chest esp",
			Flag = "CHEST ESP",
			Enabled = true,
			Callback = function(enabled)
				pcall(function()
					for i, v in pairs(game.CoreGui.chestesp:GetDescendants()) do
						pcall(function()
							v.Visible = enabled;
						end)
					end
				end)
				chestlib.Enabled = enabled;
			end
		})
		ESPSection:AddToggle({
			Name = "area esp",
			Flag = "area ESP",
			Enabled = true,
			Callback = function(enabled)
				pcall(function()
					for i, v in pairs(game.CoreGui.areaesp:GetDescendants()) do
						pcall(function()
							v.Visible = enabled;
						end)
					end
				end)
				arealib.Enabled = enabled;
			end
		})
		ESPSection:AddSlider({
			Name = "refresh rate",
			Flag = "refresh rate",
			Value = 200,
			Min = 0,
			Max = 1000,
			Format = function(Value)
				refreshrate = Value;
				return "esp refresh rate: " .. tostring(Value)
			end
		})
		ESPSection:AddSlider({
			Name = "max distance",
			Flag = "max distance",
			Value = 10000,
			Min = 0,
			Max = 100000,
			Format = function(Value)
				maxdistance = Value;
				return "esp distance: " .. tostring(Value)
			end
		})
		ESPSection:AddToggle({
			Name = "show player health",
			Flag = "show player health",
			Enabled = true,
			Callback = function(enabled)
				playerlib.showhealth = enabled;
			end
		})
		ESPSection:AddToggle({
			Name = "esp",
			Flag = "ESP",
			Enabled = true,
			Callback = function(enabled)
				playerlib.Enabled = enabled;
			end
		})
		local TweenService = game:GetService("TweenService")
		local function moveto(obj, speed)
			local info = TweenInfo.new(((lp.Character.HumanoidRootPart.Position - obj.Position).Magnitude)/ speed,Enum.EasingStyle.Linear)
			local tween = TweenService:Create(lp.Character.HumanoidRootPart, info, {CFrame = obj})
			tween:Play()
		end
		local function GetClosestMob()
			local Character = game:GetService("Players").LocalPlayer.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			if not (Character or HumanoidRootPart) then return end
	
			local TargetDistance = 100
			local Target
	
			for i,v in ipairs(workspace.Live:GetChildren()) do
				if string.match(v.Name,".") and v ~= lp.Character and v:FindFirstChild("HumanoidRootPart") then
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
		local attachtoback = function()
			pcall(function()
				local target = GetClosestMob();
				if target ~= nil and not Players:GetPlayerFromCharacter(target) then
					moveto(target.Torso.CFrame * CFrame.new(0,library.flags["height"],library.flags["offset"]),library.flags["tween speed"])
				end
			end)
		end
		MiscSection:AddToggle({
			Name = "attach to back",
			Flag = "attach to back",
			Keybind = {
				Mode = "toggle"
			},
			Callback = function(enabled)
				pcall(function()
					if enabled then
						connections.attachtoback = game:GetService("RunService").RenderStepped:Connect(attachtoback)
					else
						if connections.attachtoback then
							connections.attachtoback:Disconnect();
						end
					end
				end)
			end
		})
		MiscSection:AddSlider({
			Name = "height",
			Flag = "height",
			Value = 0,
			Min = -50,
			Max = 50,
			Format = function(Value)
				return "attach to back height: " .. tostring(Value)
			end
		})
		MiscSection:AddSlider({
			Name = "tween speed",
			Flag = "tween speed",
			Value = 100,
			Min = 0,
			Max = 250,
			Format = function(Value)
				return "attach to back speed: " .. tostring(Value)
			end
		})
		
		MiscSection:AddSlider({
			Name = "offset",
			Flag = "offset",
			Value = 0,
			Min = -50,
			Max = 50,
			Format = function(Value)
				return "attach to back offset: " .. tostring(Value)
			end
		})
		local chat_logger = Instance.new("ScreenGui")
		local template_message = Instance.new("TextLabel")
		local lol;
		task.spawn(function()
			pcall(function()
				chat_logger.IgnoreGuiInset = true
				chat_logger.ResetOnSpawn = false
				chat_logger.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				chat_logger.Name = "Lannis [Ragoozer]: hi im real ragoozer Rogue Lineage"
				chat_logger.Parent = game.CoreGui;

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
		MiscSection:AddToggle({
			Name = "chat logger",
			Flag = "chat logger",
			Callback = function(en)
				lol.Visible = en;
			end
		})
	end)
