/obj/machinery/computer/HolodeckControl
	name = "holodeck control console"
	desc = "A computer used to control a nearby holodeck."
	icon_state = "holocontrol"
	var/area/linkedholodeck = null
	var/area/target = null
	var/area/previous_target = null
	var/active = 0
	var/list/holographic_items = list()
	var/damaged = 0
	var/last_change = 0
	var/target_area = /area/holodeck/alphadeck
	var/offline_area = /area/holodeck/source_plating
	var/pettype = "dogs"

	attack_ai(var/mob/user as mob)
		return src.attack_hand(user)

/obj/machinery/computer/HolodeckControl/attack_hand(var/mob/user as mob)

	if(..())
		return

	user.set_machine(src)

	var/dat = "<h3>Current Loaded Programs</h3>"
	dat += "<A href='?src=\ref[src];turnoff=1'>((Turn Off))</A><BR>"
	dat += "<A href='?src=\ref[src];lounge=1'>((Classic Lounge))</A><BR>"
	dat += "<A href='?src=\ref[src];emptycourt=1'>((Empty Court))</A><BR>"
	dat += "<A href='?src=\ref[src];boxingcourt=1'>((Dodgeball Arena)</font>)</A><BR>"
	dat += "<A href='?src=\ref[src];basketball=1'>((Basketball Court))</A><BR>"
	dat += "<A href='?src=\ref[src];thunderdomecourt=1'>((Thunderdome Court))</A><BR>"
	dat += "<A href='?src=\ref[src];beach=1'>((Beach))</A><BR>"
	dat += "<A href='?src=\ref[src];party=1'>((Party Room))</A><BR>"
	dat += "<A href='?src=\ref[src];transit=1'>((Transit system demo))</A><BR>"
	dat += "<A href='?src=\ref[src];pets=1'>((Pet Room))</A><BR>"
	dat += " - Pet preference: <a href='?src=\ref[src];pettype=1'>[pettype]</a><br>"
	if(emagged | issilicon(user))
		dat += "<A href='?src=\ref[src];medical=1'>((Emergency Medical Center))</A><BR>"
		dat += "Caution: Holographic medical facilities for emergency use only. <BR>"

	dat += "<span class='notice'>Please ensure that only holographic weapons are used in the holodeck if a combat simulation has been loaded.</span><BR>"

	if(emagged)
		dat += "<A href='?src=\ref[src];securebunker=1'>(<font color=red>Load secure bunker</font>)</A><BR>"
		dat += "Caution: Ensure that bunker is not used in an unauthorized manner.<BR>"

		dat += "<A href='?src=\ref[src];burntest=1'>(<font color=red>Begin Atmospheric Burn Simulation</font>)</A><BR>"
		dat += "Ensure the holodeck is empty before testing.<BR>"
		dat += "<BR>"
		dat += "<A href='?src=\ref[src];wildlifecarp=1'>(<font color=red>Begin Wildlife Simulation</font>)</A><BR>"
		dat += "Ensure the holodeck is empty before testing.<BR>"
		dat += "<BR>"
		dat += "<BR>"
		if(issilicon(user))
			dat += "<A href='?src=\ref[src];AIoverride=1'>(<font color=green>Re-Enable Safety Protocols?</font>)</A><BR>"
		dat += "Safety Protocols are <font class='bad'>DISABLED</font><BR>"
	else
		if(issilicon(user))
			dat += "<BR>"
			dat += "<BR>"
			dat += "<A href='?src=\ref[src];AIoverride=1'>(<font color=red>Override Safety Protocols?</font>)</A><BR>"
		dat += "<BR>"
		dat += "Safety Protocols are <font class='good'>ENABLED</font><BR>"

	var/datum/browser/popup = new(user, "computer", name, 400, 500)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	return

