/*

Miscellaneous traitor devices

BATTERER

IRRADIATION DEVICE

*/

/*

The Batterer, like a flashbang but 50% chance to knock people over. Can be either very
effective or pretty fucking useless.

*/

/obj/item/device/batterer
	name = "mind batterer"
	desc = "A strange device with twin antennas."
	icon_state = "batterer"
	throwforce = 5
	w_class = 1.0
	throw_speed = 3
	throw_range = 7
	flags = CONDUCT
	item_state = "electronic"
	origin_tech = "magnets=3;combat=3;syndicate=3"

	var/times_used = 0 //Number of times it's been used.
	var/max_uses = 2


/obj/item/device/batterer/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	if(!user) 	return
	if(times_used >= max_uses)
		user << "\red The mind batterer has been burnt out!"
		return

	add_logs(user, null, "knocked down people in the area", admin=0, object="[src]")

	for(var/mob/living/carbon/human/M in orange(10, user))
		spawn()
			if(prob(50))

				M.Weaken(rand(10,20))
				if(prob(25))
					M.Stun(rand(5,10))
				M << "\red <b>You feel a tremendous, paralyzing wave flood your mind.</b>"

			else
				M << "\red <b>You feel a sudden, electric jolt travel through your head.</b>"

	playsound(src.loc, 'sound/misc/interference.ogg', 50, 1)
	user << "\blue You trigger [src]."
	times_used += 1
	if(times_used >= max_uses)
		icon_state = "battererburnt"

/obj/item/device/irradscanner
	name = "Health Analyzer"
	icon_state = "health"
	item_state = "analyzer"
	desc = "A powerful radiation source disguised as a common medical scanner."
	flags = FPRINT  | CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = 1.0
	throw_speed = 5
	throw_range = 10
	m_amt = 200
	origin_tech = "magnets=1;biotech=2;syndicate=4"
	var/charges = 5

/obj/item/device/irradscanner/attack(mob/living/M as mob, mob/living/user as mob)
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	if(charges != 0)
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [] has analyzed []'s vitals!", user, M), 1)
		M.apply_effect((rand(115, 150)), IRRADIATE, 0)
		charges--
		return
	else
		..()
		user << "The irradiation device is out of charges!"
		return
