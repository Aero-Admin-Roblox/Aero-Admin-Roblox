local MainModule = {}
local registeredCommands = {}
local userRanks = {}
local commandPrefix = "!"

local function parseAndExecute(player, message)
	if message:sub(1, #commandPrefix) ~= commandPrefix then return end

	local rawContent = message:sub(#commandPrefix + 1)
	local args = string.split(rawContent, " ")
	local commandName = table.remove(args, 1):lower()

	local cmd = registeredCommands[commandName]
	if cmd then
		local playerRank = userRanks[player.UserId] or 0
		if playerRank >= cmd.MinRank then
			task.spawn(function()
				cmd.Run(player, args)
			end)
		else
			warn(player.Name .. " lacks permission for !" .. commandName)
		end
	end
end

function MainModule.Init(customSettings)
	if not customSettings then customSettings = {} end


	if customSettings.Prefix then
		commandPrefix = customSettings.Prefix
	end


	if customSettings.Admins then
		for userId, rank in pairs(customSettings.Admins) do
			userRanks[userId] = rank
		end
	end


	local successCmds, commandsModule = pcall(function()
		return script:WaitForChild("Commands")
	end)
	if successCmds and commandsModule then
		local loaded = require(commandsModule)
		if loaded and loaded.List then
			for name, data in pairs(loaded.List) do
				registeredCommands[name:lower()] = data
			end
		end
	else
		warn("Failed to load Commands module!")
	end


	game.Players.PlayerAdded:Connect(function(player)
		player.Chatted:Connect(function(message)
			parseAndExecute(player, message)
		end)
	end)

	for _, player in ipairs(game.Players:GetPlayers()) do
		player.Chatted:Connect(function(message)
			parseAndExecute(player, message)
		end)
	end
end

return MainModule