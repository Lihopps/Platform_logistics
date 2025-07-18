local LPN_gui_manager=require("script.LPN_gui_manager")
local util = require("script.util")

local function on_entity_build(e)
    if not e.entity then return end
    if e.entity.name=="ptflog-provider" then  
        storage.ptflogchannel["DEFAULT"].building["ptflog-provider"][e.entity.unit_number]={
            reserved={}
        }
        storage.ptflogtracker[e.entity.unit_number]="DEFAULT"
        LPN_gui_manager.update_manager__gen_gui()
        --e.entity.operable=false
    end
end

local function on_entity_disapear(e)
    local entity = e.entity
	if not entity or not entity.valid then
		return
	end
	if entity.name == "ptflog-provider" then
        local channel = storage.ptflogtracker[entity.unit_number]
        if util.check(channel,entity,{name="iron-plate",quality="common"},"provider") then
            storage.ptflogchannel[channel].building["ptflog-provider"][entity.unit_number] = nil
            storage.ptflogtracker[entity.unit_number]=nil
            LPN_gui_manager.update_manager__gen_gui()
        end
	end

end

local provider={}

provider.events={
    [defines.events.on_built_entity]=on_entity_build,
	[defines.events.on_robot_built_entity]=on_entity_build,
    [defines.events.on_pre_player_mined_item]=on_entity_disapear,
	[defines.events.on_robot_pre_mined]=on_entity_disapear,
	[defines.events.on_entity_died]=on_entity_disapear,
	[defines.events.script_raised_destroy]=on_entity_disapear,
}

return provider