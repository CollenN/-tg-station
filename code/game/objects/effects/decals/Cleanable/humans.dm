/obj/effect/decal/cleanable/blood
	name = "blood"
	desc = "It's red and gooey. Perhaps it's the chef's cooking?"
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	var/list/viruses = list()
	var/old = 0
	var/weight = 0
	blood_DNA = list()

/obj/effect/decal/cleanable/blood/Destroy()
	for(var/datum/disease/D in viruses)
		D.cure(0)
	var/turf/simulated/cur_turf = get_turf(src.loc)
	if(istype(cur_turf, /turf/simulated))
		cur_turf.bloody = 0
	..()

/obj/effect/decal/cleanable/blood/New()
	..()
	var/turf/simulated/cur_turf = get_turf(src.loc)
	if(istype(cur_turf, /turf/simulated) && !old)
		cur_turf.bloody = rand(10,20)
		cur_turf.oily = 0
		cur_turf.xenobloody = 0
	if(istype(src, /obj/effect/decal/cleanable/blood/gibs))
		return
	remove_ex_blood()
	spawn(12000) // 20 minutes
		icon_state += "-old"
		name = "dried blood"
		desc = "Looks like it's been here a while.  Eew."
		blood_DNA = list()
		if(istype(cur_turf, /turf/simulated))
			cur_turf.bloody = 0

/obj/effect/decal/cleanable/blood/proc/remove_ex_blood() //removes existant blood on the turf
	if(src.loc && isturf(src.loc))
		// lame copypasta time
		for(var/obj/effect/decal/cleanable/blood/B in src.loc)
			if(B != src)
				qdel(B)
		for(var/obj/effect/decal/cleanable/xenoblood/B in src.loc)
			if(B != src)
				del(B)
		for(var/obj/effect/decal/cleanable/oil/B in src.loc)
			if(B != src)
				del(B)


/obj/effect/decal/cleanable/blood/splatter
	random_icon_states = list("gibbl1", "gibbl2", "gibbl3", "gibbl4", "gibbl5")

/obj/effect/decal/cleanable/blood/tracks
	icon_state = "tracks"
	desc = "They look like tracks left by wheels."
	gender = PLURAL
	random_icon_states = null

/obj/effect/decal/cleanable/trail_holder //not a child of blood on purpose
	name = "blood"
	icon_state = "blank"
	desc = "Your instincts say you shouldn't be following these."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	random_icon_states = null
	var/list/existing_dirs = list()
	blood_DNA = list()

/obj/effect/decal/cleanable/blood/gibs
	name = "gibs"
	desc = "They look bloody and gruesome."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/blood.dmi'
	icon_state = "gibbl5"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")

/obj/effect/decal/cleanable/blood/gibs/ex_act(severity, target)
	return

/obj/effect/decal/cleanable/blood/gibs/remove_ex_blood()
    return

/obj/effect/decal/cleanable/blood/gibs/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/gibs/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")


/obj/effect/decal/cleanable/blood/gibs/proc/streak(var/list/directions, var/obj/gross = null)
	spawn (0)
		var/direction = pick(directions)
		for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
			sleep(3)
			if (i > 0)
				var/obj/effect/decal/cleanable/blood/b = new /obj/effect/decal/cleanable/blood/splatter(src.loc)
				for(var/datum/disease/D in src.viruses)
					var/datum/disease/ND = D.Copy(1)
					b.viruses += ND
					ND.holder = b

			if (step_to(src, get_step(src, direction), 0))
				break
		if(gross)
			gross.loc = loc