/obj/machinery/computer/HolodeckControl/Topic(href, href_list)
	if(..())
		return
	if(Adjacent(usr) || istype(usr, /mob/living/silicon))
		usr.set_machine(src)

		if(href_list["loadarea"])
			var/typepath = text2path(href_list["loadarea"])
			if(ispath(typepath,/area))
				target = locate(typepath)
				if(target)
					loadProgram(target)
				else
					world.log << "area not ready: [typepath]"
			else
				world.log << "bad area argument: [href_list["loadarea"]]"

		else if(href_list["emptycourt"])
			target = locate(/area/holodeck/source_emptycourt)
			if(target)
				loadProgram(target)
		else if(href_list["lounge"])
			target = locate(/area/holodeck/source_lounge)
			if(target)
				loadProgram(target)
		else if(href_list["pets"])
			target = locate(/area/holodeck/source_puppy)
			if(target)
				loadProgram(target)
		else if(href_list["pettype"])
			var/list/next_pettype = list(
				"dogs" = "cats",
				"cats" = "chicks",
				"chicks" = "dogs")
			if(emagged)
				next_pettype = list(
					"dogs" = "cats",
					"cats" = "chicks",
					"chicks" = "goats",
					"goats" = "ghosts",
					"ghosts" = "clowns",
					"clowns" = "dogs")
			if(pettype in next_pettype)
				pettype = next_pettype[pettype]
			else
				pettype = "dogs"
			for(var/mob/M in holographic_items)
				derez(M)
			for(var/obj/effect/landmark/L in linkedholodeck)
				if(L.name == "Holopet Spawn")
					petspawn(L.loc)
			for(var/mob/M in holographic_items)
				step_rand(M)
				step_rand(M)
			for(var/obj/effect/decal/cleanable/EDC in linkedholodeck)
				if(EDC in holographic_items) continue
				del EDC

		else if(href_list["boxingcourt"])
			target = locate(/area/holodeck/source_boxingcourt)
			if(target)
				loadProgram(target)

		else if(href_list["basketball"])
			target = locate(/area/holodeck/source_basketball)
			if(target)
				loadProgram(target)

		else if(href_list["thunderdomecourt"])
			target = locate(/area/holodeck/source_thunderdomecourt)
			if(target)
				loadProgram(target)

		else if(href_list["beach"])
			target = locate(/area/holodeck/source_beach)
			if(target)
				loadProgram(target)

		else if(href_list["transit"])
			target = locate(/area/holodeck/source_transit)
			if(target)
				loadProgram(target)

		else if(href_list["party"])
			target = locate(/area/holodeck/source_party)
			if(target)
				loadProgram(target)

		else if(href_list["turnoff"])
			target = locate(offline_area)
			if(target)
				loadProgram(target)

		else if(href_list["burntest"])
			if(!emagged)	return
			target = locate(/area/holodeck/source_burntest)
			if(target)
				loadProgram(target)

		else if(href_list["wildlifecarp"])
			if(!emagged)	return
			target = locate(/area/holodeck/source_wildlife)
			if(target)
				loadProgram(target)

		else if(href_list["securebunker"])
			//if(!emagged)	return
			target = locate(/area/holodeck/source_bunker)
			if(target)
				loadProgram(target)
		else if(href_list["medical"])
			target = locate(/area/holodeck/source_medical)
			if(target)
				loadProgram(target)
		else if(href_list["AIoverride"])
			if(!issilicon(usr))	return
			emagged = !emagged
			if(emagged)
				message_admins("[key_name_admin(usr)] overrode the holodeck's safeties")
				log_game("[key_name(usr)] overrided the holodeck's safeties")
			else
				message_admins("[key_name_admin(usr)] restored the holodeck's safeties")
				log_game("[key_name(usr)] restored the holodeck's safeties")


		src.add_fingerprint(usr)
	src.updateUsrDialog()


	return

