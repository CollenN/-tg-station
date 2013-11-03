/datum/round_event_control/undead
	name = "Undead rising"
	typepath = /datum/round_event/undead
	max_occurrences = 3

/datum/round_event/undead
	var/spawn_prob = 15
	startWhen = 2
	announceWhen = 3
	setup()
		var/datum/round_event/electrical_storm/RS = new
		RS.lightsoutAmount = pick(2,2,3)
		RS.start()
		RS.kill()
	start()
		for(var/area/A)
			if(A.luminosity) continue
			if(A.lighting_space) continue
			if(A.type == /area) continue
			var/list/turflist = list()
			for(var/turf/T in A)
				if(istype(T,/turf/space) || T.density) continue
				if(locate(/mob/living) in T) continue
				var/okay = 1
				for(var/obj/O in T)
					if(O.density)
						okay = 0
						break
				if(okay)
					turflist += T

			if(!turflist.len) continue
			var/turfs = round(turflist.len * spawn_prob/100,1)
			while(turfs > 0 && turflist.len) // safety
				turfs--
				var/turf/T = pick_n_take(turflist)
				var/undeadtype = pick(/mob/living/simple_animal/hostile/retaliate/skeleton,
									80;/mob/living/simple_animal/hostile/retaliate/zombie,
									60;/mob/living/simple_animal/hostile/retaliate/ghost)
				new undeadtype(T)
	announce()
		for(var/mob/living/M in player_list)
			M << "You feel [pick("a chill","a deathly chill","the undead","dirty", "creeped out","afraid","fear")]!"
