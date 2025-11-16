local fs = require("@lune/fs")
local roblox = require("@lune/roblox")

-- ─────────────────────────────────────────────────────────────────────────────
-- CLI argument parsing
-- Usage: lune run export_game.luau <inputPlace> <outputDir>
-- ─────────────────────────────────────────────────────────────────────────────

local args = { ... }

local function printUsage()
	print([[
Usage:
  lune run export_game.luau <inputPlace.rbxl> <outputDir>

Examples:
  lune run export_game.luau lavajump.rbxl exported
  lune run export_game.luau ./places/obby.rbxl ./exports/obby
]])
end

if #args >= 1 and (args[1] == "--help" or args[1] == "-h") then
	printUsage()
	return
end

local inputPath = args[1] or "lavajump.rbxl"
local outputRoot = args[2] or "exported"

print("Input place:  " .. inputPath)
print("Output root:  " .. outputRoot)

-- Ensure output root exists
fs.writeDir(outputRoot)

-- ─────────────────────────────────────────────────────────────────────────────
-- Helpers
-- ─────────────────────────────────────────────────────────────────────────────

local function safeName(name: string): string
	-- Replace characters that are annoying/invalid in file paths
	return name:gsub("[^%w_%-%(%) ]", "_")
end

local function exportInstance(inst, path: string)
	local instPath = path .. "/" .. safeName(inst.Name)

	-- If it's a script-like instance → save as .lua source file
	if inst:IsA("ModuleScript") or inst:IsA("LocalScript") or inst:IsA("Script") then
		fs.writeFile(instPath .. ".lua", inst.Source or "")
		return
	end

	-- If it has children, create a directory to mirror hierarchy
	if #inst:GetChildren() > 0 then
		fs.writeDir(instPath)
	end

	-- Save this instance as a .rbxmx model (NOT DataModel, but services/instances are fine)
	local ok, modelData = pcall(function()
		return roblox.serializeModel({ inst })
	end)

	if ok and modelData then
		fs.writeFile(instPath .. ".rbxmx", modelData)
	else
		-- Just log and skip if serializeModel doesn't like this instance for some reason
		print("Warning: could not serialize instance:", inst:GetFullName())
	end

	-- Recurse into children
	for _, child in ipairs(inst:GetChildren()) do
		exportInstance(child, instPath)
	end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Main
-- ─────────────────────────────────────────────────────────────────────────────

-- Read and deserialize the place file
local placeBytes = fs.readFile(inputPath)
local game = roblox.deserializePlace(placeBytes)

-- IMPORTANT: game is a DataModel → don't pass it to serializeModel()
-- Start from its children (Workspace, ReplicatedStorage, etc.)
for _, child in ipairs(game:GetChildren()) do
	exportInstance(child, outputRoot)
end

print("Done! Exported game structure to: " .. outputRoot)
