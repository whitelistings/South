script_key="gRmopajCzjCQuXFLfbmvwLIEhVNNrtbi";
getgenv().script_key = script_key; -- DO NOT TOUCH
 getgenv().South = {
    Aimbot = {
        Keybind = Enum.KeyCode.E,
        CamlockPrediction = 0.085,
        Prediction = 0.11,

        Basic = true,
        TargetPart = "Head",

        NearestPart = true,
        MultipleTargetPart = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg",  "LeftUpperLeg", "RightLowerLeg", "RightFoot",  "RightUpperLeg"},

        CameraSmoothing = 0.0180,
        CameraShake = 0,
        JumpOffset = -1.65
    },
    FOV = {
        Visible = false,
        Color = Color3.fromRGB(255, 255, 255),
        Size = 400,
        Transparency = 0.2,
        Filled = false
    },
    Checks = {
        DisableOnTargetDeath = true,
        DisableOnPlayerDeath = true,
        CheckKoStatus = true,
    },
    Macro = {
        Enabled = false,
        SpeedGlitchKey = Enum.KeyCode.X,
    },
    ESP = {
        Distance = false,
        Weapon = false,
        Health = false,
        Name = false
    },
    Misc = {
        RejoinServer = false,
    },
    Spin = {
        Enabled = true,
        SpinSpeed = 2100,
        Degrees = 360,
        Keybind = Enum.KeyCode.V,
    },
}


