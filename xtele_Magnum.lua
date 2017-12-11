-- Configuration file for xtele.lua

BatterySensor = "LiPo"

max_bat = 8.4
min_bat = 7.0

warn_bat = 7.3
crit_bat = 7.1

switch = {
  { ["name"] = "sf", ["margin"] = 1,  [1024] = { "Gaz!", INVERS },                            [-1024] = { "Gaz",  0       } },
  { ["name"] = "sd", ["margin"] = 42, [1024] = { "DR +", INVERS },  [0] = { "DR =", INVERS }, [-1024] = { "DR -", INVERS  } },
  { ["name"] = "sh", ["margin"] = 5,  [1024] = { "Eco.", INVERS },                            [-1024] = { "Eco.",  0      } }
}
