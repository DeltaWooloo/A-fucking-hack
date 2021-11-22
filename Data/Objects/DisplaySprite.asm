; ---------------------------------------------------------------------------
; Subroutine to display	a sprite/object, when a0 is the object RAM
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Draw_Sprite:
DisplaySprite:
		lea	(Sprite_table_input).w,a1
		adda.w	priority(a0),a1

loc_1ABCE:
		cmpi.w	#$80-2,(a1)
		bhs.s	loc_1ABDC
		addq.w	#2,(a1)
		adda.w	(a1),a1
		move.w	a0,(a1)

locret_1ABDA:
		rts
; ---------------------------------------------------------------------------

loc_1ABDC:
		cmpa.w	#(Sprite_table_input_End-$80),a1
		beq.s	locret_1ABDA
		lea	$80(a1),a1
		bra.s	loc_1ABCE
; End of function DisplaySprite

; =============== S U B R O U T I N E =======================================

Draw_And_Touch_Sprite:
		bsr.w	Add_SpriteToCollisionResponseList
		bra.s	Draw_Sprite
; ---------------------------------------------------------------------------

Child_Draw_Sprite:
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.w	Go_Delete_Sprite
		bra.s	Draw_Sprite
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite:
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.w	Go_Delete_Sprite
		bsr.w	Add_SpriteToCollisionResponseList
		bra.s	Draw_Sprite
; ---------------------------------------------------------------------------

Child_CheckParent:
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.w	Go_Delete_Sprite
		rts
; ---------------------------------------------------------------------------

Child_AddToTouchList:
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.w	Go_Delete_Sprite
		bra.w	Add_SpriteToCollisionResponseList
; ---------------------------------------------------------------------------

Child_Remember_Draw_Sprite:
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.s	loc_84984
		bra.s	Draw_Sprite
; ---------------------------------------------------------------------------

loc_84984:
		bsr.w	Remove_From_TrackingSlot
		bra.w	Go_Delete_Sprite
; ---------------------------------------------------------------------------

Child_Draw_Sprite2:
		movea.w	parent3(a0),a1
		btst	#4,$38(a1)
		bne.s	loc_8499E
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------

loc_8499E:
		bra.w	Go_Delete_Sprite_2
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite2:
		movea.w	parent3(a0),a1
		btst	#4,$38(a1)
		bne.s	loc_8499E
		btst	#7,status(a1)
		bne.s	loc_849BC
		bsr.w	Add_SpriteToCollisionResponseList

loc_849BC:
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------

Child_Draw_Sprite_FlickerMove:
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.s	loc_849D8
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------

loc_849D8:
		bset	#7,status(a0)
		move.l	#Obj_FlickerMove,address(a0)
		clr.b	collision_flags(a0)
		bsr.w	Set_IndexedVelocity
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------

Child_Draw_Sprite2_FlickerMove:
		movea.w	parent3(a0),a1
		btst	#4,$38(a1)
		bne.s	loc_849D8
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite_FlickerMove:
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.s	loc_849D8

loc_84A3C:
		bsr.w	Add_SpriteToCollisionResponseList
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite2_FlickerMove:
		movea.w	parent3(a0),a1
		btst	#4,$38(a1)
		bne.s	loc_849D8
		btst	#7,status(a1)
		beq.s	loc_84A3C
		bset	#7,status(a0)
		bra.w	Draw_Sprite
