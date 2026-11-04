-- DO NOT EDIT THIS SCRIPT UNLESS YOU KNOW WHAT YOU'RE DOING

local MAIN_MODULE_ID = 136337019340075


local ranksModule = script:WaitForChild("Ranks")
local RanksData = require(ranksModule)

local success, MainModule = pcall(function()
	return require(MAIN_MODULE_ID)
end)

if success and MainModule then

	MainModule.Init({
		Prefix = ";", -
		Admins = RanksData.Users 
	})

	print("Aero Admin System loaded successfully!")

	
end