local _, ns = ...

ns.RegisterClass({
    token = "PRIEST",
    display = "Priest",
    color = { 1.00, 1.00, 1.00 },
    specs = { "Discipline", "Holy", "Shadow" },
    specIcons = {
        ["Discipline"] = "Interface\\Icons\\Spell_Holy_WordFortitude",
        ["Holy"]       = "Interface\\Icons\\Spell_Holy_HolyNova",
        ["Shadow"]     = "Interface\\Icons\\Spell_Shadow_ShadowWordPain",
    },
    rhExport = { name = "Priest", emote = "579532029901799437", color = "#FFFFFF" },
    rhSpecExport = {
        ["Discipline"] = { "Discipline", "637564323442720768" },
        ["Holy"]       = { "Holy", "637564323530539019" },
        ["Shadow"]     = { "Shadow", "637564323291725825" },
    },
})
