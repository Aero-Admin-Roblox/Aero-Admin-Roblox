-- To get UserIDs, you need to go to the user's roblox profile on Roblox's Website and copy the numbers in the link in your browser

local Ranks = {}



Ranks.Levels = {
	Player = 0,
	Moderator = 1,
	Admin = 2,
	Owner = 3
}


Ranks.Users = {
	[12345678] = Ranks.Levels.Owner,     
	[87654321] = Ranks.Levels.Admin,     
	[11223344] = Ranks.Levels.Moderator, 
}

return Ranks
