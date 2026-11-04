local Commands = {}


local function getTargets(sender, targetArg)
	if not targetArg then return {sender} end
	local argLower = targetArg:lower()

	if argLower == "me" then
		return {sender}
	elseif argLower == "all" then
		return game.Players:GetPlayers()
	elseif targetArg:sub(1, 1) == "%" then
		local teamName = targetArg:sub(2):lower()
		local matchedPlayers = {}
		for _, player in ipairs(game.Players:GetPlayers()) do
			if player.Team and player.Team.Name:lower():sub(1, #teamName) == teamName then
				table.insert(matchedPlayers, player)
			end
		end
		return matchedPlayers
	else
		for _, player in ipairs(game.Players:GetPlayers()) do
			if player.Name:lower():sub(1, #argLower) == argLower or player.DisplayName:lower():sub(1, #argLower) == argLower then
				return {player}
			end
		end
	end
	return {}
end

Commands.List = {
	reset = {
		MinRank = 1,
		Description = "Resets a player or group's character.",
		Run = function(sender, args)
			local targetArg = args[1] or "me"
			local targets = getTargets(sender, targetArg)
			for _, target in ipairs(targets) do
				if target.Character and target.Character:FindFirstChildOfClass("Humanoid") then
					target.Character.Humanoid.Health = 0
				end
			end
		end
	},

	stopwatch = {
		MinRank = 0,
		Description = "Opens a draggable stopwatch window.",
		Run = function(sender, args)
			local playerGui = sender:FindFirstChild("PlayerGui")
			if not playerGui then return end

			if playerGui:FindFirstChild("AdminStopwatchGui") then
				playerGui.AdminStopwatchGui:Destroy()
			end

			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = "AdminStopwatchGui"
			screenGui.ResetOnSpawn = false
			screenGui.Parent = playerGui

			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 220, 0, 110)
			frame.Position = UDim2.new(0.5, -110, 0.3, 0)
			frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			frame.BorderSizePixel = 0
			frame.Parent = screenGui

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 8)
			corner.Parent = frame

			local dragDetector = Instance.new("UIDragDetector")
			dragDetector.Parent = frame

			local title = Instance.new("TextLabel")
			title.Size = UDim2.new(1, -40, 0, 30)
			title.Position = UDim2.new(0, 10, 0, 5)
			title.BackgroundTransparency = 1
			title.Text = "Stopwatch"
			title.TextColor3 = Color3.fromRGB(255, 255, 255)
			title.TextSize = 16
			title.Font = Enum.Font.SourceSansBold
			title.TextXAlignment = Enum.TextXAlignment.Left
			title.Parent = frame

			local closeBtn = Instance.new("TextButton")
			closeBtn.Size = UDim2.new(0, 30, 0, 30)
			closeBtn.Position = UDim2.new(1, -35, 0, 5)
			closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
			closeBtn.Text = "X"
			closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			closeBtn.TextSize = 14
			closeBtn.Font = Enum.Font.SourceSansBold
			closeBtn.Parent = frame

			local closeCorner = Instance.new("UICorner")
			closeCorner.CornerRadius = UDim.new(0, 6)
			closeCorner.Parent = closeBtn

			closeBtn.MouseButton1Click:Connect(function()
				screenGui:Destroy()
			end)

			local timerLabel = Instance.new("TextLabel")
			timerLabel.Size = UDim2.new(1, -20, 0, 50)
			timerLabel.Position = UDim2.new(0, 10, 0, 45)
			timerLabel.BackgroundTransparency = 1
			timerLabel.Text = "00:00"
			timerLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
			timerLabel.TextSize = 32
			timerLabel.Font = Enum.Font.Code
			timerLabel.Parent = frame

			task.spawn(function()
				local seconds = 0
				while screenGui.Parent do
					task.wait(1)
					if not screenGui.Parent then break end
					seconds += 1
					local mins = math.floor(seconds / 60)
					local secs = seconds % 60
					timerLabel.Text = string.format("%02d:%02d", mins, secs)
				end
			end)
		end
	},

	kick = {
		MinRank = 2,
		Description = "Kicks a player from the server.",
		Run = function(sender, args)
			local targets = getTargets(sender, args[1])
			table.remove(args, 1)
			local reason = table.concat(args, " ")
			if reason == "" then reason = "Kicked by an administrator." end
			for _, target in ipairs(targets) do
				target:Kick(reason)
			end
		end
	},

	ban = {
		MinRank = 3,
		Description = "Bans a player from the game.",
		Run = function(sender, args)
			local targets = getTargets(sender, args[1])
			for _, target in ipairs(targets) do
				target:Kick("You have been banned from this experience.")
			end
		end
	},

	mute = {
		MinRank = 1,
		Description = "Prevents a player from chatting.",
		Run = function(sender, args)
			local targets = getTargets(sender, args[1])
			for _, target in ipairs(targets) do
				print(sender.Name .. " muted " + target.Name)
			end
		end
	}
}

return Commands
