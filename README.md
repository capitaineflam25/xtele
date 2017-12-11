# xtele
Extended telemetry screen for the FrsSky Taranis X7/X7S ([OpenTX](https://github.com/opentx/opentx))

*xtele.lua* is the main script

*xtele_xxxx.lua* are examples of model configuration

**BatterySensor** is the name of the telemetry sensor to use as battery

**max_bat** is the maximum battery voltage in volt (Upper battery gauge limit)

**min_bat** is the minimum battery voltage in volt (Lower battery gauge limit)


**warn_bat** is the first battery limit. It is shown as a vertical dotted line on the battery gauge and an audio message will raise when the battery voltage will be lower to that value.

**crit_bat** is the second battery limit. It is shown as a vertical dotted line on the battery gauge and an audio message will raise when the battery voltage will be lower to that value.


**switch** is an array of switches states to be displayed at the bottom of the screen (see examples files)

![Example](https://github.com/capitaineflam25/xtele/blob/master/img/xtele_example_01.png)
