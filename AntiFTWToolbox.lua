-------------------------------------------------------------------------------------------------
--  Libraries --
-------------------------------------------------------------------------------------------------
local LAM2 = LibAddonMenu2 --This global variable LibAddonMenu2 only exists with LAM version 2.0 r28 or higher!

-------------------------------------------------------------------------------------------------
--  Variable Definitions --
-------------------------------------------------------------------------------------------------

AntiFTWToolbox = {};

-- define name, used for regestering events
AntiFTWToolbox.name = "AntiFTWToolbox";
AntiFTWToolbox.version = 1;

AntiFTWToolbox.guildMessage = 0;
AntiFTWToolbox.unreadMessage = false; 

AntiFTWToolbox.Default = {
  offsetX = 958,
  offsetY = 125,
  show = true,
  guild1 = true,
  guild2 = true,
  guild3 = true,
  guild4 = true,
  guild5 = true,
  whisper = true,
};

-------------------------------------------------------------------------------------------------
--  Initialize Function --
-------------------------------------------------------------------------------------------------
function AntiFTWToolbox:Initialize()
   self.savedVariables = ZO_SavedVars:NewAccountWide("AntiFTWToolboxVariables", AntiFTWToolbox.version, nil, AntiFTWToolbox.Default)

   AntiFTWToolbox.CreateSettingsWindow()
   EVENT_MANAGER:RegisterForEvent(AntiFTWToolbox.name, EVENT_CHAT_MESSAGE_CHANNEL, self.chatCallback);
   AntiFTWToolbox.guildMessage = 0;
   AntiFTWToolbox.unreadMessage = false;
   self:RestorePosition();
   --AntiFTWToolbox.CreateSettingsWindow();
   --CirconianStaminaBarWindow:SetHidden(not AntiFTWToolbox.savedVariables.Show)
end

function AntiFTWToolbox.hideCommand()
  AntiFTWToolbox.unreadMessage = false;
  AntiFTWToolboxIndicator:SetHidden(not AntiFTWToolbox.unreadMessage);
end

function hideCommand()
	AntiFTWToolbox:hideCommand();
end

-------------------------------------------------------------------------------------------------
--  OnAddOnLoaded  --
-------------------------------------------------------------------------------------------------
function AntiFTWToolbox.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName ~= AntiFTWToolbox.name then return end
  AntiFTWToolbox:Initialize();
  SLASH_COMMANDS["/ftw"] = hideCommand;
 
end

-------------------------------------------------------------------------------------------------
--  chatCallback  --
-------------------------------------------------------------------------------------------------
function AntiFTWToolbox.chatCallback(eventCode, messageType, fromName, text)
  if(AntiFTWToolbox.savedVariables.show) then
    if (AntiFTWToolbox.savedVariables.guild1 and (messageType == CHAT_CHANNEL_GUILD_1 or messageType == CHAT_CHANNEL_OFFICER_1)) then
      AntiFTWToolbox.guildMessage = 1;
      AntiFTWToolbox.unreadMessage = true;
    elseif (AntiFTWToolbox.savedVariables.guild2 and (messageType == CHAT_CHANNEL_GUILD_2 or messageType == CHAT_CHANNEL_OFFICER_2)) then
      AntiFTWToolbox.guildMessage = 2;
      AntiFTWToolbox.unreadMessage = true;
    elseif (AntiFTWToolbox.savedVariables.guild3 and (messageType == CHAT_CHANNEL_GUILD_3 or messageType == CHAT_CHANNEL_OFFICER_3)) then
      AntiFTWToolbox.guildMessage = 3;
      AntiFTWToolbox.unreadMessage = true;
    elseif (AntiFTWToolbox.savedVariables.guild4 and (messageType == CHAT_CHANNEL_GUILD_4 or messageType == CHAT_CHANNEL_OFFICER_4)) then
      AntiFTWToolbox.guildMessage = 4;
      AntiFTWToolbox.unreadMessage = true;
    elseif (AntiFTWToolbox.savedVariables.guild5 and (messageType == CHAT_CHANNEL_GUILD_5 or messageType == CHAT_CHANNEL_OFFICER_5)) then
      AntiFTWToolbox.guildMessage = 5;
      AntiFTWToolbox.unreadMessage = true;
    elseif (AntiFTWToolbox.savedVariables.whisper and (messageType == CHAT_CHANNEL_WHISPER)) then
      AntiFTWToolbox.guildMessage = 6;
      AntiFTWToolbox.unreadMessage = true;
    end
  end



  if(GetDisplayName() == fromName) then
  	AntiFTWToolbox.unreadMessage = false;
  end
  if (string.match(text, "wtfanti")) then
  	AntiFTWToolbox.unreadMessage = true;
  end

  AntiFTWToolboxIndicator:SetHidden(not AntiFTWToolbox.unreadMessage)

  --return false = run the other event callback functions for the same event
  --return true = don#t run the other event callback functions for this event as you tell them by "true":    Everything was done already in this function here
  --The same applies to ZoPreHook() and ZoPreHookHandler() functions
  return false
