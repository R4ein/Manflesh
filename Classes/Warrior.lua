local _, ns = ...

ns.RegisterClass({
    token = "WARRIOR",
    display = "Warrior",
    color = { 0.78, 0.61, 0.43 },
    specs = { "Arms", "Fury", "Protection" },
    specIcons = {
        ["Arms"]       = "Interface\\Icons\\Ability_Warrior_SavageBlow",
        ["Fury"]       = "Interface\\Icons\\Ability_Warrior_InnerRage",
        ["Protection"] = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
    },
    rhExport = { name = "Warrior", emote = "579532030153588739", color = "#C69B6D" },
    rhSpecExport = {
        ["Arms"]       = { "Arms", "637564445031399474" },
        ["Fury"]       = { "Fury", "637564445215948810" },
        ["Protection"] = { "Protection", "637564444834136065" },
    },
})
