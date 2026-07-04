local addonName, ns = ...

function ns.InitializeOptionsMenu()
    -- Main options container canvas
    local optionsContainer = CreateFrame("Frame")

    -- Add scrollbar and scrollbox to canvas
    local scrollBar = CreateFrame("EventFrame", nil, optionsContainer, "MinimalScrollBar")
    scrollBar:SetPoint("TOPRIGHT", -10, -5)
    scrollBar:SetPoint("BOTTOMRIGHT", -10, 5)
    local scrollBox = CreateFrame("Frame", nil, optionsContainer, "WowScrollBoxList")
    scrollBox:SetPoint("TOPLEFT", 2, -2)
    scrollBox:SetPoint("BOTTOMRIGHT", scrollBar, "BOTTOMLEFT", -3, 0)

    -- Add header label
    local header = optionsContainer:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    header:SetPoint("TOPLEFT", optionsContainer, 15, -10)
    header:SetText(NORMAL_FONT_COLOR:WrapTextInColorCode(addonName))

    -- Add version & build label
    local version = C_AddOns.GetAddOnMetadata(addonName, "Version")
    local versionText = optionsContainer:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    versionText:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -5)
    versionText:SetText(WHITE_FONT_COLOR:WrapTextInColorCode("Version: " .. version .. " (" .. ns.BUILD .. ")"))

    -- Add test encounter button
    local testEncounterButton = ns.UI.AddButton(optionsContainer, "Test Encounter Frame", 160, nil)
    testEncounterButton:SetPoint("TOPLEFT", versionText, "BOTTOMLEFT", 0, -22)
    testEncounterButton:SetScript("OnClick", function()
        -- Pick a random raid + boss from the list of raids/bosses
        local raid = math.random(#ns.RAIDS)
        local raidName = ns.RAIDS[raid].name
        local boss = math.random(#ns.RAIDS[raid].bosses)
        local bossName = ns.RAIDS[raid].bosses[boss]
        
        if ns.UI then
            ns.UI.ShowEncounter(raidName, bossName)
        end
    end)

    -- TODO: Make this a list that is dynamically generated from the Preferences keys

    -- Add a preference option to show/hide the border around the assignment frame
    ns.UI.AddPreferenceCheckbox(
        optionsContainer,
        testEncounterButton,
        ns.Preferences.Options.SHOW_ENCOUNTER_FRAME_BORDER,
        "Show border for the encounter window.",
        function(self)
            ns.Preferences.Set(ns.Preferences.Options.SHOW_ENCOUNTER_FRAME_BORDER, self:GetChecked())
            ns.UI.ToggleEncounterBackdrop()
        end
    )
    -- Register the container canvas to an options category
    local category = Settings.RegisterCanvasLayoutCategory(optionsContainer, addonName)
    Settings.RegisterAddOnCategory(category)
end