if (not getgenv().Loaded) then
    local userInputService = game:GetService("UserInputService")
    
    local function CheckAnti(Plr) -- // Anti-aim detection
        if Plr.Character.HumanoidRootPart.Velocity.Y < -70 then
            return true
        elseif Plr and (Plr.Character.HumanoidRootPart.Velocity.X > 450 or Plr.Character.HumanoidRootPart.Velocity.X < -35) then
            return true
        elseif Plr and Plr.Character.HumanoidRootPart.Velocity.Y > 60 then
            return true
        elseif Plr and (Plr.Character.HumanoidRootPart.Velocity.Z > 35 or Plr.Character.HumanoidRootPart.Velocity.Z < -35) then
            return true
        else
            return false
        end
    end
    
    local function getnamecall()
        if game.PlaceId == 2788229376 then
            return "UpdateMousePos"
        elseif game.PlaceId == 5602055394 or game.PlaceId == 7951883376 then
            return "MousePos"
        elseif game.PlaceId == 9825515356 then
            return "GetMousePos"
        end
    end
    
    function MainEventLocate()
        for _,v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if v.Name == "MainEvent" then
                return v
            end
        end
    end
    
    local Locking = false
    local Players = game:GetService("Players")
    local Client = Players.LocalPlayer
    local Plr = nil -- Initialize Plr here
    
    -- 360 on bind
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local Toggle = false -- Initialize Toggle to false
    
    local function OnKeyPress(Input, GameProcessedEvent)
        if Input.KeyCode == getgenv().South.Aimbot.Keybind and not GameProcessedEvent then 
            Toggle = not Toggle
        elseif Input.KeyCode == getgenv().South.Macro.SpeedGlitchKey then
            if getgenv().South.Macro.Enabled then 
                getgenv().South.Macro.SpeedGlitch = not getgenv().South.Macro.SpeedGlitch
                if getgenv().South.Macro.SpeedGlitch then
                    repeat
                        game:GetService("RunService").Heartbeat:Wait()
                        keypress(0x49)
                        game:GetService("RunService").Heartbeat:Wait()
                        keypress(0x4F)
                        game:GetService("RunService").Heartbeat:Wait()
                        keyrelease(0x49)
                        game:GetService("RunService").Heartbeat:Wait()
                        keyrelease(0x4F)
                        game:GetService("RunService").Heartbeat:Wait()
                    until not getgenv().South.Macro.SpeedGlitch
                end
            end
        end
    end
    
    UserInputService.InputBegan:Connect(OnKeyPress)
    
    UserInputService.InputBegan:Connect(function(keygo, ok)
        if (not ok) then
            if (keygo.KeyCode == getgenv().South.Aimbot.Keybind) then
                Locking = not Locking
                if Locking then
                    Plr = getClosestPlayerToCursor()
                elseif not Locking then
                    if Plr then
                        Plr = nil
                    end
                end
            end
        end
    end)
    
    function getClosestPlayerToCursor()
        local closestDist = math.huge
        local closestPlr = nil
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= Client and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                local screenPos, cameraVisible = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if cameraVisible then
                    local distToMouse = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if distToMouse < closestDist then
                        closestPlr = v
                        closestDist = distToMouse
                    end
                end
            end
        end
        return closestPlr
    end
    
    function getClosestPartToCursor(Player)
        local closestPart, closestDist = nil, math.huge
        if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("Head") and Player.Character.Humanoid.Health ~= 0 and Player.Character:FindFirstChild("HumanoidRootPart") then
            for i, part in pairs(Player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    local screenPos, cameraVisible = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                    local distToMouse = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if distToMouse < closestDist and table.find(getgenv().South.Aimbot.MultipleTargetPart, part.Name) then
                        closestPart = part
                        closestDist = distToMouse
                    end
                end
            end
            return closestPart
        end
    end
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if Plr and Plr.Character then
            if getgenv().South.Aimbot.NearestPart == true and getgenv().South.Aimbot.Basic == false then
                getgenv().South.Aimbot.TargetPart = tostring(getClosestPartToCursor(Plr))
            elseif getgenv().South.Aimbot.Basic == true and getgenv().South.Aimbot.NearestPart == false then
                getgenv().South.Aimbot.TargetPart = getgenv().South.Aimbot.TargetPart
            end
        end
    end)
    
    local function getVelocity(Player)
        local Old = Player.Character.HumanoidRootPart.Position
        wait(0.145)
        local Current = Player.Character.HumanoidRootPart.Position
        return (Current - Old) / 0.145
    end
    
    local function GetShakedVector3(Setting)
        return Vector3.new(math.random(-Setting * 1e9, Setting * 1e9), math.random(-Setting * 1e9, Setting * 1e9), math.random(-Setting * 1e9, Setting * 1e9)) / 1e9;
    end
    
    local v = nil
    game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
        if Plr ~= nil and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
            v = getVelocity(Plr)
        end
    end)
    
    local mainevent = game:GetService("ReplicatedStorage").MainEvent
    
    Client.Character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and child:FindFirstChild("MaxAmmo") then
            child.Activated:Connect(function()
                if Plr and Plr.Character then
                    local Position = Plr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall and Plr.Character[getgenv().South.Aimbot.TargetPart].Position + Vector3.new(0, getgenv().South.Aimbot.JumpOffset, 0) or Plr.Character[getgenv().South.Aimbot.TargetPart].Position
                    if not CheckAnti(Plr) then
                        mainevent:FireServer("UpdateMousePos", Position + ((Plr.Character.HumanoidRootPart.Velocity) * getgenv().South.Aimbot.Prediction))
                    else
                        mainevent:FireServer("UpdateMousePos", Position + ((Plr.Character.Humanoid.MoveDirection * Plr.Character.Humanoid.WalkSpeed) * getgenv().South.Aimbot.Prediction))
                    end
                end
            end)
        end
    end)
    
    Client.CharacterAdded:Connect(function(character)
        character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and child:FindFirstChild("MaxAmmo") then
                child.Activated:Connect(function()
                    if Plr and Plr.Character then
                        local Position = Plr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall and Plr.Character[getgenv().South.Aimbot.TargetPart].Position + Vector3.new(0, getgenv().South.Aimbot.JumpOffset, 0) or Plr.Character[getgenv().South.Aimbot.TargetPart].Position
                        if not CheckAnti(Plr) then
                            mainevent:FireServer("UpdateMousePos", Position + ((Plr.Character.HumanoidRootPart.Velocity) * getgenv().South.Aimbot.Prediction))
                        else
                            mainevent:FireServer("UpdateMousePos", Position + ((Plr.Character.Humanoid.MoveDirection * Plr.Character.Humanoid.WalkSpeed) * getgenv().South.Aimbot.Prediction))
                        end
                    end
                end)
            end
        end)
    end)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if Plr ~= nil and Plr.Character then
            local Position = Plr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall and Plr.Character[getgenv().South.Aimbot.TargetPart].Position + Vector3.new(0, getgenv().South.Aimbot.JumpOffset, 0) or Plr.Character[getgenv().South.Aimbot.TargetPart].Position
            if not CheckAnti(Plr) then
                local Main = CFrame.new(workspace.CurrentCamera.CFrame.p, Position + ((Plr.Character.HumanoidRootPart.Velocity) * getgenv().South.Aimbot.CamlockPrediction) + GetShakedVector3(getgenv().South.Aimbot.CameraShake))
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(Main, getgenv().South.Aimbot.CameraSmoothing, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            else
                local Main = CFrame.new(workspace.CurrentCamera.CFrame.p, Position + ((Plr.Character.Humanoid.MoveDirection * Plr.Character.Humanoid.WalkSpeed) * getgenv().South.Aimbot.CamlockPrediction) + GetShakedVector3(getgenv().South.Aimbot.CameraShake))
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(Main, getgenv().South.Aimbot.CameraSmoothing, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            end
        end
        if getgenv().South.Checks.CheckKoStatus == true and Plr and Plr.Character then
            local KOd = Plr.Character:WaitForChild("BodyEffects")["K.O"].Value
            local Grabbed = Plr.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
            if Plr.Character.Humanoid.Health < 1 or KOd or Grabbed then
                if Locking == true then
                    Plr = nil
                    Locking = false
                end
            end
        end
        if getgenv().South.Checks.DisableOnTargetDeath == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
            if Plr.Character.Humanoid.health < 1 then
                if Locking == true then
                    Plr = nil
                    Locking = false
                end
            end
        end
        if getgenv().South.Checks.DisableOnPlayerDeath == true and Client.Character and Client.Character:FindFirstChild("Humanoid") and Client.Character.Humanoid.health < 1 then
            if Locking == true then
                Plr = nil
                Locking = false
            end
        end
        if getgenv().South.Safety.AntiGroundShots == true and Plr.Character.Humanoid.Jump == true and Plr.Character.Humanoid.FloorMaterial == Enum.Material.Air then
            pcall(function()
                local TargetVelv5 = Plr.Character.HumanoidRootPart
        TargetVelv5.Velocity = Vector3.new(TargetVelv5.Velocity.X, math.abs(TargetVelv5.Velocity.Y * 0.36),
         TargetVelv5.Velocity.Z)
                TargetVelv5.AssemblyLinearVelocity = Vector3.new(TargetVelv5.Velocity.X, math.abs(TargetVelv5.Velocity.Y * 0.36), TargetVelv5.Velocity.Z)
            end)
        end
    end)
    
    if getgenv().South.EspSection.ChamsESP == true then
    
    local UserInputService = game:GetService("UserInputService")
    local ToggleKey = getgenv().South.EspSection.ChamsESPKeybind
    
    local FillColor = getgenv().South.EspSection.ChamsColor1
    local DepthMode = "AlwaysOnTop"
    local FillTransparency = 0.5
    local OutlineColor = getgenv().South.EspSection.ChamsColor2
    local OutlineTransparency = 0
    
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    local connections = {}
    
    local Storage = Instance.new("Folder")
    Storage.Parent = CoreGui
    Storage.Name = "Highlight_Storage"
    
    local isEnabled = false
    
    local function Highlight(plr)
        local Highlight = Instance.new("Highlight")
        Highlight.Name = plr.Name
        Highlight.FillColor = FillColor
        Highlight.DepthMode = DepthMode
        Highlight.FillTransparency = FillTransparency
        Highlight.OutlineColor = OutlineColor
        Highlight.OutlineTransparency = 0
        Highlight.Parent = Storage
        
        local plrchar = plr.Character
        if plrchar then
            Highlight.Adornee = plrchar
        end
    
        connections[plr] = plr.CharacterAdded:Connect(function(char)
            Highlight.Adornee = char
        end)
    end
    
    local function EnableHighlight()
        isEnabled = true
        for _, player in ipairs(Players:GetPlayers()) do
            Highlight(player)
        end
    end
    
    local function DisableHighlight()
        isEnabled = false
        for _, highlight in ipairs(Storage:GetChildren()) do
            highlight:Destroy()
        end
        for _, connection in pairs(connections) do
            connection:Disconnect()
        end
    end
    
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == ToggleKey then
            if isEnabled then
                DisableHighlight()
            else
                EnableHighlight()
            end
        end
    end)
    
    Players.PlayerAdded:Connect(function(player)
        if isEnabled then
            Highlight(player)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        local highlight = Storage:FindFirstChild(player.Name)
        if highlight then
            highlight:Destroy()
        end
        local connection = connections[player]
        if connection then
            connection:Disconnect()
        end
    end)
    
    
    if isEnabled then
        EnableHighlight()
    end
    end
    
    if getgenv().South.Misc.RejoinServer == true then
    local TeleportService = game:GetService("TeleportService")
    
    local function RejoinSameServer()
        local success, errorMessage = pcall(function()
            local placeId = game.PlaceId
            local jobId = game.JobId
            TeleportService:TeleportToPlaceInstance(placeId, jobId)
        end)
    
        if not success then
            warn("Failed to rejoin: " .. errorMessage)
        end
    end
    
    wait(0)
    RejoinSameServer()
    end
    
    if getgenv().South.Spin.Enabled == true then
        
        local Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")
        local Camera = workspace.CurrentCamera
        local Toggle = getgenv().South.Spin.Enabled
        local RotationSpeed = getgenv().South.Spin.SpinSpeed
        local Keybind = getgenv().South.Spin.Keybind
        
        local function OnKeyPress(Input, GameProcessedEvent)
            if Input.KeyCode == Keybind and not GameProcessedEvent then 
                Toggle = not Toggle
            end
        end
        
        UserInputService.InputBegan:Connect(OnKeyPress)
        
        local LastRenderTime = 0
        local TotalRotation = 0
        
        local function RotateCamera()
            if Toggle then
                local CurrentTime = tick()
                local TimeDelta = math.min(CurrentTime - LastRenderTime, 0.01)
                LastRenderTime = CurrentTime
        
                local RotationAngle = RotationSpeed * TimeDelta
                local Rotation = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(RotationAngle))
                Camera.CFrame = Camera.CFrame * Rotation
        
                TotalRotation = TotalRotation + RotationAngle
                if TotalRotation >= getgenv().South.Spin.Degrees then 
                    Toggle = false
                    TotalRotation = 0
                end
            end
        end
        
        RunService.RenderStepped:Connect(RotateCamera)
        end
    
    getgenv().Loaded = true -- end of the script
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "South",
            Text = "Updated Table",
            Duration = 0.001
        })
    end
    