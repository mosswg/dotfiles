local awful = require("awful")
local ruled = require("ruled")
local naughty = require("naughty")
local gears = require("gears")

ruled.notification.connect_signal('request::rules', function()
--  Notifications timeout
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
end)
naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)
naughty.config.defaults['icon_size'] = 80

function notify_battery(test_percent, current_percent)
	awful.spawn.easy_async_with_shell('bash -c "cat ~/notif/batt-"'..test_percent,
	function(stdout2)
		if tonumber(stdout2) == 0 then
			batterynotification = naughty.notify{
				title = "Battery Warning\n",
				text = "Battery is lower than "..test_percent.."%.\nStatus is " .. current_percent .. "%.",
				timeout = 10,
			}
			os.execute("echo 1 > ~/notif/batt-"..test_percent)
		end
	end
	)
end

-- Notify low battery
os.execute("echo 0 > ~/notif/batt-20")
os.execute("echo 0 > ~/notif/batt-10")
gears.timer {
	timeout   = 5,
	call_now  = true,
	autostart = true,
	callback  = function()
		awful.spawn.easy_async_with_shell([[bash -c "cat /sys/class/power_supply/BAT1/capacity"]],
		function(stdout)
			if tonumber(stdout) <= 10 then
				notify_battery(10, tonumber(stdout))
			elseif tonumber(stdout) <= 20 then
				os.execute("echo 0 > ~/notif/batt-10")
				notify_battery(20, tonumber(stdout))
			else
				os.execute("echo 0 > ~/notif/batt-20")
			end
		end
		)
	end
}
