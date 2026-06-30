local _, ns = ...

-- ---------------------------------------------------------------------------
-- Class registry. Each Classes\<Class>.lua calls ns.RegisterClass to fill
-- these tables; load order in the .toc decides the class list order.
-- ---------------------------------------------------------------------------
ns.CLASS_LIST = {}
ns.CLASS_DISPLAY = {}
ns.DPS_ONLY = {}            -- classes locked to the DPS role
ns.SPECS = {}              -- token -> { specDisplayName, ... }
ns.RH_CLASS_MAP = {}       -- Raid-Helper className -> our class token
ns.RH_CLASS_EXPORT = {}    -- token -> { name, emote, color }
ns.RH_SPEC_EXPORT = {}     -- token -> { [ourSpec] = { rhSpec, emote } }
ns.CLASS_ASSIGNS = {}      -- token -> { assignmentId, ... }
ns.ASSIGN_DEFS = {}        -- assignmentId -> def (filled by Roles.lua + classes)

local FALLBACK_CLASS_COLOR = {}
local CLASS_SPEC_ICONS = {} -- token -> { [normalizedSpec] = iconPath }

local function normSpec(spec)
    return (tostring(spec):lower():gsub("[^%a]", ""))
end

-- spec-name variants Raid-Helper or users might type
local SPEC_ICON_ALIASES = {
    feralcombat = "feral", feraltank = "feral", guardian = "feral",
    beast = "beastmastery", bm = "beastmastery", resto = "restoration",
    prot = "protection", ret = "retribution", disc = "discipline",
    destro = "destruction", affli = "affliction", demo = "demonology",
}

function ns.RegisterClass(def)
    local token = def.token
    ns.CLASS_LIST[#ns.CLASS_LIST + 1] = token
    ns.CLASS_DISPLAY[token] = def.display
    FALLBACK_CLASS_COLOR[token] = def.color
    if def.dpsOnly then ns.DPS_ONLY[token] = true end
    ns.SPECS[token] = def.specs or {}
    if def.display then ns.RH_CLASS_MAP[def.display] = token end
    if def.rhExport then ns.RH_CLASS_EXPORT[token] = def.rhExport end
    if def.rhSpecExport then ns.RH_SPEC_EXPORT[token] = def.rhSpecExport end

    CLASS_SPEC_ICONS[token] = {}
    if def.specIcons then
        for name, path in pairs(def.specIcons) do
            CLASS_SPEC_ICONS[token][normSpec(name)] = path
        end
    end

    if def.assignments then
        for id, adef in pairs(def.assignments) do
            ns.ASSIGN_DEFS[id] = adef
        end
    end
    ns.CLASS_ASSIGNS[token] = def.assignOrder or {}
end

function ns.ClassDisplay(class)
    return ns.CLASS_DISPLAY[class] or class or "?"
end

function ns.ClassColor(class)
    local c = RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
    if c then
        return c.r, c.g, c.b
    end
    local f = FALLBACK_CLASS_COLOR[class]
    if f then
        return f[1], f[2], f[3]
    end
    return 1, 1, 1
end

-- class lets us pick the right icon when specs share a name (Holy, Protection,
-- Restoration). Also resolves Raid-Helper template names (Holy1, Restoration1...).
function ns.SpecIcon(spec, class)
    if not spec or spec == "" then return nil end
    local key = normSpec(spec)
    key = SPEC_ICON_ALIASES[key] or key
    local t = class and CLASS_SPEC_ICONS[class]
    if t and t[key] then return t[key] end
    for _, tbl in pairs(CLASS_SPEC_ICONS) do
        if tbl[key] then return tbl[key] end
    end
    return nil
end

-- ---------------------------------------------------------------------------
-- Raid registry. Each Raids\<Raid>.lua calls ns.RegisterRaid.
-- ---------------------------------------------------------------------------
ns.RAIDS = {}

function ns.RegisterRaid(def)
    ns.RAIDS[#ns.RAIDS + 1] = def
end

function ns.GetRaidByName(name)
    for _, r in ipairs(ns.RAIDS) do
        if r.name == name then return r end
    end
    return nil
end
