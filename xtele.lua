-- Specific telemetry screen by capitaineflam25
-- 22/11/2017

-- Looking for configuration file (_ replace spaces in model name)
local name = model.getInfo()["name"]
name = string.gsub(name, " ", "_")
config = assert(loadScript("/SCRIPTS/TELEMETRY/xtele_"..name..".lua"), "xtele_"..name..".lua is missing")
config()

-- LiPo non linear discharge curve
-- 1S Voltage     0%   10%   20%   30%   40%   50%   60%   70%   80%   90%  100%
battery_pct = { 3.00, 3.60, 3.70, 3.75, 3.79, 3.83, 3.87, 3.92, 3.97, 4.10, 4.20 }

-- Adjusting voltage curve to battery cell count
for p = 1, 11, 1 do
  battery_pct[p] = battery_pct[p] * BatteryCells
end

--[[
-- Using GVars instead of config file
bat_warn_voltage = getValue('gvar1')/10
bat_crit_voltage = getValue('gvar2')/10
--]]

local last_bat_warn_time = 0

-----------------------------------------------------------------------------
-- TODO :
--
-- * check how to find /10 GVar divider configuration
-- * Show a gauge or indicator for timer
--
-----------------------------------------------------------------------------

local x = 0
local y = 0

local function round(num, decimals)
  if (num == nill) then
    return 0
  end

  local mult = 10^(decimals or 0)
  return math.floor(num * mult + 0.5) / mult
end

local function batPct(v)

  -- LiPo discharge is not linear, doing a linear interpolation between 10% step values in "battery_pct" array

  -- a = (v2 - v1) / (%2 - %1)
  -- a = (v2 - v) / (%2 - %)
  -- (v2 - v1) / (%2 - %1) = (v2 - v) / (%2 - %)
  -- (%2 - %) = (v2 - v) * (%2 - %1) /  (v2 - v1)
  -- % = %2 - (v2 - v) * (%2 - %1) /  (v2 - v1)
    
  local pct
  if (v <= battery_pct[1])
  then
    pct = 0
  else
    for i=1, 10, 1 do
      if (v >= battery_pct[i])
      then
          local pct2 = i*10
          local pct1 = (i-1)*10
          local v2 = battery_pct[i+1]
          local v1 = battery_pct[i]
          pct = round(pct2 - (v2 - v) * (pct2 - pct1) / (v2 - v1), 0)
          if (pct > 100) then pct = 100 end
      end
    end
  end
  return pct
end

local function init_func()
  -- doesn't work
  --if max_bat < min_bat then
  --  popupConfirmation("Check min and max bat values", 1)
  --end

  warn_bat_pct = batPct(bat_warn_voltage)
  crit_bat_pct = batPct(bat_crit_voltage)
end

local function bg_func()

    -- blinking battery level and audio if necessary
  local cur =  getValue(BatterySensor)
  local flag = 0

  if (cur < bat_crit_voltage) then

    if (cur > 0 and getTime() - last_bat_warn_time > 8 --[[sec--]] * 100) then
      playFile("batcrit.wav")
      playHaptic(500, 100, PLAY_NOW)
      last_bat_warn_time = getTime()
    end
    flag = BLINK

  elseif (cur < bat_warn_voltage) then

    if (cur > 0 and getTime() - last_bat_warn_time > 10 --[[sec--]] * 100) then
      playFile("batlow.wav")
      -- no more haptic on low, only critical now
      -- playHaptic(500, 200, PLAY_NOW)
      last_bat_warn_time = getTime()
    end
    flag = BLINK
    
  end 
  
  -- rounding value to display (native value could have many digits)
  local txt = round(cur, 1).."V"
  
  local pct = batPct(cur)

  lcd.drawText(2, y+4, pct.."%", flag)
  -- centering a bit
  --while (string.len(txt) <= 4) 
  --do
  --  txt = " "..txt
  --end

  lcd.drawText(2, y-5, txt, flag)
end

-- RSSI Bars
local function drawRSSI()
  
  local rssi, alarm_low, alarm_crit =  getRSSI()
  local step = (100 - alarm_crit) / 4
  --print("crit : "..alarm_crit)
  local w = 3
  local h = 2
  
  -- 42|57|72|88 for a RSSI low of 42
  -- 4 bars to draw maximum
  for i = 0, 3, 1 do
    if (rssi >= alarm_crit) then
      lcd.drawFilledRectangle(x+26+ i*(w+1), y+15-(i+1)*h, w, (i+1)*h)
    end
    alarm_crit = alarm_crit + step
  end
  
