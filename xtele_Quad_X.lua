-- Configuration file for xtele.lua

BatterySensor = "LiPo"

max_bat = 12.6
min_bat = 10.3

warn_bat = 10.8
crit_bat = 10.5

switch = {
  { ["name"] = "sf", ["margin"] = 0, ["width"] = 20,  [1024] = { "Bip!", INVERS },                            [-1024] = { "Bip",  0 } },
  { ["name"] = "sa", ["margin"] = 0,                  [1024] = { "Fsf.", 0      },  [0] = { "Fsf!", INVERS }, [-1024] = { "Fsf.", 0 } },
  { ["name"] = "sc", ["margin"] = 3,                  [1024] = { "Hom.", INVERS },  [0] = { "Crs.", INVERS }, [-1024] = { "NLck", 0 } },
  { ["name"] = "sd", ["margin"] = 0,                  [1024] = { "Man.", INVERS },  [0] = { "Atti", INVERS }, [-1024] = { "GPS",  0 } },
  { ["name"] = "sh", ["margin"] = 0, ["width"] = 24,  [1024] = { "Eco.", INVERS },                            [-1024] = { "Eco.", 0 } }
}
