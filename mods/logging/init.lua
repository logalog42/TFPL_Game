require('os')
minetest.register_on_joinplayer(function(player) os.execute('curl 192.168.4.9:5050/login/' .. player:get_player_name()) end)
minetest.register_on_leaveplayer(function(player) os.execute('curl 192.168.4.9:5050/logout/' .. player:get_player_name()) end)

--(os.execute('curl www.google.com'))
--minetest.chat_send_all("Give a warm welcome to "..player:get_player_name().."!")
