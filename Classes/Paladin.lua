local _, ns = ...

ns.RegisterClass({
    token = "PALADIN",
    display = "Paladin",
    color = { 0.96, 0.55, 0.73 },
    specs = { "Holy", "Protection", "Retribution" },
    specIcons = {
        ["Holy"]        = "Interface\\Icons\\Spell_Holy_HolyBolt",
        ["Protection"]  = "Interface\\Icons\\Spell_Holy_DevotionAura",
        ["Retribution"] = "Interface\\Icons\\Spell_Holy_AuraOfLight",
    },
    rhExport = { name = "Paladin", emote = "579532029906124840", color = "#F48CBA" },
    rhSpecExport = {
        ["Holy"]        = { "Holy1", "637564297622454272" },
        ["Protection"]  = { "Protection1", "637564297647489034" },
        ["Retribution"] = { "Retribution", "637564297953673216" },
    },
})
