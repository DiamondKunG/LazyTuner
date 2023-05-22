local INITIAL_DRIVE_FORCE = "fInitialDriveForce"
local INITIAL_DRIVE_MAX_FLAT_VEL = "fInitialDriveMaxFlatVel"
local BRAKE_BIAS_FRONT = "fBrakeBiasFront"
local BRAKE_FORCE = "fBrakeForce"
local STEERING_LOCK = "fSteeringLock"
local ANTI_ROLL_BAR_BIAS_FRONT = "fAntiRollBarBiasFront"
local TRACTION_CURVE_MIN = "fTractionCurveMin"
local TRACTION_CURVE_MAX = "fTractionCurveMax"

function getVehData(veh)
    if not DoesEntityExist(veh) then return nil end
    local lvehstats = {
        boost = GetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce"),
        drivemax = GetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveMaxFlatVel"),
        braking = GetVehicleHandlingFloat(veh ,"CHandlingData", "fBrakeBiasFront"),
        roll = GetVehicleHandlingFloat(veh, "CHandlingData", "fAntiRollBarBiasFront"),
        brakeforce = GetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeForce"),
        min = GetVehicleHandlingFloat(veh, "CHandlingData", "fTractionCurveMin"),
        max = GetVehicleHandlingFloat(veh, "CHandlingData", "fTractionCurveMax"),
        steer = GetVehicleHandlingFloat(veh, "CHandlingData", "fSteeringLock")
    }
    return lvehstats
end

-- Function to set the vehicle handling
function SetVehicleHandling(vehicle, boost, drivemax , braking , roll , brakeforce ,min ,max ,steer)
  SetVehicleHandlingField(vehicle, 'CHandlingData', INITIAL_DRIVE_FORCE, tonumber(boost) *1.0)
  SetVehicleEnginePowerMultiplier(vehicle, boost*1.0)
  SetVehicleHandlingField(vehicle, 'CHandlingData', INITIAL_DRIVE_MAX_FLAT_VEL, tonumber(drivemax)*1.0)
  SetVehicleHandlingField(vehicle, 'CHandlingData', BRAKE_BIAS_FRONT, tonumber(braking)*1.0)
  SetVehicleHandlingField(vehicle, 'CHandlingData', BRAKE_FORCE, tonumber(brakeforce)*1.0)
  SetVehicleHandlingField(vehicle, 'CHandlingData', STEERING_LOCK, tonumber(steer))
  SetVehicleHandlingField(vehicle, 'CHandlingData', ANTI_ROLL_BAR_BIAS_FRONT, tonumber(roll)*1.0)
  SetVehicleHandlingField(vehicle, 'CHandlingData', TRACTION_CURVE_MIN, tonumber(min)*1.0)
  SetVehicleHandlingField(vehicle, 'CHandlingData',  TRACTION_CURVE_MAX, tonumber(max)*1.0)
end

-- Command to set multiple vehicle handling values for the current vehicle
RegisterCommand("tuner", function(source, args)
  local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
  
  if #args == 8 then
    local stats = getVehData(vehicle)
    local boost = args[1] -- 1 
    local drivemax = args[2] --2
    local braking = args[3] -- 3
    local roll =  args[6]
    local brakeforce =  args[4] --4 
    local min = args[7] 
    local max =  args[8]
    local steer = args[5]
    print(boost, drivemax , braking ,roll,brakeforce,min,max,steer)
    SetVehicleHandling(vehicle, boost, drivemax , braking ,roll,brakeforce,min,max,steer)
    TriggerEvent("chat:addMessage", {
      color = {255, 255, 0},
      args = {"Vehicle", "Tuning applied to vehicle"}
    })
  else
    TriggerEvent("chat:addMessage", {
      color = {255, 0, 0},
      args = {"Error", "Invalid arguments for tuner command"}
    })
  end
end)

RegisterCommand("gettuner", function(source, args)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    
    if #args == 0 then
      local stats = getVehData(vehicle)
      print("speed", stats.boost," maxspeed ",stats.drivemax," brake bias front ",stats.braking," ",stats.brakeforce," ",stats.steer," ",stats.roll," ",stats.min," ",stats.max)
      TriggerEvent("chat:addMessage", {
        color = {255, 255, 0},
        args = {"Vehicle", stats.boost," ",stats.drivemax," ",stats.braking," ",stats.roll," ",stats.brakeforce," ",stats.min," ",stats.max," ",stats.steer}
      })
    else
      TriggerEvent("chat:addMessage", {
        color = {255, 0, 0},
        args = {"Error", "Invalid arguments for tuner command"}
      })
    end
  end)