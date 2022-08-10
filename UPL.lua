--[[
    

██    ██ ███    ██ ██ ███████ ██ ███████ ██████      ██████  ██████  ███████ ██████      ██      ██ ██████  ██████   █████  ██████  ██    ██ 
██    ██ ████   ██ ██ ██      ██ ██      ██   ██     ██   ██ ██   ██ ██      ██   ██     ██      ██ ██   ██ ██   ██ ██   ██ ██   ██  ██  ██  
██    ██ ██ ██  ██ ██ █████   ██ █████   ██   ██     ██████  ██████  █████   ██   ██     ██      ██ ██████  ██████  ███████ ██████    ████   
██    ██ ██  ██ ██ ██ ██      ██ ██      ██   ██     ██      ██   ██ ██      ██   ██     ██      ██ ██   ██ ██   ██ ██   ██ ██   ██    ██    
 ██████  ██   ████ ██ ██      ██ ███████ ██████      ██      ██   ██ ███████ ██████      ███████ ██ ██████  ██   ██ ██   ██ ██   ██    ██    
                                                                                                                                             
                                                                                                                                                       
]]

--[[
    Last Modified: 08/10/2022
    Last Modified by: Luck
]]

local UPL       = {}
local URL       = "https://raw.githubusercontent.com/jpmorenorj/UPL-Bruhwalker/main/"
local ark_pred  = _G.Prediction
pred:use_prediction()
local print = function(ctx)
    console:log(tostring(ctx))
end

local version = 1.0
local function class()
    local cls = {}
    cls.__index = cls
    return setmetatable(cls, {__call = function (c, ...)
        local instance = setmetatable({}, cls)
        if cls.__init then
            cls.__init(instance, ...)
        end
        return instance
    end})
end

local function AutoUpdate()
    local result = http:get(URL .. "UPL.version")
    if result and result ~= "" and tonumber(result) > Version then
        http:download_file(URL .. "UPL.lua", "UPL.lua")
        console:log("[Unified Prediction Library] Successfully updated. Please reload!")
    end
end

local _Utility = class()
Utility = nil

function _Utility:__init()
    Utility = self
end

local _Prediction = class()
Prediction = nil

function _Prediction:__init()

    if self.init == nil then
        self:LoadMenu()
    end

    self.init  = true 
    Prediction = self
end

function _Prediction:LoadMenu()
    self.settings            = {}
    self.preds               = {"Internal", "Ark"}
    self.s_menu              = menu:add_category("Pred Settings")
    self.settings.prediction = menu:add_combobox("Prediction: ", self.s_menu, self.preds, 0)
end

