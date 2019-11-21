local overrides = {
	"bucket:bucket_water",
	"bucket:bucket_river_water",
	"bucket_wooden:bucket_water",
	"bucket_wooden:bucket_river_water",
	"bucket:bucket_lava",
	"default:lava_source",
	"default:water_source",
	"technic:lava_can",
	"technic:water_can",
}

minetest.register_privilege("liquids", {
	description = "Can place liquids above y 0",
	give_to_singleplayer = false,
	give_to_admin = false,
})

for _, name in pairs(overrides) do
	local def = minetest.registered_items[name]
	

	if def then -- Item exists
		local newdef = {}
		local old_on_place = def.on_place or function() end

		newdef.on_place = function(itemstack, p, pt)
			if pt.above.y > 0 and not minetest.check_player_privs(p, "liquids") then
				minetest.chat_send_player(p:get_player_name(), "You do not have the privs required to place liquids above y 0!")
				minetest.log("returning...")
				return itemstack
			end

			return old_on_place(itemstack, p, pt)
		end

		minetest.override_item(name, newdef)
		minetest.log("warning", "Overriding "..dump(name))
	end
end
