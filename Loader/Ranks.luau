-- To get UserIDs, you need to go to the user's roblox profile on Roblox's Website and copy the numbers in the link in your browser

local Ranks = {}



Ranks.Levels = {
	Player = 0,
	Moderator = 1,
	Admin = 2,
	Owner = 3
}


Ranks.Users = {
	[USER_ID] = Ranks.Levels.Owner,     
	[USER_ID] = Ranks.Levels.Admin,     
	[USER_ID] = Ranks.Levels.Moderator, 
}

return Ranks
