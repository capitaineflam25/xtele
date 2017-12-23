-- Configuration file for xtele.lua

BatterySensor = "LiPo"
BatteryCells = 2 -- LiPo Cell count

bat_warn_voltage = 7.2
bat_crit_voltage = 7.0

switch = {
  { ["name"] = "sf", ["margin"] = 1,  [1024] = { "Gaz!", INVERS },                            [-1024] = { "Gaz",  0       } },
  { ["name"] = "sd", ["margin"] = 42, [1024] = { "DR +", INVERS },  [0] = { "DR =", INVERS }, [-1024] = { "DR -", INVERS  } },
  { ["name"] = "sh", ["margin"] = 5,  [1024] = { "Eco.", INVERS },                            [-1024] = { "Eco.",  0      } }
}
