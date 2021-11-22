
; =============== S U B R O U T I N E =======================================

Obj_InvisibleHurtBlockHorizontal:
		move.l	#Map_InvisibleBlock,mappings(a0)
		move.w	#make_art_tile(ArtTile_Ring,0,1),art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.w	#$200,priority(a0)
		bset	#7,status(a0)
		move.b	subtype(a0),d0
		move.b	d0,d1
		andi.w	#$F0,d0
		addi.w	#$10,d0
		lsr.w	#1,d0
		move.b	d0,width_pixels(a0)
		andi.w	#$F,d1
		addq.w	#1,d1
		lsl.w	#3,d1
		move.b	d1,height_pixels(a0)
		btst	#0,status(a0)
		beq.s	loc_1F448
		move.l	#loc_1F4C4,address(a0)
		rts
; ---------------------------------------------------------------------------

loc_1F448:
		btst	#1,status(a0)
		beq.s	loc_1F458
		move.l	#loc_1F528,address(a0)

locret_1F456:
		rts
; ---------------------------------------------------------------------------

loc_1F458:
		move.l	#loc_1F45E,address(a0)

loc_1F45E:
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull2).w
		move.b	status(a0),d6
		andi.b	#$18,d6
		beq.s	loc_1F4A2
		move.b	d6,d0
		andi.b	#8,d0
		beq.s	loc_1F4A2
		lea	(Player_1).w,a1
		bsr.w	sub_1F58C

loc_1F4A2:
		move.w	x_pos(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#$280,d0
		bhi.w	loc_1EBAA
		tst.w	(Debug_placement_mode).w
		beq.s	locret_1F456
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

loc_1F4C4:
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull2).w
		swap	d6
		andi.w	#3,d6
		beq.s	loc_1F506
		move.b	d6,d0
		andi.b	#1,d0
		beq.s	loc_1F506
		lea	(Player_1).w,a1
		bsr.s	sub_1F58C

loc_1F506:
		move.w	x_pos(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#$280,d0
		bhi.w	loc_1EBAA
		tst.w	(Debug_placement_mode).w
		beq.s	locret_1F59E
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

loc_1F528:
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull2).w
		swap	d6
		andi.w	#$C,d6
		beq.s	loc_1F56A
		move.b	d6,d0
		andi.b	#4,d0
		beq.s	loc_1F56A
		lea	(Player_1).w,a1
		bsr.s	sub_1F58C

loc_1F56A:
		move.w	x_pos(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#$280,d0
		bhi.w	loc_1EBAA
		tst.w	(Debug_placement_mode).w
		beq.s	locret_1F59E
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

sub_1F58C:
		move.b	shield_reaction(a0),d0
		andi.b	#$73,d0
		and.b	status_secondary(a1),d0
		bne.s	locret_1F59E
		bsr.w	sub_24280

locret_1F59E:
		rts
; End of function sub_1F58C
