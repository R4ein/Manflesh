local _, ns = ...

ns.RegisterClass({
    token = "MAGE",
    display = "Mage",
    color = { 0.41, 0.80, 0.94 },
    dpsOnly = true,
    specs = { "Arcane", "Fire", "Frost" },
    specIcons = {
        ["Arcane"] = "Interface\\Icons\\Spell_Holy_MagicalSentry",
        ["Fire"]   = "Interface\\Icons\\Spell_Fire_FireBolt02",
        ["Frost"]  = "Interface\\Icons\\Spell_Frost_FrostBolt02",
    },
    rhExport = { name = "Mage", emote = "579532030161977355", color = "#3FC7EB" },
    rhSpecExport = {
        ["Arcane"] = { "Arcane", "637564231545389056" },
        ["Fire"]   = { "Fire", "637564231239073802" },
        ["Frost"]  = { "Frost", "637564231469891594" },
    },
    assignments = {
        sheep_mark = { label = "Sheep <mark>", input = "mark", build = function(d) return "Sheep {" .. ns.MarkDisplay(d.mark) .. "}" end },
        sheep_text = { label = "Sheep <custom target>", input = "text", build = function(d) return "Sheep " .. d.text end },
    },
    assignOrder = { "sheep_mark", "sheep_text" },
})
