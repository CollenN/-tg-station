/turf/simulated/floor/holofloor
	icon_state = "floor"
	thermal_conductivity = 0

/turf/simulated/floor/holofloor/attackby(obj/item/weapon/W as obj, mob/user as mob)
	return // HOLOFLOOR DOES NOT GIVE A FUCK

/turf/simulated/floor/holofloor/grass
	thermal_conductivity = 0
	gender = PLURAL
	name = "lush grass"

/turf/simulated/floor/fancy/grass/holo/attackby(obj/item/weapon/W as obj, mob/user as mob)
	return

/turf/simulated/floor/holofloor/asteroid
	name = "Asteroid"
	icon_state = "asteroid0"

/turf/simulated/floor/holofloor/asteroid/New()
	icon_state = "asteroid[pick(0,1,2,3,4,5,6,7,8,9,10,11,12)]"
	..()

/turf/simulated/floor/holofloor/space
	name = "Space"
	icon = 'icons/turf/space.dmi'
	icon_state = "0"

/turf/simulated/floor/holofloor/space/New()
	icon_state = "[((x + y) ^ ~(x * y) + z) % 25]" // so realistic
	..()

/turf/simulated/floor/holofloor/hyperspace
	name = "Hyperspace"
	icon = 'icons/turf/space.dmi'
	icon_state = "speedspace_ew_1"

/turf/simulated/floor/holofloor/hyperspace/New()
	icon_state = "speedspace_ew_[(x + 5*y + (y%2+1)*7)%15+1]"
	..()

/turf/simulated/floor/holofloor/hyperspace/ns/New()
	..()
	icon_state = "speedspace_ns_[(x + 5*y + (y%2+1)*7)%15+1]"