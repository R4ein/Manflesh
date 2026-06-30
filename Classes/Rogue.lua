local _, ns = ...

ns.RegisterClass({
    token = "ROGUE",
    display = "Rogue",
    color = { 1.00, 0.96, 0.41 },
    dpsOnly = true,
    specs = { "Assassination", "Combat", "Subtlety" },
    specIcons = {
        ["Assassination"] = "Interface\\Icons\\Ability_Rogue_Eviscerate",
        ["Combat"]        = "Interface\\Icons\\Ability_BackStab",
        ["Subtlety"]      = "Interface\\Icons\\Ability_Stealth",
    },
    rhExport = { name = "Rogue", emote = "579532030086217748", color = "#FFF468" },
    rhSpecExport = {
        ["Assassination"] = { "Assassination", "637564351707873324" },
        ["Combat"]        = { "Combat", "637564352333086720" },
        ["Subtlety"]      = { "Subtlety", "637564352169508892" },
    },
    assignments = {
        imp_expose = { label = "Improved Expose Armor", build = function() return "Improved Expose Armor on target" end },
    },
    assignOrder = { "imp_expose" },
})
