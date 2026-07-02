local addonName, ns = ...

function ns.InitOptions()
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

    -- Register the container canvas to an options category
    local category = Settings.RegisterCanvasLayoutCategory(optionsContainer, addonName)
    Settings.RegisterAddOnCategory(category)
end