end

local function drawBatt(offset)

  -- battery container
  lcd.drawRectangle(x+offset, y-2, 101, 11, SOLID)
  
  -- rounded edges
  lcd.drawPoint(x+offset, y-2, INVERT)
  lcd.drawPoint(x+offset, y+8, INVERT)
  lcd.drawPoint(x+offset+100, y-2, INVERT)
  lcd.drawPoint(x+offset+100, y+8, INVERT)
  
  local start = x + offset
  local gauge_length = 100
  
  -- warning line
  local convert = start + gauge_length * warn_bat_pct / 100
  convert = math.floor(convert)

  -- we want it match a vertical line
  if (convert % 2 ~= 0) then
    convert = convert - 1
  end
  -- specific dotted line
  for z=0, 8, 2 do
    lcd.drawPoint(convert, y - 1 + z)
  end
  
  -- critical line
  local convert = start + gauge_length * crit_bat_pct / 100
  convert = math.floor(convert)
  -- we want it match a vertical line
  if (convert % 2 ~= 0) then
    convert = convert - 1
  end
  -- specific dotted line
  for z = 0, 8, 2 do
    lcd.drawPoint(convert, y - 1 + z)
  end
  
  -- battery level
  local cur_bat_pct =  batPct(getValue(BatterySensor))
  local convert = start + gauge_length * cur_bat_pct / 100
  
  -- security, screen width overflow
  if (convert > 128) then
    convert = 128
  end

  for z = start, convert, 2 do
     lcd.drawLine(z, y, z, y + 6, SOLID, FORCE)
  end
end

local function drawTxBat()
  local settings = getGeneralSettings()
  local voltage = getValue('tx-voltage')
  
  local percent =  1 - (settings['battMax'] - voltage) / ( settings['battMax'] - settings['battMin'])
  
  -- battery voltage and black rectangle
  lcd.drawFilledRectangle(x, y, 24, 9)
  --print(settings['battWarn'])
  if (voltage <= settings['battWarn'])
  then
    lcd.drawText(x+1, y+1, round(voltage, 1).."V", INVERS+BLINK)
  else
    lcd.drawText(x+1, y+1, round(voltage, 1).."V", INVERS)
  end

  -- battery gauge
  lcd.drawRectangle(x, y, 24, 15, SOLID)
  lcd.drawPoint(x+22, y+13)
  lcd.drawPoint(x+22, y+9)
  
  -- 20 = 100% battery
  local current = percent * 20
  
  -- vertical lines
  for x=3, 3+current, 2 do
     lcd.drawLine(x, y+10, x, y+12, SOLID, FORCE)
  end
  
end

local function drawSwitches()
  for j, sw in ipairs(switch)
  do
    local v = getValue(sw["name"])
    local sValue = sw[v][1]
    local sFlag = sw[v][2]
    
    x = x + sw["margin"]
    local w = 25
    if sw["width"] ~= nill then
      w = sw["width"]
    end
    
    -- rectangle
    if (sFlag == INVERS) then
      lcd.drawFilledRectangle(x, y, w, 11)
    else
      lcd.drawRectangle(x, y, w, 11)
    end
    
    -- Text
    lcd.drawText(x + 2, y + 2, sValue, sFlag)
    x = x + w + 1
  end
  
end

local function drawChrono()
  -- https://opentx.gitbooks.io/opentx-2-2-lua-reference-guide/content/model/getTimer.html
  local mode = model.getTimer(0)["mode"]
  --English
  --local mode_desc = { "OFF", "ON", "THs", "TH%", "SW" , "mSW"}
  --French
  local mode_desc = { "OFF", "ON", "GZs", "GZ%", "SW" , "mSW"}

  -- Chrono Mode
  lcd.drawText(x + 66, y+8, mode_desc[mode+1])
  
  -- Chrono value
  local upTime = model.getTimer(0)["value"]
  lcd.drawTimer(x + 66 + 20, y, upTime, DBLSIZE)
end

local function run_func(event)
  -- Called periodically when screen is visible
  lcd.clear()

  x = 1
  y = 0
  lcd.drawText(x, y, model.getInfo()["name"], DBLSIZE)
  
  y = y + 18
  drawChrono()
  drawTxBat()
  drawRSSI()
  
  y = y + 22
  bg_func() -- audio in case of low battery
  drawBatt(25)
  
  y = y + 13
  drawSwitches()
end

return { run=run_func, background=bg_func, init=init_func  }
