
; =============== S U B R O U T I N E =======================================

Obj_Monitor:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Monitor_Index(pc,d0.w),d1
		jmp	Monitor_Index(pc,d1.w)
; ---------------------------------------------------------------------------

Monitor_Index: offsetTable
		offsetTableEntry.w Obj_MonitorInit			; 0
		offsetTableEntry.w Obj_MonitorMain		; 2
		offsetTableEntry.w Obj_MonitorBreak		; 4
		offsetTableEntry.w Obj_MonitorAnimate		; 6
		offsetTableEntry.w loc_1D61A				; 8
; ---------------------------------------------------------------------------

Obj_MonitorInit:
		addq.b	#2,routine(a0)
		move.b	#$F,y_radius(a0)
		move.b	#$F,x_radius(a0)
		move.l	#Map_Monitor,mappings(a0)
		move.w	#make_art_tile(ArtTile_Powerups,0,0),art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.w	#$180,priority(a0)
		move.b	#28/2,width_pixels(a0)
		move.b	#32/2,height_pixels(a0)
		move.w	respawn_addr(a0),d0				; Get address in respawn table
		beq.s	.notbroken						; If it's zero, it isn't remembered
		movea.w	d0,a2							; Load address into a2
		btst	#0,(a2)								; Is this monitor broken?
		beq.s	.notbroken						; If not, branch
		move.b	#$B,mapping_frame(a0)			; Use 'broken monitor' frame
		move.l	#Sprite_OnScreen_Test,address(a0)
		rts
; ---------------------------------------------------------------------------

.notbroken:
		move.b	#$46,collision_flags(a0)
		move.b	subtype(a0),anim(a0)				; Subtype determines what powerup is inside

Obj_MonitorMain:
		bsr.s	Obj_MonitorFall

;SolidObject_Monitor:
		move.w	#$19,d1							; Monitor's width
		move.w	#$10,d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		lea	(Player_1).w,a1
		moveq	#p1_standing_bit,d6
		movem.l	d1-d4,-(sp)
		bsr.w	SolidObject_Monitor_SonicKnux
		movem.l	(sp)+,d1-d4
		bsr.w	Add_SpriteToCollisionResponseList
		lea	Ani_Monitor(pc),a1
		jsr	(Animate_Sprite).w

loc_1D61A:
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

Obj_MonitorAnimate:
		cmpi.b	#$B,mapping_frame(a0)			; Is monitor broken?
		bne.s	.notbroken						; If not, branch
		move.l	#loc_1D61A,address(a0)

