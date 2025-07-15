-- Handles UI dialogs
-- @author Abracadaniel22

local AddonName, Addon = ...
local AceGUI = LibStub("AceGUI-3.0")

local PlayerbotSpecChanger = LibStub("AceAddon-3.0"):GetAddon(PLAYERBOT_SPEC_CHANGER_ADDON_ID)
local API = PlayerbotSpecChanger.API

local UI = {}
PlayerbotSpecChanger.UI = UI

function UI:ShowUI()
    if self.dialogFrame then return end

    local targetName = API:GetTargetName()
    local targetClass = API:GetTargetClass()

    if API:IsTargetSelf() or not targetName or not targetClass then
        self.dialogFrame = self:ShowErrorDialog()
        return
    end

    self.dialogFrame = self:ShowMainDialog(targetName, targetClass)
end

function UI:ShowErrorDialog()
    local errFrame = AceGUI:Create("Frame")
    errFrame:SetTitle(PLAYERBOT_SPEC_CHANGER_ADDON_TITLE)
    errFrame:SetWidth(300)
    errFrame:SetHeight(120)
    errFrame:SetLayout("Flow")
    errFrame:SetCallback("OnClose", function(widget)
        self:CloseUI()
    end)
    errFrame:EnableResize(false)
    local label = AceGUI:Create("Label")
    label:SetText("No valid playerbot selected. Please target a playerbot character of a supported class.")
    label:SetFullWidth(true)
    errFrame:AddChild(label)
    return errFrame
end

function UI:ShowMainDialog(targetName, targetClass)
    local frame = AceGUI:Create("Frame")
    frame:SetTitle(PLAYERBOT_SPEC_CHANGER_ADDON_TITLE)
    frame:SetWidth(350)
    frame:SetHeight(210)
    frame:SetLayout("Flow")
    frame:EnableResize(false)
    frame:SetCallback("OnClose", function(widget)
        self:CloseUI()
    end)

    local specLabel = AceGUI:Create("Label")
    specLabel:SetText("Getting current spec...")
    specLabel:SetFullWidth(true)
    frame:AddChild(specLabel)

    API:GetBotCurrentSpec(targetName, function(spec)
        if spec and spec ~= "" then
            specLabel:SetText("Current spec: |cff00ff00" .. spec .. "|r")
        else
            specLabel:SetText("|cffff0000Could not get current spec.|r")
        end
    end)
    
    local label = AceGUI:Create("Label")
    label:SetText("Switching specs for character |cff00ff00" .. targetName .. "|r:")
    label:SetFullWidth(true)
    frame:AddChild(label)

    local dropdown = AceGUI:Create("Dropdown")
    local specList = {}
    local specValues = {}
    for i, spec in ipairs(API.CLASS_SPECS[targetClass]) do
        specList[i] = spec.label
        specValues[i] = spec.value
    end
    dropdown:SetList(specList)
    dropdown:SetLabel("Select a new spec:")
    dropdown:SetValue(1)
    dropdown:SetFullWidth(true)
    frame:AddChild(dropdown)

    local confirmBtn = AceGUI:Create("Button")
    confirmBtn:SetText("Confirm")
    confirmBtn:SetWidth(120)
    confirmBtn:SetCallback("OnClick", function()
        local selectedIndex = dropdown:GetValue() or 1
        local selectedSpec = specValues[selectedIndex]
        if selectedSpec then
            API:SendUpdateSpecCommands(targetName, selectedSpec)
        end
        self:CloseUI()
    end)
    frame:AddChild(confirmBtn)

    return frame
end

function UI:CloseUI()
    if self.dialogFrame then
        self.dialogFrame:Release()
        self.dialogFrame = nil
    end
end

function UI:RefreshUIIfOpen()
    if not self.dialogFrame then return end
    self:CloseUI()
    if API:GetTargetName() and API:GetTargetClass() then
        self:ShowUI()
    end
end
