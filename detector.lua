-- very cool detector
-- made by bann6r
-- 15th june 2026

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local textLabel = script.Parent

-- label color presets
local COLOR_BLACK = Color3.fromRGB(0, 0, 0)
local COLOR_RED = Color3.fromRGB(200, 0, 0)
local COLOR_DARK_GREEN = Color3.fromRGB(0, 120, 0)

-- LAYER 1: display names (if not display names, then USERNAME)
local bannedUsernames = {
	"jhayanx",
	"Marluige",
	"kitbodega7",
	"JaxonFiya",
	"kalibangonsyndroms",
	"noahclyde18"
}

-- LAYER 3: text scan if player wears accessory names like this
-- (drop names here)
local textTargets = {"kit bodega", "kitbodega", "gameoverse", "kaboodle", "gobbles", "farcade"}

-- LAYER 2: detecting if player is wearing items with a specific id
-- (drop ids here)
local blockedAssetIds = {
	94993061004030,
	170323465475648,
	79862810364372,
	88980203897412,
	121852212510268,
	100613432181334,
}

-- function for layer 1 text scanning
local function containsIsolatedNumbers(text)
	for _, word in ipairs(textTargets) do
		if string.find(text, word, 1, true) then
			return true
		end
	end
	return false
end

-- run detection system
local function startDetection()
	-- detection delay for players who just joined
	textLabel.TextColor3 = COLOR_BLACK
	textLabel.Text = "starting detection, please wait..."
	task.wait(3)

	-- detecting avatar
	textLabel.Text = "detecting if youre weird..."
	task.wait(1.5) 

	local isSuspect = false

	-- layer 1 check
	if table.find(bannedUsernames, localPlayer.Name) then
		isSuspect = true
	elseif containsIsolatedNumbers(localPlayer.Name) or containsIsolatedNumbers(localPlayer.DisplayName) then
		isSuspect = true
	end

	-- layer 1 & 2 check
	if not isSuspect then
		local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("Accessory") then

				-- accessory id matches the blocked list refered in layer 2?
				local handle = child:FindFirstChild("Handle")
				if handle then
					local mesh = handle:FindFirstChildOfClass("SpecialMesh")
					if mesh and mesh.MeshId ~= "" then
						local id = tonumber(string.match(mesh.MeshId, "%d+"))
						if id and table.find(blockedAssetIds, id) then
							isSuspect = true
							break 
						end
					end
				end

				-- accessory name matches the blocked list refered in layer 1?
				if containsIsolatedNumbers(child.Name) then
					isSuspect = true
					break 
				end

			end
		end
	end

	-- final results
	if isSuspect then
		textLabel.TextColor3 = COLOR_RED
		textLabel.Text = "HELL NAH BROTHER HELL NAH" -- !! DETECTED !!
	else
		textLabel.TextColor3 = COLOR_DARK_GREEN
		textLabel.Text = "fine, ill let you slide. but dont forget im always improving." -- ykw you passed
	end
end

-- start function
startDetection()