.notbroken:
		lea	Ani_Monitor(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

Obj_MonitorFall:
		move.b	routine_secondary(a0),d0
		beq.s	locret_1D694
		btst	#1,render_flags(a0)					; Is monitor upside down?
		bne.s	Obj_MonitorFallUpsideDown		; If so, branch

Obj_MonitorFallUpsideUp:
		jsr	(MoveSprite).w
		tst.w	y_vel(a0)						; Is monitor moving up?
		bmi.s	locret_1D694						; If so, return
		bsr.w	ObjCheckFloorDist
		tst.w	d1								; Is monitor in the ground?
		beq.s	.inground						; If so, branch
		bpl.s	locret_1D694						; if not, return

.inground:
		add.w	d1,y_pos(a0)						; Move monitor out of the ground
		clr.w	y_vel(a0)
		clr.b	routine_secondary(a0)					; Stop monitor from falling
		rts
; ---------------------------------------------------------------------------

Obj_MonitorFallUpsideDown:
		jsr	(MoveSprite_ReverseGravity).w
		tst.w	y_vel(a0)						; Is monitor moving down?
		bmi.s	locret_1D694						; If so, return
		bsr.w	ObjCheckCeilingDist
		tst.w	d1								; Is monitor in the ground (ceiling)?
		beq.s	.inground						; If so, branch
		bpl.s	locret_1D694						; if not, return

.inground:
		sub.w	d1,y_pos(a0)						; Move monitor out of the ground
		clr.w	y_vel(a0)
		clr.b	routine_secondary(a0)					; Stop monitor from falling

locret_1D694:
		rts
; End of function Obj_MonitorFall

; =============== S U B R O U T I N E =======================================

SolidObject_Monitor_SonicKnux:
		btst	d6,status(a0)							; Is Sonic/Knux standing on the monitor?
		bne.s	Monitor_ChkOverEdge				; If so, branch
		cmpi.b	#id_Roll,anim(a1)					; Is Sonic/Knux in their rolling animation?
		beq.s	locret_1D694						; If so, return
		bra.w	SolidObject_cont
; End of function SolidObject_Monitor_SonicKnux

; =============== S U B R O U T I N E =======================================

Monitor_ChkOverEdge:
		move.w	d1,d2
		add.w	d2,d2
		btst	#1,status(a1)							; Is the character in the air?
		bne.s	.notonmonitor					; If so, branch
		; Check if character is standing on
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	.notonmonitor					; Branch, if character is behind the left edge of the monitor
		cmp.w	d2,d0
		blo.s		Monitor_CharStandOn				; Branch, if character is not beyond the right edge of the monitor

.notonmonitor:
		; if the character isn't standing on the monitor
		bclr	#3,status(a1)							; Clear 'on object' bit
		bset	#1,status(a1)							; Set 'in air' bit
		bclr	d6,status(a0)							; Clear 'standing on' bit for the current character
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

Monitor_CharStandOn:
		move.w	d4,d2
		bsr.w	MvSonicOnPtfm
		moveq	#0,d4
		rts
; End of function SolidObject_Monitor_Tails

; =============== S U B R O U T I N E =======================================

Obj_MonitorBreak:
		move.b	status(a0),d0
		andi.b	#standing_mask|pushing_mask,d0	; Is someone touching the monitor?
		beq.s	Obj_MonitorSpawnIcon			; If not, branch
		move.b	d0,d1
		andi.b	#p1_standing|p1_pushing,d1		; Is it the main character?
		beq.s	Obj_MonitorSpawnIcon			; If not, branch
		andi.b	#$D7,(Player_1+status).w
		ori.b	#2,(Player_1+status).w				; Prevent main character from walking in the air

Obj_MonitorSpawnIcon:
		andi.b	#3,status(a0)
		clr.b	collision_flags(a0)
		jsr	(Create_New_Sprite3).w
		bne.s	.skipiconcreation
		move.l	#Obj_MonitorContents,address(a1)
		move.w	x_pos(a0),x_pos(a1)				; Set icon's position
		move.w	y_pos(a0),y_pos(a1)
		move.b	anim(a0),anim(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	status(a0),status(a1)

.skipiconcreation:
		jsr	(Create_New_Sprite3).w
		bne.s	.skipexplosioncreation
		move.l	#Obj_Explosion,address(a1)
		addq.b	#2,routine(a1)					; => loc_1E61A
		move.w	x_pos(a0),x_pos(a1)				; Set explosion's position
		move.w	y_pos(a0),y_pos(a1)

.skipexplosioncreation:
		move.w	respawn_addr(a0),d0				; Get address in respawn table
		beq.s	.notremembered					; If it's zero, it isn't remembered
		movea.w	d0,a2							; Load address into a2
		bset	#0,(a2)								; Mark monitor as destroyed

.notremembered:
		move.b	#$A,anim(a0)					; Display 'broken' animation
		move.l	#Obj_MonitorAnimate,address(a0)
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_MonitorContents:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	off_1D7C8(pc,d0.w),d1
		jmp	off_1D7C8(pc,d1.w)
; ---------------------------------------------------------------------------

off_1D7C8: offsetTable
		offsetTableEntry.w loc_1D7CE
		offsetTableEntry.w loc_1D81A
		offsetTableEntry.w loc_1DB2E
; ---------------------------------------------------------------------------

loc_1D7CE:
		addq.b	#2,routine(a0)
		move.w	#make_art_tile(ArtTile_Powerups,0,0),art_tile(a0)
		ori.b	#$24,render_flags(a0)
		move.w	#$180,priority(a0)
		move.b	#8,width_pixels(a0)
		move.w	#-$300,y_vel(a0)
		btst	#1,render_flags(a0)
		beq.s	loc_1D7FC
		neg.w	y_vel(a0)

loc_1D7FC:
		moveq	#0,d0
		move.b	anim(a0),d0
		addq.b	#1,d0
		move.b	d0,mapping_frame(a0)
		lea	Map_Monitor(pc),a1
		add.b	d0,d0
		adda.w	(a1,d0.w),a1
		addq.w	#2,a1
		move.l	a1,mappings(a0)

loc_1D81A:
		bsr.s	sub_1D820
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

sub_1D820:
		btst	#1,render_flags(a0)
		bne.s	loc_1D83C
		tst.w	y_vel(a0)
		bpl.w	loc_1D850
		jsr	(MoveSprite2).w
		addi.w	#$18,y_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_1D83C:
		tst.w	y_vel(a0)
		bmi.w	loc_1D850
		jsr	(MoveSprite2).w
		subi.w	#$18,y_vel(a0)
		rts
; ---------------------------------------------------------------------------

loc_1D850:
		addq.b	#2,routine(a0)
		move.w	#$1D,anim_frame_timer(a0)
		lea	(Player_1).w,a1
		moveq	#0,d0
		move.b	anim(a0),d0
		add.w	d0,d0
		move.w	off_1D87C(pc,d0.w),d0
		jmp	off_1D87C(pc,d0.w)
; End of function sub_1D820
; ---------------------------------------------------------------------------

off_1D87C: offsetTable
		offsetTableEntry.w Monitor_Give_Eggman
		offsetTableEntry.w Monitor_Give_Eggman
		offsetTableEntry.w Monitor_Give_Eggman
		offsetTableEntry.w Monitor_Give_Rings
		offsetTableEntry.w Monitor_Give_Super_Sneakers
		offsetTableEntry.w Monitor_Give_Fire_Shield
		offsetTableEntry.w Monitor_Give_Lightning_Shield
		offsetTableEntry.w Monitor_Give_Bubble_Shield
		offsetTableEntry.w Monitor_Give_Invincibility
		offsetTableEntry.w Monitor_Give_Eggman
; ---------------------------------------------------------------------------

Monitor_Give_Eggman:
		bra.w	sub_24280
; ---------------------------------------------------------------------------

Monitor_Give_Rings:
		addi.w	#10,(v_rings).w	; add 10 rings to the number of rings you have
		ori.b	#1,(f_ringcount).w ; update the ring counter
		music	sfx_Ring,1,0,0	; play ring sound
; ---------------------------------------------------------------------------

Monitor_Give_Super_Sneakers:
		bset	#2,status_secondary(a1)
		move.b	#150,speed_shoes_timer(a1)
		move.w	#$C00,(Sonic_Knux_top_speed).w
		move.w	#$18,(Sonic_Knux_acceleration).w
		move.w	#$80,(Sonic_Knux_deceleration).w
		music	bgm_Speedup,1,0,0	; Speed up the music
; ---------------------------------------------------------------------------

Monitor_Give_Fire_Shield:
		andi.b	#$8E,status_secondary(a1)
		bset	#Status_Shield,status_secondary(a1)
		bset	#Status_FireShield,status_secondary(a1)
		move.l	#Obj_Fire_Shield,(v_Shield).w
		music	sfx_FireShield,1,0,0
; ---------------------------------------------------------------------------

Monitor_Give_Lightning_Shield:
		andi.b	#$8E,status_secondary(a1)
		bset	#Status_Shield,status_secondary(a1)
		bset	#Status_LtngShield,status_secondary(a1)
		move.l	#Obj_Lightning_Shield,(v_Shield).w
		music	sfx_LightShield,1,0,0
; ---------------------------------------------------------------------------

Monitor_Give_Bubble_Shield:
		andi.b	#$8E,status_secondary(a1)
		bset	#Status_Shield,status_secondary(a1)
		bset	#Status_BublShield,status_secondary(a1)
		move.l	#Obj_Bubble_Shield,(v_Shield).w
		music	sfx_BubleShield,1,0,0
; ---------------------------------------------------------------------------

Monitor_Give_Invincibility:
		bset	#Status_Invincible,status_secondary(a1)
		move.b	#150,invincibility_timer(a1)
		tst.b	(Level_end_flag).w
		bne.s	loc_1DA3E
		tst.b	(Boss_flag).w
		bne.s	loc_1DA3E
		cmpi.b	#12,air_left(a1)
		bls.s		loc_1DA3E
		music	bgm_Invincible,0,0,0	; If invincible, play invincibility music

loc_1DA3E:
		move.l	#Obj_Invincibility,(v_Invincibility_stars).w
		rts
; ---------------------------------------------------------------------------

loc_1DB2E:
		subq.w	#1,anim_frame_timer(a0)
		bmi.w	loc_1EBB6
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

		include "Objects/Monitor/Object Data/Anim - Monitor.asm"
		include "Objects/Monitor/Object Data/Map - Monitor.asm"