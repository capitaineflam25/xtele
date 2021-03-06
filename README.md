# xtele
Extended telemetry screen for the FrsSky Taranis X7/X7S ([OpenTX](https://github.com/opentx/opentx))

*xtele.lua* is the main script

*xtele_xxxx.lua* are examples of models configuration

To create your own configuration file, create a *xtele_xxxx.lua* by copying one of the example and rename it so xxxx is the name of your model in OpenTX (Replace spaces by "_")

Configuration file values :

* **BatterySensor** is the name of the telemetry sensor to use as battery

* **BatteryCells** LiPo cells count (ex. 2 for 2S) Used for the battery gauge limit and the percentage calculation (Based on the percentage discharge array)

* **bat_warn_voltage** is the first battery limit. It is shown as a vertical dotted line on the battery gauge and an audio message will raise when the battery voltage will be lower to that value.

* **bat_crit_voltage** is the second battery limit. It is shown as a vertical dotted line on the battery gauge and an audio and haptic message will raise when the battery voltage will be lower to that value.


* **switch** is an array of switches states to be displayed at the bottom of the screen (see examples files)

![Example](https://github.com/capitaineflam25/xtele/blob/master/img/xtele_example_01.png)
