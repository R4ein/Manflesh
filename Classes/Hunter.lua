local _, ns = ...

ns.RegisterClass({
    token = "HUNTER",
    display = "Hunter",
    color = { 0.67, 0.83, 0.45 },
    dpsOnly = true,
    specs = { "Beast Mastery", "Marksmanship", "Survival" },
    specIcons = {
        ["Beast Mastery"] = "Interface\\Icons\\Ability_Hunter_BeastTaming",
        ["Marksmanship"]  = "Interface\\Icons\\Ability_Marksmanship",
        ["Survival"]      = "Interface\\Icons\\Ability_Hunter_SwiftStrike",
    },
    rhExport = { name = "Hunter", emote = "579532029880827924", color = "#AAD372" },
    rhSpecExport = {
        ["Beast Mastery"] = { "Beastmastery", "637564202021814277" },
        ["Marksmanship"]  = { "Marksmanship", "637564202084466708" },
        ["Survival"]      = { "Survival", "637564202130866186" },
    },
    assignments = {
        misdirection_mark = {
            label = "Misdirection <mark> -> <player>",
            input = "mark_target",
            build = function(d)
                return "Misdirection {" .. ns.MarkDisplay(d.mark) .. "} -> " .. (d.target or "?")
            end,
        },
        misdirection_boss = {
            label = "Misdirection BOSS -> <player>",
            input = "target",
            build = function(d)
                return "Misdirection BOSS -> " .. (d.target or "?")
            end,
        },
        misdirection_text = {
            label = "Misdirection <custom> -> <player>",
            input = "text_target",
            build = function(d)
                return "Misdirection " .. (d.text or "?") .. " -> " .. (d.target or "?")
            end,
        },
    },
    assignOrder = { "misdirection_mark", "misdirection_boss", "misdirection_text" },
})
