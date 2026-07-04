local _, ns = ...

ns.Preferences = ns.Preferences or {}

-- Option keys
ns.Preferences.Options = {
    SHOW_ENCOUNTER_FRAME_BORDER = "encounter_frame_border"
}

-- Default values
ns.Preferences.Defaults = {
    [ns.Preferences.Options.SHOW_ENCOUNTER_FRAME_BORDER] = true
}

-- Reset one or all preferences
function ns.Preferences.Reset(name)
    -- Populate our backing store with default values
    if not name then
        ManfleshPreferences = {}
        for option, value in pairs(ns.Preferences.Defaults) do
            ManfleshPreferences[option] = value
        end
    -- Populate the provided variable with its default value
    else
        local newValue = ns.Preferences.Defaults[name]
        if type(newValue) == "table" then
            newValue = CopyTable(newValue)
        end
        ns.Preferences.Set(name, newValue)
    end
end

-- Initialize a datastructure that can be persisted to disk
function ns.Preferences.InitializeData()
    -- Initialize the backing store
    if ManfleshPreferences == nil then
        ns.Preferences.Reset()
    -- Populate default values for any missing variables (DB Migration?)
    else
        for option, value in pairs(ns.Preferences.Defaults) do
            if ManfleshPreferences[option] == nil then
                ManfleshPreferences[option] = value
            end
        end
    end
end

-- Check if the preference option exists
function ns.Preferences.IsValidOption(name)
  for _, option in pairs(ns.Preferences.Options) do
    if option == name then return true end
  end
  return false
end

-- Get the value associated with the provided preference key
function ns.Preferences.Get(name)
    if ManfleshPreferences == nil then
        return ns.Preferences.Defaults[name]
    else
        return ManfleshPreferences[name]
    end
end

-- Set the value associated with the provided preference key
function ns.Preferences.Set(name, value)
    if ManfleshPreferences == nil then
        error("Backing store for addon preferences is not initialized")
    elseif not ns.Preferences.IsValidOption(name) then
        error("Invalid option '" .. tostring(name) .. "'")
    else
        ManfleshPreferences[name] = value
    end
end

