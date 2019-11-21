local overrides = {
	"bucket:bucket_water",
	"bucket:bucket_river_water",
	"bucket_wooden:bucket_water",
	"bucket_wooden:bucket_river_water",
	"bucket:bucket_lava",
	"default:water_source",
}

minetest.register_privilege("liquids", {
	description = "Can place liquids above y 0",
	give_to_singleplayer = false,
	give_to_admin = true,
})

for _, name in ipairs(overrides) do
	local def = minetest.registered_items[name]

	if not def then return end -- Item doesn't exist

	local old_on_place = def.on_place
	local newdef = {}

	if not def.on_place then
		newdef.on_place = function(itemstack, p, pt)
			if pt.above.y > 0 and not minetest.check_player_privs(p, "liquids") then
				minetest.chat_send_player(p:get_player_name(), "You do not have the privs required to place liquids above y 0!")
				return itemstack
			end
		end
	else
		newdef.on_place = function(itemstack, p, pt)
			if pt.above.y > 0 and not minetest.check_player_privs(p, "liquids") then
				minetest.chat_send_player(p:get_player_name(), "You do not have the privs required to place liquids above y 0!")
				return itemstack
			end

			minetest.log("returning...")
			return old_on_place(itemstack, p, pt)
		end
	end

	minetest.override_item(name, newdef)
	minetest.log("warning", "Overriding "..dump(name))
end
