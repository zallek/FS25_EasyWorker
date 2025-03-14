EW_InGameMenuContractsFrame = {}

function EW_InGameMenuContractsFrame.initialize(self)
    -- Didn't succeed to append the function to the original one.
end

function EW_InGameMenuContractsFrame.setButtonsForState(self, state, canLease)
    if self.startFieldWorkButtonInfo == nil then
        self.startFieldWorkButtonInfo = {
            ["inputAction"] = InputAction.EASYWORKER_MENU_START_FIELDWORK,
            ["text"] = g_i18n:getText("button_start_fieldwork"),
            ["callback"] = function()
                self:onButtonStartFieldWork()
            end
        }
    end

    local buttons = self.menuButtonInfo
    if state == InGameMenuContractsFrame.BUTTON_STATE.ACTIVE then
        table.insert(buttons, self.startFieldWorkButtonInfo)
        local vehicule = g_localPlayer.getCurrentVehicle()
        local hasPermission = g_currentMission:getHasPlayerPermission("hireAssistant")
        local isAvailable = vehicule and AIJobFieldWork:getIsAvailableForVehicle(vehicule) and not vehicule:getIsAIActive()
        self.startFieldWorkButtonInfo.disabled = not hasPermission or not isAvailable
    end
    self.menuButtonInfo = buttons
    self:setMenuButtonInfoDirty()
end

InGameMenuContractsFrame.setButtonsForState = Utils.appendedFunction(InGameMenuContractsFrame.setButtonsForState, EW_InGameMenuContractsFrame.setButtonsForState)

function EW_InGameMenuContractsFrame.onButtonStartFieldWork(self)
    local vehicule = g_localPlayer.getCurrentVehicle()
    if vehicule == nil then
        return
    end

    local contract = self:getSelectedContract()
    if contract == nil then
        return
    end
    local field = contract.mission.field

    local job = g_currentMission.aiJobTypeManager:createJob(AIJobType.FIELDWORK)
    job.vehicleParameter:setVehicle(vehicule)
    job.positionAngleParameter:setPosition(field.posX, field.posZ)
    job.positionAngleParameter:setAngle(0)
    job:setValues()
    local isValid, error = job:validate(g_localPlayer.farmId)
    if isValid then
        g_inGameMenu:openMapOverview()
        g_inGameMenu.pageMapOverview:tryStartJob(job, g_localPlayer.farmId, function(success)
            if success then
            end
        end)
    else
        InfoDialog.show(tostring(error), nil, nil, DialogElement.TYPE_WARNING)
        return false
    end
end

InGameMenuContractsFrame.onButtonStartFieldWork = EW_InGameMenuContractsFrame.onButtonStartFieldWork