/obj/machinery/computer/HolodeckControl/attackby(var/obj/item/weapon/D as obj, var/mob/user as mob)

	if(istype(D, /obj/item/weapon/card/emag) && !emagged)
		playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		user << "<span class='warning'>You vastly increase projector power and override the safety and security protocols.</span>"
		user << "Warning.  Automatic shutoff and derezing protocols have been corrupted.  Please call Nanotrasen maintenance and do not use the simulator."
		log_game("[key_name(usr)] emagged the Holodeck Control Console")
		src.updateUsrDialog()
	else
		..()
	return

/obj/machinery/computer/HolodeckControl/New()
	..()
	linkedholodeck = locate(target_area)
	linkedholodeck = linkedholodeck.master
	//if(linkedholodeck)
	//	target = locate(/area/holodeck/source_emptycourt)
	//	if(target)
	//		loadProgram(target)

//This could all be done better, but it works for now.
/obj/machinery/computer/HolodeckControl/Destroy()
	emergencyShutdown()
	..()


/obj/machinery/computer/HolodeckControl/emp_act(severity)
	emergencyShutdown()
	..()


/obj/machinery/computer/HolodeckControl/ex_act(severity)
	emergencyShutdown()
	..()


/obj/machinery/computer/HolodeckControl/blob_act()
	emergencyShutdown()
	..()


/obj/machinery/computer/HolodeckControl/process()

	if(!..())
		return
	if(active)

		if(!checkInteg(linkedholodeck))
			damaged = 1
			target = locate(/area/holodeck/source_plating)
			if(target)
				loadProgram(target)
			active = 0
			for(var/mob/M in range(10,src))
				M.show_message("The holodeck overloads!")


			for(var/turf/T in linkedholodeck)
				if(prob(30))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(2, 1, T)
					s.start()
				T.ex_act(3)
				T.hotspot_expose(1000,500,1)


		for(var/item in holographic_items)
			if(!(get_area(item) in linkedholodeck.related))
				if(ismob(item) && emagged)
					holographic_items -= item
					continue
				derez(item, 0)



/obj/machinery/computer/HolodeckControl/proc/derez(var/obj/obj , var/silent = 1)
	holographic_items.Remove(obj)

	if(obj == null)
		return

	if(istype(obj))
		var/mob/M = obj.loc
		if(ismob(M))
			M.unEquip(obj, 1) //Holoweapons should always drop.

	for(var/mob/M in obj.contents)
		M.loc = obj.loc
		silent = 0

	if(!silent)
		var/obj/oldobj = obj
		visible_message("The [oldobj.name] fades away!")
	qdel(obj)

/obj/machinery/computer/HolodeckControl/proc/checkInteg(var/area/A)
	for(var/turf/T in A)
		if(istype(T, /turf/space))
			return 0

	return 1

/obj/machinery/computer/HolodeckControl/proc/togglePower(var/toggleOn = 0)
	if(active == toggleOn) return

	if(toggleOn)
		if(previous_target)
			target = previous_target
			loadProgram(target, delay = 1)
			previous_target = null
		active = 1
	else

		var/area/targetsource = locate(offline_area)
		if(target && target != targetsource)
			previous_target = target
		target = targetsource
		loadProgram(target,force=1)
		active = 0

/obj/machinery/computer/HolodeckControl/power_change()
	..()
	if(stat&NOPOWER)
		togglePower(0)
	else
		togglePower(1)
