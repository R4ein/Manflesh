local _, ns = ...

ns.RegisterClass({
    token = "DRUID",
    display = "Druid",
    color = { 1.00, 0.49, 0.04 },
    specs = { "Balance", "Feral", "Restoration" },
    specIcons = {
        ["Balance"]     = "Interface\\Icons\\Spell_Nature_StarFall",
        ["Feral"]       = "Interface\\Icons\\Ability_Druid_CatForm",
        ["Restoration"] = "Interface\\Icons\\Spell_Nature_HealingTouch",
    },
    rhExport = { name = "Druid", emote = "579532029675438081", color = "#FF7C0A" },
    rhSpecExport = {
        ["Balance"]     = { "Balance", "637564171994529798" },
        ["Feral"]       = { "Feral", "637564172061900820" },
        ["Restoration"] = { "Restoration", "637564172007112723" },
    },
    assignments = {
        innervate = { label = "Innervate <player>", input = "target", build = function(d) return "Innervate " .. d.target end },
    },
    assignOrder = { "innervate" },
})
