EW_AIModeSelection = {}

function EW_AIModeSelection.onRegisterActionEvents(self, _, _)
	if self.isClient then
		local spec = self.spec_aiModeSelection
		if self:getIsActiveForInput(true, true) then
			local _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.EASYWORKER_OPEN_AI_SCREEN, self, EW_AIModeSelection.onOpenAIScreen, false, true, false, true, nil)
			AIModeSelection.updateActionEvents(self)
		end
	end
end

AIModeSelection.onRegisterActionEvents = Utils.appendedFunction(AIModeSelection.onRegisterActionEvents, EW_AIModeSelection.onRegisterActionEvents)

function EW_AIModeSelection.updateActionEvents(self)
	local spec = self.spec_aiModeSelection
	local actionEvent = spec.actionEvents[InputAction.EASYWORKER_OPEN_AI_SCREEN]
	if actionEvent ~= nil and self.isActiveForInputIgnoreSelectionIgnoreAI then
		g_inputBinding:setActionEventText(actionEvent.actionEventId, g_i18n:getText("action_open_ai_screen"))
		g_inputBinding:setActionEventTextPriority(actionEvent.actionEventId, GS_PRIO_HIGH)
		g_inputBinding:setActionEventActive(actionEvent.actionEventId, self:getCanToggleAIVehicle())
	end
end

AIModeSelection.updateActionEvents = Utils.appendedFunction(AIModeSelection.updateActionEvents, EW_AIModeSelection.updateActionEvents)

function EW_AIModeSelection.onOpenAIScreen()
    local vehicle = g_localPlayer.getCurrentVehicle()
    g_inGameMenu:openAIScreen(vehicle)
end

-- startGoToJob