/obj/machinery/computer/HolodeckControl/proc/petspawn(var/turf/T)
	switch(pettype)
		if("dogs")
			var/dogtype = pick(/mob/living/simple_animal/corgi,/mob/living/simple_animal/corgi/Lisa,/mob/living/simple_animal/corgi/puppy,/mob/living/simple_animal/pug)
			holographic_items += new dogtype(T)
		if("cats")
			var/cattype = pick(/mob/living/simple_animal/cat,/mob/living/simple_animal/cat/Proc,/mob/living/simple_animal/cat/kitten)
			holographic_items += new cattype(T)
		if("chicks")
			holographic_items += new /mob/living/simple_animal/chick{never_grow = 1}(T)
		if("goats")
			holographic_items += new /mob/living/simple_animal/hostile/retaliate/goat(T)
		if("ghosts")
			var/ghosttype = pick(/mob/living/simple_animal/hostile/retaliate/ghost,/mob/living/simple_animal/hostile/retaliate/skeleton,/mob/living/simple_animal/hostile/retaliate/zombie)
			holographic_items += new ghosttype(T)
		if("clowns")
			holographic_items += new /mob/living/simple_animal/hostile/retaliate/clown(T)
/obj/machinery/computer/HolodeckControl/proc/loadProgram(var/area/A, var/force = 0, var/delay = 0)

	if(world.time < (last_change + 25) && !force)
		if(delay)
			sleep(25)
		else
			if(world.time < (last_change + 15))//To prevent super-spam clicking, reduced process size and annoyance -Sieve
				return
			for(var/mob/M in range(3,src))
				usr << "\b ERROR. Recalibrating projection apparatus."
				last_change = world.time
				return

	last_change = world.time
	active = 1

	for(var/item in holographic_items)
		derez(item)

	for(var/obj/effect/decal/cleanable/B in linkedholodeck)
		qdel(B)

	for(var/mob/living/simple_animal/hostile/carp/C in linkedholodeck)
		qdel(C)

	holographic_items = A.copy_contents_to(linkedholodeck , 1)

	if(emagged)
		for(var/obj/item/weapon/holo/esword/H in linkedholodeck)
			H.damtype = BRUTE

	if(A.party)
		linkedholodeck.partyalert()
	else
		linkedholodeck.partyreset()

	spawn(30)
		for(var/obj/effect/landmark/L in linkedholodeck)
			if(L.name=="Atmospheric Test Start")
				spawn(20)
					if(istype(target,/area/holodeck/source_burntest))
						var/turf/T = get_turf(L)
						var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
						s.set_up(2, 1, T)
						s.start()
						if(T)
							T.temperature = 5000
							T.hotspot_expose(50000,50000,1)
			if(L.name=="Holocarp Spawn")
				new /mob/living/simple_animal/hostile/carp/holocarp(L.loc)
			if(L.name == "Holopet Spawn")
				petspawn(L.loc)
		for(var/mob/living/simple_animal/M in holographic_items)
			step_rand(M)
			step_rand(M)
			M.renamable = 0

/obj/machinery/computer/HolodeckControl/proc/emergencyShutdown()
	if(!istype(target,/area/holodeck/source_plating))
		//Get rid of any items
		for(var/item in holographic_items)
			derez(item)
		//Turn it back to the regular non-holographic room
		target = locate(/area/holodeck/source_plating)
		if(target)
			loadProgram(target)

		var/area/targetsource = locate(/area/holodeck/source_plating)
		targetsource.copy_contents_to(linkedholodeck , 1)
	active = 0


/obj/machinery/computer/HolodeckControl/theater
	target_area = /area/holodeck/betadeck
	offline_area = /area/holodeck/theater/base

	attack_hand(var/mob/user as mob)
		user.set_machine(src)

		var/dat = "<h3>Current Loaded Programs</h3>"
		for(var/typekey in typesof(/area/holodeck/theater) - /area/holodeck/theater)
			var/area/A = locate(typekey)
			if(!A) continue
			dat += "<a href='?src=\ref[src];loadarea=[typekey]'>[A.name]</a><br>"

		//user << browse(dat, "window=computer;size=400x500")
		//onclose(user, "computer")
		var/datum/browser/popup = new(user, "computer", name, 400, 500)
		popup.set_content(dat)
		popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
		popup.open()
		return


// Holographic Items!

/turf/simulated/floor/holofloor
	thermal_conductivity = 0

