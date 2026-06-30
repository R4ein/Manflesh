local _, ns = ...

-- ---------------------------------------------------------------------------
-- Roles
-- ---------------------------------------------------------------------------
ns.ROLE_LIST = { "TANK", "HEALER", "DPS" }
ns.ROLE_DISPLAY = { TANK = "Tank", HEALER = "Healer", DPS = "DPS" }

function ns.RoleDisplay(role)
    return ns.ROLE_DISPLAY[role] or role or "?"
end

-- ---------------------------------------------------------------------------
-- Raid target markers
-- ---------------------------------------------------------------------------
ns.MARK_LIST = { "skull", "cross", "diamond", "triangle", "moon", "star" }
ns.MARK_DISPLAY = {
    skull = "Skull", cross = "Cross", diamond = "Diamond",
    triangle = "Triangle", moon = "Moon", star = "Star",
}
-- maps to RaidTargetingIcon_<n> (1 star 2 circle 3 diamond 4 triangle 5 moon 6 square 7 cross 8 skull)
ns.MARK_ICON_INDEX = {
    star = 1, diamond = 3, triangle = 4, moon = 5, cross = 7, skull = 8,
}

function ns.MarkDisplay(mark)
    return ns.MARK_DISPLAY[mark] or mark or "?"
end

function ns.MarkIcon(mark, size)
    local idx = ns.MARK_ICON_INDEX[mark]
    if not idx then return "" end
    size = size or 14
    return ("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d:%d:%d|t"):format(idx, size, size)
end

function ns.MarkMenuText(mark)
    return ns.MarkIcon(mark) .. " " .. ns.MarkDisplay(mark)
end

-- ---------------------------------------------------------------------------
-- Role-based assignment definitions (class-specific ones live in Classes\*).
-- each def: label, optional input ("mark" | "text" | "target"), and build(d)
-- ns.ASSIGN_DEFS is created by Data.lua and also filled by class registration.
-- ---------------------------------------------------------------------------
ns.ASSIGN_DEFS.dmg_mark       = { label = "Damage <mark>",     input = "mark", build = function(d) return "Damage {" .. ns.MarkDisplay(d.mark) .. "}" end }
ns.ASSIGN_DEFS.dmg_boss       = { label = "Damage BOSS",       build = function() return "Damage BOSS" end }
ns.ASSIGN_DEFS.interrupt_mark = { label = "Interrupt <mark>",  input = "mark", build = function(d) return "Interrupt {" .. ns.MarkDisplay(d.mark) .. "}" end }
ns.ASSIGN_DEFS.interrupt_boss = { label = "Interrupt BOSS",    build = function() return "Interrupt BOSS" end }
ns.ASSIGN_DEFS.aoe            = { label = "AOE",               build = function() return "AOE" end }

ns.ASSIGN_DEFS.tank_mark      = { label = "Tank <mark>",       input = "mark", build = function(d) return "Tank {" .. ns.MarkDisplay(d.mark) .. "}" end }
ns.ASSIGN_DEFS.tank_boss      = { label = "Tank BOSS",         build = function() return "Tank BOSS" end }
ns.ASSIGN_DEFS.tank_adds      = { label = "Tank ADDS",         build = function() return "Tank ADDS" end }

ns.ASSIGN_DEFS.heal_mark      = { label = "Heal <mark>",       input = "mark", build = function(d) return "Heal {" .. ns.MarkDisplay(d.mark) .. "}" end }
ns.ASSIGN_DEFS.heal_main_tank = { label = "Heal main tank",    build = function() return "Heal main tank" end }
ns.ASSIGN_DEFS.heal_off_tank  = { label = "Heal off tank",     build = function() return "Heal off tank" end }
ns.ASSIGN_DEFS.heal_raid      = { label = "Heal RAID",         build = function() return "Heal RAID" end }

ns.ASSIGN_DEFS.custom         = { label = "Custom text...",    input = "text", build = function(d) return d.text end }

ns.ROLE_ASSIGNS = {
    DPS    = { "dmg_mark", "dmg_boss", "interrupt_mark", "interrupt_boss", "aoe", "custom" },
    TANK   = { "tank_mark", "tank_boss", "tank_adds", "custom" },
    HEALER = { "heal_mark", "heal_main_tank", "heal_off_tank", "heal_raid", "custom" },
}

function ns.GetAssignmentTypes(role, class)
    local out = {}
    local roleList = ns.ROLE_ASSIGNS[role] or {}
    for _, id in ipairs(roleList) do
        out[#out + 1] = { id = id, label = ns.ASSIGN_DEFS[id].label, def = ns.ASSIGN_DEFS[id] }
    end
    local classList = ns.CLASS_ASSIGNS[class] or {}
    for _, id in ipairs(classList) do
        out[#out + 1] = { id = id, label = ns.ASSIGN_DEFS[id].label, def = ns.ASSIGN_DEFS[id] }
    end
    return out
end
