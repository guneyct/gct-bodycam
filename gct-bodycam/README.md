## GCT Bodycam

This script allows police characters to have bodycam!

https://discord.gg/PHBX53jcSn

## DEPENDENCIES

- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-target](https://github.com/qbcore-framework/qb-target)

# QB-CORE IMPLENTATION

Add this code in your **qb-core/server/player.lua** inside *function self.Functions.RemoveItem(item, amount, slot)* like this;

```lua

    function self.Functions.RemoveItem(item, amount, slot)
        amount = tonumber(amount)
        slot = tonumber(slot)

        if item == "bodycam" then
            TriggerClientEvent('gct-bodycam:close', self.PlayerData.source)
        end

```

And add your item in your **qb-core/shared/items.lua** like this;

```lua

	['bodycam'] 			 		 = {['name'] = 'bodycam', 			  		['label'] = 'Bodycam', 					['weight'] = 100, 		['type'] = 'item', 		['image'] = 'bodycam.png', 		['unique'] = false, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Bodycam for police or sheriff.'},


```

If you want to disable inventory, phone and radial menu then just add this code to your *open function*;

```lua

if not isCrafting and not inInventory and not exports["gct-bodycam"]:isCamOpen() then -- this is for qb-inventory

```

Like this and you are good to go! And don't forget to edit **config.lua**.

# ADD MORE JOBS

If you want to add more jobs to use this bodycam than edit **config.lua**.

And you are free to use your *Bodycam*.