/turf/simulated/floor/holofloor/grass
	gender = PLURAL
	name = "lush grass"
	icon_state = "grass1"
	floor_tile = /obj/item/stack/tile/grass

/turf/simulated/floor/holofloor/grass/New()
	..()
	icon_state = "grass[pick("1","2","3","4")]"
	spawn(1)
		if(src)
			update_icon()
			fancy_update(type)



/turf/simulated/floor/holofloor/asteroid
	name = "Asteroid"
	icon_state = "asteroid0"
	floor_tile = new/obj/item/stack/tile/grass

/turf/simulated/floor/holofloor/asteroid/New()
	floor_tile = null //I guess New() isn't run on objects spawned without the definition of a turf to house them, ah well.
	icon_state = "asteroid[pick(0,1,2,3,4,5,6,7,8,9,10,11,12)]"
	..()

/turf/simulated/floor/holofloor/fakespace
	name = "Space"
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	floor_tile = new/obj/item/stack/tile/grass

/turf/simulated/floor/holofloor/fakespace/New()
	floor_tile = null
	icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"
	..()

/turf/simulated/floor/holofloor/hyperspace
	name = "Hyperspace"
	icon = 'icons/turf/space.dmi'
	icon_state = "speedspace_eq_1"
	floor_tile = new/obj/item/stack/tile/grass

/turf/simulated/floor/holofloor/hyperspace/New()
	floor_tile = null
	src.icon_state = "speedspace_ew_[(x + 5*y + (y%2+1)*7)%15+1]"
	..()


/turf/simulated/floor/holofloor/attackby(obj/item/weapon/W as obj, mob/user as mob)
	return
	// HOLOFLOOR DOES NOT GIVE A FUCK

/obj/structure/table/holotable/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if(G.state < GRAB_AGGRESSIVE)
			user << "<span class='danger'> You need a better grip to do that!</span>"
			return
		G.affecting.loc = src.loc
		G.affecting.Weaken(5)
		visible_message("<span class='danger'> [G.assailant] puts [G.affecting] on the table.</span>")
		qdel(W)
		return

/obj/structure/holowindow
	name = "reinforced window"
	icon = 'icons/obj/structures.dmi'
	icon_state = "rwindow"
	desc = "A window."
	density = 1
	layer = 3.2//Just above doors
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = 1.0
	flags = ON_BORDER


/obj/item/weapon/holo
	damtype = STAMINA

/obj/item/weapon/holo/esword
	name = "holographic energy sword"
	desc = "May the force be with you. Sorta"
	icon_state = "sword0"
	force = 3.0
	throw_speed = 2
	throw_range = 5
	throwforce = 0
	w_class = 2.0
	hitsound = "swing_hit"
	flags = NOSHIELD
	var/active = 0

/obj/item/weapon/holo/esword/green
	New()
		item_color = "green"

/obj/item/weapon/holo/esword/red
	New()
		item_color = "red"

/obj/item/weapon/holo/esword/IsShield()
	if(active)
		return 1
	return 0

/obj/item/weapon/holo/esword/attack(target as mob, mob/user as mob)
	..()

/obj/item/weapon/holo/esword/New()
	item_color = pick("red","blue","green","purple")

/obj/item/weapon/holo/esword/attack_self(mob/living/user as mob)
	active = !active
	if (active)
		force = 30
		icon_state = "sword[item_color]"
		w_class = 4
		hitsound = 'sound/weapons/blade1.ogg'
		playsound(user, 'sound/weapons/saberon.ogg', 20, 1)
		user << "<span class='warning'>[src] is now active.</span>"
	else
		force = 3
		icon_state = "sword0"
		w_class = 2
		hitsound = "swing_hit"
		playsound(user, 'sound/weapons/saberoff.ogg', 20, 1)
		user << "<span class='warning'>[src] can now be concealed.</span>"
	return

//BASKETBALL OBJECTS