end

function AntiFTWToolbox.OnIndicatorMoveStop()
  AntiFTWToolbox.savedVariables.offsetX = AntiFTWToolboxIndicator:GetLeft()
  AntiFTWToolbox.savedVariables.offsetY = AntiFTWToolboxIndicator:GetTop()
end

function AntiFTWToolbox:RestorePosition()
  local x = self.savedVariables.offsetX
  local y = self.savedVariables.offsetY
 
  AntiFTWToolboxIndicator:ClearAnchors()
  AntiFTWToolboxIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, x, y)
end

-------------------------------------------------------------------------------------------------
--  Menu Functions --
-------------------------------------------------------------------------------------------------
function AntiFTWToolbox.CreateSettingsWindow()
  local panelData = {
    type = "panel",
    name = "AntiFTWs Toolbox",
    displayName = "AntiFTWs Toolbox",
    author = "AntiFTW",
    version = AntiFTWToolbox.version,
    slashCommand = "/ftw",
    registerForRefresh = true,
    registerForDefaults = true,
  }

  local cntrlOptionsPanel = LAM2:RegisterAddonPanel("AntiFTW_Toolbox", panelData);
  local optionsData = {
    [1] = {
      type = "header",
      name = "AntiFTW Toolbox Settings"
    },
    [2] = {
      type = "description",
      text = "Here you can define which parts of the toolbox you want to use."
    },
    [3] = {
      type = "checkbox",
      name = "Show Chat Warning",
      tooltip = "When ON the chat warning will be visible. When OFF the chat warning will be hidden.",
      default = true,
      getFunc = function() return AntiFTWToolbox.savedVariables.Show end,
      setFunc = function(newValue) 
        AntiFTWToolbox.savedVariables.Show = newValue
        AntiFTWToolboxIndicator:SetHidden(not newValue)  end,
    },
    [4] = {
      type = "checkbox",
      name = "Whisper",
      tooltip = "When ON the chat warning will work for whispers. When OFF the chat warning will not.",
      default = true,
      getFunc = function() return AntiFTWToolbox.savedVariables.whisper end,
      setFunc = function(newValue) 
        AntiFTWToolbox.savedVariables.whisper = newValue end,
    },
    [5] = {
      type = "checkbox",
      name = "Guild 1",
      tooltip = "When ON the chat warning will work for guild 1. When OFF the chat warning will not.",
      default = true,
      getFunc = function() return AntiFTWToolbox.savedVariables.guild1 end,
      setFunc = function(newValue) 
        AntiFTWToolbox.savedVariables.guild1 = newValue end,
    },
    [6] = {
      type = "checkbox",
      name = "Guild 2",
      tooltip = "When ON the chat warning will work for guild 2. When OFF the chat warning will not.",
      default = true,
      getFunc = function() return AntiFTWToolbox.savedVariables.guild2 end,
      setFunc = function(newValue) 
        AntiFTWToolbox.savedVariables.guild2 = newValue end,
    },
    [7] = {
      type = "checkbox",
      name = "Guild 3",
      tooltip = "When ON the chat warning will work for guild 3. When OFF the chat warning will not.",
      default = true,
      getFunc = function() return AntiFTWToolbox.savedVariables.guild3 end,
      setFunc = function(newValue) 
        AntiFTWToolbox.savedVariables.guild3 = newValue end,
    },
    [8] = {
      type = "checkbox",
      name = "Guild 4",
      tooltip = "When ON the chat warning will work for guild 4. When OFF the chat warning will not.",
      default = true,
      getFunc = function() return AntiFTWToolbox.savedVariables.guild4 end,
      setFunc = function(newValue) 
        AntiFTWToolbox.savedVariables.guild4 = newValue end,
    },
    [9] = {
      type = "checkbox",
      name = "Guild 5",
      tooltip = "When ON the chat warning will work for guild 5. When OFF the chat warning will not.",
      default = true,
      getFunc = function() return AntiFTWToolbox.savedVariables.guild5 end,
      setFunc = function(newValue) 
        AntiFTWToolbox.savedVariables.guild5 = newValue end,
    },
  }
  LAM2:RegisterOptionControls("AntiFTW_Toolbox", optionsData)
end

-------------------------------------------------------------------------------------------------
--  Register Events --
-------------------------------------------------------------------------------------------------
EVENT_MANAGER:RegisterForEvent(AntiFTWToolbox.name, EVENT_ADD_ON_LOADED, AntiFTWToolbox.OnAddOnLoaded);