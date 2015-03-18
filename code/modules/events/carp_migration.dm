/datum/round_event_control/carp_migration
	name				= "Carp Migration"
	typepath			= /datum/round_event/carp_migration
	weight				= 10
	earliest_start		= 6000
	max_occurrences		= 6
	minimumCrew			= 4

/datum/round_event/carp_migration
	announceWhen	= 3
	startWhen = 50

/datum/round_event/carp_migration/setup()
	startWhen = rand(40, 60)

/datum/round_event/carp_migration/announce()
	priority_announce("Unknown biological entities have been detected near [station_name()], please stand-by.", "Lifesign Alert")


/datum/round_event/carp_migration/start()
	var/p = 100
	if(player_list.len <= 5)
		p = 25
	else if(player_list.len <= 10)
		p = 50
	else if(player_list.len <= 15)
		p = 75
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn" && prob(p))
			if(prob(95))
				new /mob/living/simple_animal/hostile/carp(C.loc)
			else
				new /mob/living/simple_animal/hostile/carp/megacarp(C.loc)