/obj/item/weapon/beach_ball/holoball
	icon = 'icons/obj/basketball.dmi'
	icon_state = "basketball"
	name = "basketball"
	item_state = "basketball"
	desc = "Here's your chance, do your dance at the Space Jam."
	w_class = 4 //Stops people from hiding it in their bags/pockets

/obj/item/weapon/beach_ball/holoball/dodgeball
	name = "dodgeball"
	icon_state = "dodgeball"
	item_state = "dodgeball"
	desc = "Used for playing the most violent and degrading of childhood games."

/obj/item/weapon/beach_ball/holoball/dodgeball/throw_impact(atom/hit_atom)
	..()
	if((ishuman(hit_atom)))
		var/mob/living/carbon/M = hit_atom
		playsound(src, 'sound/items/dodgeball.ogg', 50, 1)
		M.apply_damage(10, STAMINA)
		if(prob(5))
			M.Weaken(3)
			visible_message("<span class='danger'>[M] is knocked right off \his feet!</span>", 3)

/obj/structure/holohoop
	name = "basketball hoop"
	desc = "Boom, Shakalaka!."
	icon = 'icons/obj/basketball.dmi'
	icon_state = "hoop"
	anchored = 1
	density = 1
	throwpass = 1

/obj/structure/holohoop/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if(G.state < GRAB_AGGRESSIVE)
			user << "<span class='danger'>You need a better grip to do that!</span>"
			return
		G.affecting.loc = src.loc
		G.affecting.Weaken(5)
		visible_message("<span class='danger'>[G.assailant] dunks [G.affecting] into the [src]!</span>", 3)
		qdel(W)
		return
	else if (istype(W, /obj/item) && get_dist(src,user)<2)
		user.drop_item(src)
		visible_message("<span class='warning'> [user] dunks [W] into the [src]!</span>", 3)
		return

/obj/structure/holohoop/CanPass(atom/movable/mover, turf/target, height=0)
	if (istype(mover,/obj/item) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/item/projectile))
			return
		if(prob(50))
			I.loc = src.loc
			visible_message("<span class='warning'> Swish! \the [I] lands in \the [src].</span>", 3)
		else
			visible_message("<span class='danger'> \the [I] bounces off of \the [src]'s rim!</span>", 3)
		return 0
	else
		return ..(mover, target, height)


/obj/machinery/readybutton
	name = "ready declaration device"
	desc = "This device is used to declare ready. If all devices in an area are ready, the event will begin!"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"
	var/ready = 0
	var/area/currentarea = null
	var/eventstarted = 0

	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON

/obj/machinery/readybutton/attack_ai(mob/user as mob)
	user << "The station AI is not to interact with these devices"
	return

/obj/machinery/readybutton/attack_paw(mob/user as mob)
	user << "You are too primitive to use this device"
	return

/obj/machinery/readybutton/New()
	..()


/obj/machinery/readybutton/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user << "The device is a solid button, there's nothing you can do with it!"

/obj/machinery/readybutton/attack_hand(mob/user as mob)
	if(user.stat || stat & (NOPOWER|BROKEN))
		user << "This device is not powered."
		return

	currentarea = get_area(src.loc)
	if(!currentarea)
		qdel(src)

	if(eventstarted)
		usr << "The event has already begun!"
		return

	ready = !ready

	update_icon()

	var/numbuttons = 0
	var/numready = 0
	for(var/obj/machinery/readybutton/button in currentarea)
		numbuttons++
		if (button.ready)
			numready++

	if(numbuttons == numready)
		begin_event()

/obj/machinery/readybutton/update_icon()
	if(ready)
		icon_state = "auth_on"
	else
		icon_state = "auth_off"

/obj/machinery/readybutton/proc/begin_event()

	eventstarted = 1

	for(var/obj/structure/holowindow/W in currentarea)
		qdel(W)

	for(var/mob/M in currentarea)
		M << "FIGHT!"