-- [[ STRUCTS FROM ARK'S PREDICTION ]] --

--[[
    prediction_input:
        > source - the unit that the skillshot will be launched from [game_object/vec3]
        > hitbox - indicates if the unit bounding radius should be included in calculations [boolean]
        > speed - the skillshot speed in units per second [number]
        > range - the skillshot range in units [number]
        > delay - the skillshot initial delay before release [number]
        > radius - the skillshot radius (for non-conic skillshots) [number]
        > angle - the skillshot angle (for conic skillshots) [number]
        > collision - determines the collision flags for the skillshot [table]:
        ({"minion", "ally_hero", "enemy_hero", "wind_wall", "terrain_wall"})
        > type - the skillshot type: ("linear", "circular", "conic") [string]

    prediction_output:
        > cast_pos - the skillshot cast position [vec3]
        > pred_pos - the predicted unit position [vec3]
        > hit_chance - the calculated skillshot hit chance [number]
        > hit_count - the area of effect hit count [number]
        > time_to_hit - the total skillshot arrival time [number]

    attack_data (health prediction):
        > processed - indicates if sent attack has been completed [boolean]
        > timer - the start time of launched attack [number]
        > source - the source which has launched the attack [game_object]
        > target - the target which is going to take a damage [game_object]
        > windup_time - the source attack windup time [number]
        > animation_time - the source attack animation time [number]
        > speed - the projectile speed of sent attack [number]
        > damage - the predicted attack damage to target [number]
]]

--[[
    function: UPL:calc_auto_attack_damage(source, unit)

    Parameters: 
        source - game_object
        unit   - game_object

    Return: number

    Comment: Returns auto attack damage to unit from source
--]]

function _Prediction:calc_auto_attack_damage(source, unit)
    return ark_pred:calc_auto_attack_damage(source, unit)
end

--[[
    function: UPL:get_aoe_prediction(input, unit)

    Parameters: 
        input  - prediction_input (table)
        unit   - game_object

    Return: prediction_output (table)
    
    Comment: Returns AoE prediction and hit count
--]]


function _Prediction:get_aoe_prediction(input, unit)
    return ark_pred:get_aoe_prediction(input, unit)
end

--[[
    function: UPL:get_aoe_position(input, points, star_target)

    Parameters: 
        input       - prediction_input (table)
        points      - [game_object | vec3] (table)
        star_target - [game_object | vec3] (optional)

    Return: [position | hit_count] (table)
    
    Comment: Returns AoE prediction and hit count
--]]

function _Prediction:get_aoe_position(input, points, star_target)
    return ark_pred:get_aoe_position(input, points, star_target)
end

--[[
    function: UPL:get_collision(input, end_pos, obj)

    Parameters: 
        input   - prediction_input (table)
        end_pos - vec3
        obj     - game_object (optional)

    Return: table
    
    Comment: Returns table of game_objects that are in collision within input
--]]

function _Prediction:get_collision(input, end_pos, obj)
    return ark_pred:get_collision(input, end_pos, obj)
end

--[[
    function: UPL:get_fast_prediction(source, unit, speed, delay)

    Parameters: 
        source  - [game_object | vec3]
        unit    - game_object
        speed   - number
        delay   - number

    Return: vec3
    
    Comment: Returns prediction result as vec3
--]]

function _Prediction:get_fast_prediction(source, unit, speed, delay)
    return ark_pred:get_fast_prediction(source, unit, speed, delay)
end

--[[
    function: UPL:get_health_prediction(unit, delta, delay)

    Parameters: 
        unit    - game_object
        delta   - number
        delay   - number

    Return: number
    
    Comment: Returns predicted health
--]]

function _Prediction:get_health_prediction(unit, delta, delay)
    return ark_pred:get_health_prediction(unit, delta, delay)
end

--[[
    function: UPL:get_lane_clear_health_prediction(unit, delta)

    Parameters: 
        unit    - game_object
        delta   - number

    Return: number
    
    Comment: Returns predicted health
--]]

function _Prediction:get_lane_clear_health_prediction(unit, delta)
    return ark_pred:get_lane_clear_health_prediction(unit, delta)
end

--[[
    function: UPL:get_position_after(unit, delta, skip_latency)

    Parameters: 
        unit         - game_object
        delta        - number
        skip_latency - boolean

    Return: vec3
    
    Comment: Returns unit position after delta time
--]]

function _Prediction:get_position_after(unit, delta, skip_latency)
    return ark_pred:get_position_after(unit, delta, skip_latency)
end

--[[
    function: UPL:get_prediction(input, target)

    Parameters: 
        input  - prediction_input (table)
        target - game_object

    Return: prediction_output (table)
    
    Comment: Returns prediction result
--]]

function _Prediction:get_prediction(input, target)
    local source    = input.source or game.local_player
    local hitbox    = input.hitbox or true
    local speed     = input.speed
    local range     = input.range
    local delay     = input.delay
    local radius    = input.radius
    local angle     = input.angle
    local collision = input.collision
    local _type     = input.type

    if menu:get_value(self.settings.prediction) == 1 then -- [ ARK PRED ]
        return ark_pred:get_prediction(input, target)
    end

    if source.origin then
        source = vec3.new(source.origin.x, source.origin.y, source.origin.z)
    end

    local collides_wall   = input.collision["wind_wall"] or false
    local collides_minion = input.collision["enemy_minion"] or false

    return pred:predict(speed, delay, range, radius, target, collides_wall, collides_minion, source)
end

--[[
    function: UPL:get_hero_aggro(unit)

    Parameters: 
        unit - game_object

    Return: attack_data (table)
--]]

function _Prediction:get_hero_aggro(unit)
    return ark_pred:get_hero_aggro(unit)
end

--[[
    function: UPL:get_immobile_duration(unit)

    Parameters: 
        unit - game_object

    Return: number
--]]

function _Prediction:get_immobile_duration(unit)
    return ark_pred:get_immobile_duration(unit)
end

--[[
    function: UPL:get_invulnerable_duration(unit)

    Parameters: 
        unit - game_object

    Return: number
--]]

function _Prediction:get_invulnerable_duration(unit)
    return ark_pred:get_invulnerable_duration(unit)
end

--[[
    function: UPL:get_invisible_duration(unit)

    Parameters: 
        unit - game_object

    Return: number
--]]

function _Prediction:get_invisible_duration(unit)
    return ark_pred:get_invisible_duration(unit)
end

--[[
    function: UPL:get_minion_aggro(unit)

    Parameters: 
        unit - game_object

    Return: attack_data (table)
--]]

function _Prediction:get_minion_aggro(unit)
    return ark_pred:get_minion_aggro(unit)
end

--[[
    function: UPL:get_movement_speed(unit)

    Parameters: 
        unit - game_object

    Return: number
--]]

function _Prediction:get_movement_speed(unit)
    return ark_pred:get_movement_speed(unit)
end

--[[
    function: UPL:get_turret_aggro(unit)

    Parameters: 
        unit - game_object

    Return: attack_data (table)
--]]

function _Prediction:get_turret_aggro(unit)
    return ark_pred:get_turret_aggro(unit)
end

--[[
    function: UPL:get_waypoints(unit)

    Parameters: 
        unit - game_object

    Return: (table) [vec3] 
--]]

function _Prediction:get_waypoints(unit)
    return ark_pred:get_waypoints(unit)
end

--[[
    function: UPL:get_waypoints(unit)

    Parameters: 
        unit - game_object

    Return: (table) [vec3] 
--]]

function _Prediction:get_waypoints(unit)
    return ark_pred:get_waypoints(unit)
end


_Utility()

_G.UPL = _Prediction()

AutoUpdate()

