local _, ns = ...

-- All knowledge of the third-party Raid-Helper format lives here: importing the
-- event JSON and exporting a comp ("raidplan") for the comp API.

-- ---------------------------------------------------------------------------
-- Import mapping (generic role-only signups + ignored statuses). Real class
-- names map via ns.RH_CLASS_MAP, which is filled during class registration.
-- ---------------------------------------------------------------------------
ns.RH_GENERIC = {
    Tank = { class = "WARRIOR", role = "TANK" },
    Healer = { class = "PRIEST", role = "HEALER" },
    Melee = { class = "WARRIOR", role = "DPS" },
    Ranged = { class = "MAGE", role = "DPS" },
}

ns.RH_SKIP = {
    Absence = true, Bench = true, Late = true, Tentative = true,
}

ns.RH_ROLE_MAP = {
    Tanks = "TANK", Healers = "HEALER", Melee = "DPS", Ranged = "DPS",
}

-- Parses Raid-Helper event JSON into a fresh roster (not yet stored).
function ns.ParseRosterJSON(text)
    if type(text) ~= "string" or text:match("^%s*$") then
        return nil, "No text to import. Paste the Raid-Helper JSON first."
    end

    local data, err = ns.JSON.decode(text)
    if not data then
        return nil, "Could not parse JSON: " .. tostring(err)
    end
    if type(data) ~= "table" or type(data.signUps) ~= "table" then
        return nil, "JSON has no 'signUps' list. Use Raid-Helper's JSON output for an event."
    end

    local players = {}
    for _, su in ipairs(data.signUps) do
        if type(su) == "table" then
            local className = su.className
            local class, role
            if ns.RH_SKIP[className] then
                -- skip absence/bench/late/tentative
            elseif ns.RH_CLASS_MAP[className] then
                class = ns.RH_CLASS_MAP[className]
            elseif ns.RH_GENERIC[className] then
                class = ns.RH_GENERIC[className].class
                role = ns.RH_GENERIC[className].role
            end
            if class then
                role = role or ns.RH_ROLE_MAP[su.roleName] or "DPS"
                if ns.DPS_ONLY[class] then role = "DPS" end
                players[#players + 1] = {
                    name = su.name or "Unknown",
                    class = class,
                    role = role,
                    spec = su.specName,
                    position = tonumber(su.position) or 9999,
                    userId = su.userId and tostring(su.userId) or nil,
                }
            end
        end
    end

    table.sort(players, function(a, b)
        if a.position == b.position then return (a.name or "") < (b.name or "") end
        return a.position < b.position
    end)
    for _, p in ipairs(players) do
        if p.position >= 26 then
            p.backup = true
            p.slot = nil
        elseif p.position >= 1 and p.position <= 25 then
            p.backup = false
            p.slot = p.position
        else
            p.backup = true
            p.slot = nil
        end
    end

    local eventId = data.id and tostring(data.id) or ("local-" .. ns.RandomString(6))
    local roster = {
        id = eventId,
        isDuplicate = false,
        creator = ns.MyName(),
        editors = {},
        rev = 1,
        event = {
            title = data.displayTitle or data.title or "",
            date = data.date or "",
            time = data.time or "",
            eventId = eventId,
            creatorDiscord = data.leaderName or "",
            channelName = data.channelName or "",
        },
        players = players,
        assignments = {},
    }
    return roster
end

-- ---------------------------------------------------------------------------
-- Export helpers (class/spec -> Raid-Helper comp names + emotes). The tables
-- themselves are filled during class registration.
-- ---------------------------------------------------------------------------
function ns.RHExportClass(class)
    return ns.RH_CLASS_EXPORT[class]
end

function ns.RHExportSpec(class, spec)
    local m = ns.RH_SPEC_EXPORT[class]
    if not m then return nil end
    if spec and m[spec] then return m[spec] end
    local first = ns.SPECS[class] and ns.SPECS[class][1]
    return first and m[first] or nil
end

-- The comp id is the original event id (duplicates keep the source event's id),
-- since that is the comp the raidplan API edits.
local function compId(roster)
    return (roster.event and roster.event.eventId) or roster.id
end

-- Builds a Raid-Helper comp ("raidplan") object matching the /api/v4/comps/ID
-- shape. Only placed raid members (slots 1-25) are exported; backups are skipped
-- and assignments are intentionally left out.
function ns.BuildRaidPlanComp(roster)
    roster = roster or ns.GetActiveRoster()
    if not roster then return nil end
    ns.EnsureSlots(roster)

    local slots = {}
    for slot = 1, 25 do
        local p = ns.PlayerBySlot(roster, slot)
        if p and not ns.IsBackupPlayer(p) then
            local cls = ns.RHExportClass(p.class)
            local spc = ns.RHExportSpec(p.class, p.spec)
            slots[#slots + 1] = {
                name = p.name,
                id = p.userId or "",
                className = cls and cls.name or ns.ClassDisplay(p.class),
                specName = spc and spc[1] or (p.spec or ""),
                classEmoteId = cls and cls.emote or "",
                specEmoteId = spc and spc[2] or "",
                color = cls and cls.color or "#FFFFFF",
                isConfirmed = "unconfirmed",
                groupNumber = math.floor((slot - 1) / 5) + 1,
                slotNumber = ((slot - 1) % 5) + 1,
            }
        end
    end

    local groups = {}
    for g = 1, 5 do groups[g] = { name = "Group " .. g, position = g } end

    return {
        id = compId(roster),
        title = "Composition Tool",
        groupCount = 5,
        slotCount = 5,
        showRoles = true,
        showClasses = false,
        dividers = {},
        groups = groups,
        slots = slots,
    }
end

function ns.BuildRaidPlanJSON(roster)
    local comp = ns.BuildRaidPlanComp(roster)
    if not comp then return "" end
    return ns.JSON.encode(comp)
end

-- A ready-to-run curl that PATCHes the comp. The API key value is left as a
-- placeholder so the sensitive token never lives in the addon/clipboard.
function ns.BuildRaidPlanCurl(roster)
    roster = roster or ns.GetActiveRoster()
    if not roster then return "" end
    local json = ns.BuildRaidPlanJSON(roster)
    local safe = json:gsub("'", "'\\''")
    return table.concat({
        ("curl -X PATCH \"https://raid-helper.xyz/api/v4/comps/%s\" \\"):format(compId(roster)),
        "  -H \"Authorization: <YOUR_RAIDHELPER_API_KEY>\" \\",
        "  -H \"Content-Type: application/json\" \\",
        "  --data-raw '" .. safe .. "'",
    }, "\n")
end
