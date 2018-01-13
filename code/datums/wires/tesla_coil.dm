
/datum/wires/tesla_coil
	random = 1	//Only one wire don't need blueprints
	holder_type = /obj/machinery/power/tesla_coil

/datum/wires/tesla_coil/New(atom/holder)
	//wires = list("High Voltage Circuit")
	..()

/*
/datum/wires/tesla_coil/on_pulse(wire)
	var/obj/machinery/power/tesla_coil/C = holder
	C.zap()
	..()
*/