local _, ns = ...

ns.RegisterClass({
    token = "WARLOCK",
    display = "Warlock",
    color = { 0.58, 0.51, 0.79 },
    dpsOnly = true,
    specs = { "Affliction", "Demonology", "Destruction" },
    specIcons = {
        ["Affliction"]  = "Interface\\Icons\\Spell_Shadow_DeathCoil",
        ["Demonology"]  = "Interface\\Icons\\Spell_Shadow_Metamorphosis",
        ["Destruction"] = "Interface\\Icons\\Spell_Shadow_RainOfFire",
    },
    rhExport = { name = "Warlock", emote = "579532029851336716", color = "#8788EE" },
    rhSpecExport = {
        ["Affliction"]  = { "Affliction", "637564406984867861" },
        ["Demonology"]  = { "Demonology", "637564407001513984" },
        ["Destruction"] = { "Destruction", "637564406682877964" },
    },
    assignments = {
        banish_mark = { label = "Banish <mark>", input = "mark", build = function(d) return "Banish {" .. ns.MarkDisplay(d.mark) .. "}" end },
        banish_text = { label = "Banish <custom target>", input = "text", build = function(d) return "Banish " .. d.text end },
    },
    assignOrder = { "banish_mark", "banish_text" },
})
