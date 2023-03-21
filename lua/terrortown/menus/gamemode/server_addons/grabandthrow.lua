CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "submenu_addons_grab_and_throw_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_addons_grab_and_throw")

	form:MakeHelp({
		label = "help_grab_and_throw_menu"
	})

	form:MakeSlider({
		label = "label_grab_and_throw_strength",
		serverConvar = "ttt_grab_and_throw_strength",
		min = 1,
		max = 3000,
		decimal = 0
	})

	form:MakeSlider({
		label = "label_grab_and_throw_range",
		serverConvar = "ttt_grab_and_throw_range",
		min = 100,
		max = 1500,
		decimal = 0
	})
end
