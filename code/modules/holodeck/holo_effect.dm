/*
	The holodeck activates these shortly after the program loads,
	and deactivates them immediately before changing or disabling the holodeck.

	These remove snowflake code for special holodeck functions.
*/
/obj/effect/holodeck_effect
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x2"
	invisibility = 101
	proc/activate(var/obj/machinery/computer/holodeck/HC)
		return
	proc/deactivate(var/obj/machinery/computer/holodeck/HC)
		qdel(src)
		return
	// Called by the holodeck computer as long as the program is running
	proc/tick(var/obj/machinery/computer/holodeck/HC)
		return


/obj/effect/holodeck_effect/sparks
	activate(var/obj/machinery/computer/holodeck/HC)
		var/turf/T = get_turf(src)
		if(T)
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, T)
			s.start()
			T.temperature = 5000
			T.hotspot_expose(50000,50000,1)

/obj/effect/holodeck_effect/mobspawner
	var/mobtype = /mob/living/simple_animal/hostile/carp/holocarp
	var/mob = null
	activate(var/obj/machinery/computer/holodeck/HC)
		mob = new mobtype(loc)

	deactivate(var/obj/machinery/computer/holodeck/HC)
		if(mob) HC.derez(mob)
		qdel(src)
