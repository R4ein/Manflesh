local _, ns = ...

local HEADER = { "Player", "Class", "Spec", "Role", "Raid", "Boss", "Assignment" }

-- Tab/newline separated so it splits into columns/rows when pasted into Sheets.
function ns.BuildExportTSV(roster)
    roster = roster or ns.GetActiveRoster()
    if not roster then return "" end

    local lines = {}
    local ev = roster.event or {}
    lines[#lines + 1] = table.concat({ "Event", ev.title or "", ev.date or "", ev.time or "" }, "\t")
    lines[#lines + 1] = table.concat({ "Roster ID", roster.id or "", "Creator", roster.creator or "" }, "\t")
    lines[#lines + 1] = ""
    lines[#lines + 1] = table.concat(HEADER, "\t")

    for _, p in ipairs(roster.players or {}) do
        local class = ns.ClassDisplay(p.class)
        local spec = (p.spec and p.spec ~= "") and p.spec or ""
        local role = ns.RoleDisplay(p.role)
        local list = ns.GetAssignmentsSorted(roster, p.name)
        if #list > 0 then
            for _, a in ipairs(list) do
                lines[#lines + 1] = table.concat({
                    p.name, class, spec, role, a.raid or "", a.boss or "", a.display or "",
                }, "\t")
            end
        else
            lines[#lines + 1] = table.concat({ p.name, class, spec, role, "", "", "" }, "\t")
        end
    end

    return table.concat(lines, "\n")
end
