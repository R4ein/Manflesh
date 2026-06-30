local _, ns = ...

ns.RegisterClass({
    token = "SHAMAN",
    display = "Shaman",
    color = { 0.00, 0.44, 0.87 },
    specs = { "Elemental", "Enhancement", "Restoration" },
    specIcons = {
        ["Elemental"]   = "Interface\\Icons\\Spell_Nature_Lightning",
        ["Enhancement"] = "Interface\\Icons\\Spell_Nature_LightningShield",
        ["Restoration"] = "Interface\\Icons\\Spell_Nature_MagicImmunity",
    },
    rhExport = { name = "Shaman", emote = "579532030056857600", color = "#0070DD" },
    rhSpecExport = {
        ["Elemental"]   = { "Elemental", "637564379595931649" },
        ["Enhancement"] = { "Enhancement", "637564379772223489" },
        ["Restoration"] = { "Restoration1", "637564379847458846" },
    },
    assignments = {
        bloodlust = { label = "Bloodlust on encounter", build = function() return "Bloodlust on this encounter" end },
    },
    assignOrder = { "bloodlust" },
})
