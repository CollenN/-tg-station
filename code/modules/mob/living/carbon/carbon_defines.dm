/mob/living/carbon/
	gender = MALE
	hud_possible = list(HEALTH_HUD,STATUS_HUD,ANTAG_HUD)
	var/list/stomach_contents	= list()
	var/list/internal_organs	= list()	//List of /obj/item/organ in the mob. they don't go in the contents.

	var/silent = 0 		//Can't talk. Value goes down every life proc.

	var/obj/item/handcuffed = null //Whether or not the mob is handcuffed
	var/obj/item/legcuffed = null  //Same as handcuffs but for legs. Bear traps use this.


	var/trail = 0	// blood/oil/xenoblood trails! the number determines the amount of tracks
	var/trailtype = null	// "blood"/"oil"/"xeno" -- type of trail

	var/list/features = list("mcolor" = "FFF", "tail" = "Smooth", "snout" = "Round", "horns" = "None", "frills" = "None", "spines" = "None", "body_markings" = "None")

//inventory slots
	var/obj/item/back = null
	var/obj/item/clothing/mask/wear_mask = null
	var/obj/item/weapon/tank/internal = null
	var/obj/item/head = null

	var/datum/dna/dna = null//Carbon

	var/failed_last_breath = 0 //This is used to determine if the mob failed a breath. If they did fail a brath, they will attempt to breathe each tick, otherwise just once per 4 ticks.

	var/co2overloadtime = null
	var/temperature_resistance = T0C+75
	has_limbs = 1
	var/obj/item/weapon/reagent_containers/food/snacks/meat/slab/type_of_meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/

	var/remote_view = 0
	var/gib_type = /obj/effect/decal/cleanable/blood/gibs
