//////////////////////////////////////////
// Extra defines needed for tesla support
//////////////////////////////////////////

/obj
	var/being_shocked = FALSE

/obj/proc/tesla_act(var/power)
	being_shocked = TRUE
	var/power_bounced = power / 2
	tesla_zap(src, 3, power_bounced)
	//addtimer(CALLBACK(src, .proc/reset_shocked), 10)
	//schedule_task_with_source_in(10, src, .proc/reset_shocked)
	spawn(10) reset_shocked()

/obj/proc/reset_shocked()
	being_shocked = FALSE

//////////////////////////
// Circuits and Research
//////////////////////////

/obj/item/weapon/circuitboard/tesla_coil
	name = "Tesla Coil (Machine Board)"
	build_path = /obj/machinery/power/tesla_coil
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_MAGNET = 2, TECH_POWER = 4)
	req_components = list(/obj/item/weapon/stock_parts/capacitor = 1)


/datum/design/circuit/tesla_coil
	name = "Machine Design (Tesla Coil Board)"
	desc = "The circuit board for a tesla coil."
	id = "tesla_coil"
	build_path = /obj/item/weapon/circuitboard/tesla_coil
	req_tech = list(TECH_MAGNET = 2, TECH_POWER = 4)
	sort_string = "MAAAC"

/////////////////////////////////////////////////////////////////////////////////////
// Utilities that we probably should make general but will keep here during testing.
/////////////////////////////////////////////////////////////////////////////////////

/proc/typecache_filter_multi_list_exclusion(list/atoms, list/typecache_include, list/typecache_exclude)
	. = list()
	for(var/thing in atoms)
		var/atom/A = thing
		if(typecache_include[A.type] && !typecache_exclude[A.type])
			. += A

//Like typesof() or subtypesof(), but returns a typecache instead of a list
/proc/typecacheof(path, ignore_root_path, only_root_path = FALSE)
	if(ispath(path))
		var/list/types = list()
		if(only_root_path)
			types = list(path)
		else
			types = ignore_root_path ? subtypesof(path) : typesof(path)
		var/list/L = list()
		for(var/T in types)
			L[T] = TRUE
		return L
	else if(islist(path))
		var/list/pathlist = path
		var/list/L = list()
		if(ignore_root_path)
			for(var/P in pathlist)
				for(var/T in subtypesof(P))
					L[T] = TRUE
		else
			for(var/P in pathlist)
				if(only_root_path)
					L[P] = TRUE
				else
					for(var/T in typesof(P))
						L[T] = TRUE
		return L



/obj/machinery/power/proc/default_unfasten_wrench(var/mob/user, var/obj/item/weapon/wrench/W)
	if(!istype(W))
		return FALSE
	if(panel_open)
		return FALSE // Close panel first!
	user.visible_message("<span class='warning'>[user] has [anchored ? "un" : ""]secured \the [src].</span>", "<span class='notice'>You [anchored ? "un" : ""]secure \the [src].</span>")
	anchored = !anchored
	playsound(src, W.usesound, 50, 1)
	if(anchored)
		connect_to_network()
	else
		disconnect_from_network()
	update_icon()
	return TRUE
