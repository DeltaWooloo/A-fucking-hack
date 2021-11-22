; ===========================================================================
; RAM variables
; ===========================================================================

; RAM variables - General
	phase	ramaddr($FFFF0000)	; Pretend we're in the RAM
RAM_Start:
Chunk_table:							ds.b $8000				; Chunk (128x128) definitions, $80 bytes per definition
Chunk_table_End

Player_1:														; Main character in 1 player mode
v_player:
Object_RAM:							ds.b object_size
									ds.b object_size
Reserved_object_3:					ds.b object_size			; During a level, an object whose sole purpose is to clear the collision response list is stored here
Dynamic_object_RAM:				ds.b object_size*90		; 90 objects
Dynamic_object_RAM_End
									ds.b object_size
v_Dust:								ds.b object_size
v_Shield:							ds.b object_size
									ds.b object_size
v_Breathing_bubbles:					ds.b object_size
									ds.b object_size
									ds.b object_size
									ds.b object_size
									ds.b object_size
									ds.b object_size
									ds.b object_size
									ds.b object_size
v_WaterWave:						ds.b object_size
v_Invincibility_stars:					ds.b object_size*4			; 4 objects
									ds.b $34					; Null
Object_RAM_End

Kos_decomp_buffer:					ds.b $1000				; Each module in a KosM archive is decompressed here and then DMAed to VRAM

H_scroll_buffer:						ds.l 224					; Horizontal scroll table is built up here and then DMAed to VRAM
H_scroll_table:						ds.b 512					; offsets for background scroll positions, used by ApplyDeformation
H_scroll_buffer_End

Collision_response_list:				ds.b 128					; Only objects in this list are processed by the collision response routines
Pos_table:							ds.l 64					; Recorded player XY position buffer
Ring_status_table:					ds.w RingTable_Count		; Ring status table(1 word)
Ring_status_table_End
Object_respawn_table:					ds.b ObjectTable_Count	; Object respawn table(1 byte)
Object_respawn_table_End
Sprite_table_buffer:					ds.b 80*8
Sprite_table_buffer_End
Sprite_table_input:					ds.b $80*8				; Sprite table input buffer
Sprite_table_input_End

DMA_queue:
VDP_Command_Buffer:				ds.w $12*7				; Stores all the VDP commands necessary to initiate a DMA transfer
DMA_queue_slot:
VDP_Command_Buffer_Slot:			ds.l 1					; Points to the next free slot on the queue

Camera_RAM:												; Various camera and scroll-related variables are stored here
H_scroll_amount:						ds.w 1					; Number of pixels camera scrolled horizontally in the last frame * $100
V_scroll_amount:						ds.w 1					; Number of pixels camera scrolled vertically in the last frame * $100
Camera_target_min_X_pos:			ds.w 1
Camera_target_max_X_pos:			ds.w 1
Camera_target_min_Y_pos:			ds.w 1
Camera_target_max_Y_pos:			ds.w 1
Camera_min_X_pos:					ds.w 1
Camera_max_X_pos:					ds.w 1
Camera_min_Y_pos:					ds.w 1
Camera_max_Y_pos:					ds.w 1
Saved_Camera_max_X_pos:			ds.w 1
Saved_Camera_min_X_pos:			ds.w 1
Saved_Camera_min_Y_pos:			ds.w 1
Saved_Camera_target_max_Y_pos:		ds.w 1
Camera_min_X_pos_Saved:			ds.w 1
Camera_max_X_pos_Saved:			ds.w 1
Camera_min_Y_pos_Saved:			ds.w 1
Camera_max_Y_pos_Saved:			ds.w 1
H_scroll_frame_offset:					ds.w 1					; If this is non-zero with value x, horizontal scrolling will be based on the player's position x / $100 + 1 frames ago
Pos_table_index:						ds.b 1
Pos_table_byte:						ds.b 1
Distance_from_screen_top:				ds.w 1					; The vertical scroll manager scrolls the screen until the player's distance from the top of the screen is equal to this (or between this and this + $40 when in the air). $60 by default
Camera_max_Y_pos_changing:			ds.b 1					; Set when the maximum camera Y pos is undergoing a change
									ds.b 1					; Unused
Fast_V_scroll_flag:					ds.b 1					; If this is set vertical scroll when the player is on the ground and has a speed of less than $800 is capped at 24 pixels per frame instead of 6
Scroll_lock:							ds.b 1					; If this is set scrolling routines aren't called
v_screenposx:
Camera_X_pos:						ds.l 1
v_screenposy:
Camera_Y_Pos:						ds.l 1
Camera_X_pos_copy:					ds.l 1
Camera_Y_pos_copy:					ds.l 1
Camera_X_pos_rounded:				ds.w 1					; rounded down to the nearest block boundary ($10th pixel)
Camera_Y_pos_rounded:				ds.w 1					; rounded down to the nearest block boundary ($10th pixel)
Camera_X_pos_BG_copy:				ds.l 1
Camera_Y_pos_BG_copy:				ds.l 1
Camera_X_pos_BG_rounded:			ds.w 1					; rounded down to the nearest block boundary ($10th pixel)
Camera_Y_pos_BG_rounded:			ds.w 1					; rounded down to the nearest block boundary ($10th pixel)
Camera_X_pos_coarse:				ds.w 1					; Rounded down to the nearest chunk boundary (128th pixel)
Camera_Y_pos_coarse:				ds.w 1					; Rounded down to the nearest chunk boundary (128th pixel)
Camera_X_pos_coarse_back:			ds.w 1					; Camera_X_pos_coarse - $80
Camera_Y_pos_coarse_back:			ds.w 1					; Camera_Y_pos_coarse - $80
Plane_double_update_flag:				ds.w 1					; Set when two block are to be updated instead of one (i.e. the camera's scrolled by more than $10 pixels)
HScroll_Shift:
Camera_Hscroll_shift:					ds.w 3
	if	ExtendedCamera
Camera_X_Center:					ds.w 1
	endif
Screen_X_wrap_value:				ds.w 1					; Set to $FFFF
Screen_Y_wrap_value:					ds.w 1					; Either $7FF or $FFF
Camera_Y_pos_mask:					ds.w 1					; Either $7F0 or $FF0
Layout_row_index_mask:				ds.w 1					; Either $3C or $7C
Plane_buffer_2_addr:					ds.l 1					; The address of the second plane buffer to process, if applicable
Screen_shaking_flag:					ds.l 1					; Activates screen shaking code (if existent) in layer deformation routine
Camera_RAM_End

Ring_start_addr_ROM:				ds.l 1					; Address in the ring layout of the first ring whose X position is >= camera X position - 8
Ring_end_addr_ROM:					ds.l 1					; Address in the ring layout of the first ring whose X position is >= camera X position + 328
Ring_start_addr_RAM:				ds.w 1					; Address in the ring status table of the first ring whose X position is >= camera X position - 8
Ring_consumption_table:										; Stores the addresses of all rings currently being consumed
Ring_consumption_count:				ds.w 1					; The number of rings being consumed currently
Ring_consumption_list:				ds.w $3F					; The remaining part of the ring consumption table
Ring_consumption_table_End

Plane_Buffer:							ds.b $480				; Used by level drawing routines

v_snddriver_ram:						ds.b $400				; Start of RAM for the sound driver data

v_gamemode:
Game_mode:							ds.b 1
V_int_routine:
v_vbla_routine:						ds.b 1

SonicControl:
Ctrl_1_logical:
v_jpadhold2:
Ctrl_1_held_logical:					ds.b 1
v_jpadpress2:
Ctrl_1_pressed_logical:				ds.b 1
Joypad:
Ctrl_1:
Ctrl_1_held:
Ctrl_1_hold:
v_jpadhold1:							ds.b 1
v_jpadpress1:
Ctrl_1_press:
Ctrl_1_pressed:						ds.b 1
Ctrl_2:
Ctrl_2_held:
Ctrl_2_hold:
v_jpad2hold1:						ds.b 1
v_jpad2press1:
Ctrl_2_press:
Ctrl_2_pressed:						ds.b 1
v_vdp_buffer1:
VDP_reg_1_command:				ds.w 1					; AND the lower byte by $BF and write to VDP control port to disable display, OR by $40 to enable
Demo_timer:
v_demolength:						ds.w 1					; The time left for a demo to start/run
V_scroll_value:												; Both foreground and background
v_scrposy_dup:
V_scroll_value_FG:					ds.w 1
V_scroll_value_BG:					ds.w 1
H_scroll_value:
v_scrposx_dup:
H_scroll_value_FG:					ds.w 1
H_scroll_value_BG:					ds.w 1
v_hbla_hreg:
H_int_counter_command:				ds.b 1					; Contains a command to write to VDP register $0A (line interrupt counter)
v_hbla_line:
H_int_counter:						ds.b 1					; Just the counter part of the command
v_random:
RNG_seed:							ds.l 1					; Used by the random number generator
v_pfade_start:
Palette_fade_info:												; Both index and count
Palette_fade_index:					ds.b 1					; Colour to start fading from
v_pfade_size:
Palette_fade_count:					ds.b 1					; The number of colours to fade

Lag_frame_count:						ds.w 1					; More specifically, the number of times V-int routine 0 has run. Reset at the end of a normal frame
v_spritecount:
Sprites_drawn:						ds.w 1					; Used to ensure the sprite limit isn't exceeded
v_vdp_buffer2:
DMA_data_thunk:											; Used as a RAM holder for the final DMA command word. Data will NOT be preserved across V-INTs, so consider this space reserved
DMA_trigger_word:					ds.w 1					; Transferred from RAM to avoid crashing the Mega Drive
f_hbla_pal:
H_int_flag:							ds.b 1					; Unless this is set H-int will return immediately
Do_Updates_in_H_int:				ds.b 1					; If this is set Do_Updates will be called from H-int instead of V-int
WindTunnel_flag:						ds.b 1
f_lockctrl:
Ctrl_1_locked:						ds.b 1
v_framecount:
Level_frame_counter:					ds.b 1					; The number of frames which have elapsed since the level started
v_framebyte							ds.b 1
Rings_manager_routine:				ds.b 1					; Routine counter for the ring loading manager
Level_started_flag:					ds.b 1
f_pause:
Game_paused:						ds.b 1
f_restart:
Restart_level_flag:					ds.b 1
Sonic_Knux_top_speed:				ds.w 1
Sonic_Knux_acceleration:				ds.w 1
Sonic_Knux_deceleration:				ds.w 1
Object_load_addr_front:				ds.l 1					; The address inside the object placement data of the first object whose X pos is >= Camera_X_pos_coarse + $280
Object_load_addr_back:				ds.l 1					; The address inside the object placement data of the first object whose X pos is >= Camera_X_pos_coarse - $80
Object_respawn_index_front:			ds.w 1					; The object respawn table index for the object at Obj_load_addr_front
Object_respawn_index_back:			ds.w 1					; The object respawn table index for the object at Obj_load_addr_back
Collision_addr:						ds.l 1					; Points to the primary or secondary collision data as appropriate
Primary_collision_addr:				ds.l 1
Secondary_collision_addr:				ds.l 1
Player_prev_frame:					ds.b 1
Reverse_gravity_flag:					ds.b 1
Primary_Angle:						ds.b 1
Secondary_Angle:						ds.b 1
Object_load_routine:					ds.b 1					; Routine counter for the object loading manager
Deform_Lock:						ds.b 1
Boss_flag:							ds.b 1					; Set if a boss fight is going on
TitleCard_end_flag:					ds.b 1
LevResults_end_flag:					ds.b 1
NoBackground_event_flag:				ds.b 1
Screen_event_routine:					ds.b 1
Screen_event_flag:					ds.b 1
Background_event_routine:				ds.b 1
Background_event_flag:				ds.b 1
Debug_placement_mode:										; Both routine and type
Debug_placement_routine:				ds.b 1
Debug_placement_type:				ds.b 1					; 0 = normal gameplay, 1 = normal object placement, 2 = frame cycling
Debug_camera_delay:					ds.b 1
Debug_camera_speed:					ds.b 1
Debug_object:						ds.b 1					; The current position in the debug mode object list
Level_end_flag:						ds.b 1
LastAct_end_flag:						ds.b 1
Debug_mode_flag:					ds.b 1
Slotted_object_bits:					ds.w 1
Palette_cycle_counters:				ds.b $10
Pal_fade_delay:						ds.w 1
Pal_fade_delay2:						ds.w 1
Hyper_Sonic_flash_timer:				ds.b 1
Negative_flash_timer:					ds.b 1
									ds.b 1					; Unused
PalRotation_flag:						ds.b 1
PalRotation_pointer:					ds.l 1
PalRotation_buffer:					ds.b $22
Boss_Events:							ds.b $10
Chain_bonus_counter:					ds.w 1
Time_bonus_countdown:				ds.w 1					; Used on the results screen
Ring_bonus_countdown:				ds.w 1					; Used on the results screen
Total_bonus_countup:					ds.w 1
Lag_frame_count_End

Water_level:													; Keeps fluctuating
Water_Level_1:						ds.w 1
Water_Level_2:
Mean_water_level:					ds.w 1					; The steady central value of the water level
Water_Level_3:
Target_water_level:					ds.w 1
Water_on:													; Is set based on Water_flag
Water_speed:							ds.b 1					; This is added to or subtracted from Mean_water_level every frame till it reaches Target_water_level
Water_routine:
Water_entered_counter:				ds.b 1					; Incremented when entering and exiting water, read by the the floating AIZ spike log, cleared on level initialisation and dynamic events of certain levels
Water_move:
Water_full_screen_flag:				ds.b 1					; Set if water covers the entire screen (i.e. the underwater pallete should be DMAed during V-int rather than the normal palette)
Water_flag:							ds.b 1

Graphics_flags:						ds.b 1					; Bit 7 set = English system, bit 6 set = PAL system
Last_star_post_hit:
Last_star_pole_hit:					ds.b 1
Level_music:							ds.w 1
Palette_fade_timer:					ds.w 1					; The palette gets faded in until this timer expires
SegaCD_Mode:						ds.b 1
									ds.b 1					; Unused

Block_table_addr_ROM:				ds.l 1					; Block table pointer(Block (16x16) definitions, 8 bytes per definition)
Level_layout_addr_ROM:				ds.l 1					; Level layout pointer
Level_layout2_addr_ROM:				ds.l 1					; Level layout 2 pointer
Object_index_addr:					ds.l 1					; Points to either the object index for levels

Level_data_addr_RAM:
.AnPal:								ds.l 1
.Resize:								ds.l 1
.WaterResize:							ds.l 1
.AfterBoss:							ds.l 1
.ScreenInit:							ds.l 1
.BackgroundInit:						ds.l 1
.ScreenEvent:							ds.l 1
.BackgroundEvent:					ds.l 1
.AnimateTiles:						ds.l 1
.AniPLC:								ds.l 1
Level_data_addr_RAM_End

Kos_decomp_queue_count:				ds.w 1					; The number of pieces of data on the queue. Sign bit set indicates a decompression is in progress
Kos_decomp_stored_registers:			ds.b $28					; Allows decompression to be spread over multiple frames
Kos_decomp_stored_SR:				ds.w 1
Kos_decomp_bookmark:				ds.l 1					; The address within the Kosinski queue processor at which processing is to be resumed
Kos_description_field:					ds.w 1					; Used by the Kosinski queue processor the same way the stack is used by the normal Kosinski decompression routine
Kos_decomp_queue:											; 2 longwords per entry, first is source location and second is decompression location
Kos_decomp_source:					ds.l 8					; The compressed data location for the first entry in the queue
Kos_decomp_destination:				= Kos_decomp_queue+4	; The decompression location for the first entry in the queue
Kos_decomp_queue_End
Kos_modules_left:						ds.w 1					; The number of modules left to decompresses. Sign bit set indicates a module is being decompressed/has been decompressed
Kos_last_module_size:					ds.w 1					; The uncompressed size of the last module in words. All other modules are $800 words
Kos_module_queue:					ds.b 6*PLCKosM_Count	; 6 bytes per entry, first longword is source location and next word is VRAM destination
Kos_module_source:					= Kos_module_queue		; The compressed data location for the first module in the queue
Kos_module_destination:				= Kos_module_queue+4	; The VRAM destination for the first module in the queue
Kos_module_queue_End

v_pal_water_dup:
Target_water_palette:											; Used by palette fading routines
Target_water_palette_line_1:			ds.w 16
Target_water_palette_line_2:			ds.w 16
Target_water_palette_line_3:			ds.w 16
Target_water_palette_line_4:			ds.w 16
v_pal_water:
Water_palette:												; This is what actually gets displayed
Water_palette_line_1:					ds.w 16
Water_palette_line_2:					ds.w 16
Water_palette_line_3:					ds.w 16
Water_palette_line_4:					ds.w 16
v_pal_dry:
Normal_palette:												; This is what actually gets displayed
Normal_palette_line_1:				ds.w 16
Normal_palette_line_2:				ds.w 16
Normal_palette_line_3:				ds.w 16
Normal_palette_line_4:				ds.w 16
v_pal_dry_dup:
Target_palette:												; Used by palette fading routines
Target_palette_line_1:					ds.w 16
Target_palette_line_2:					ds.w 16
Target_palette_line_3:					ds.w 16
Target_palette_line_4:					ds.w 16

v_vbla_count:
V_int_run_count:						ds.w 1					; The number of times V-int has run
v_vbla_word:							ds.b 1
v_vbla_byte:							ds.b 1
v_zone:
Current_zone:
Current_zone_and_act:				ds.b 1
v_act:
Current_act:							ds.b 1

f_timeover:
Time_over_flag:						ds.b 1
f_ringcount:
Update_HUD_ring_count:				ds.b 1
f_timecount:
Update_HUD_timer:					ds.b 1
f_scorecount:
Update_HUD_score:					ds.b 1
v_rings:
Ring_count:							ds.b 1
v_ringbyte:							ds.b 1
v_time:
Timer:								ds.b 1
v_timemin:
Timer_minute:						ds.b 1
v_timesec:
Timer_second:						ds.b 1
v_timecent:
Timer_frame:
Timer_centisecond:					ds.b 1					; The second gets incremented when this reaches 60
v_score:
Score:								ds.l 1

HUD_RAM:
.Xpos:								ds.w 1
.Ypos:								ds.w 1
.status:								ds.b 1
									ds.b 1					; Unused

DecimalScoreRAM:					ds.l 1
DecimalScoreRAM2:					ds.l 1

Saved_zone_and_act:					ds.w 1
Saved_X_pos:						ds.w 1
Saved_Y_pos:						ds.w 1
Saved_ring_count:					ds.w 1
Saved_timer:							ds.l 1
Saved_mappings:						ds.l 1
Saved_art_tile:						ds.w 1
Saved_solid_bits:						ds.w 1					; Copy of Player 1's top_solid_bit and lrb_solid_bit
Saved_camera_X_pos:					ds.w 1
Saved_camera_Y_pos:					ds.w 1
Saved_mean_water_level:				ds.w 1
Saved_camera_max_Y_pos:			ds.w 1
Saved_dynamic_resize:				ds.l 1
Saved_water_full_screen_flag:			ds.b 1
Saved_status_secondary:				ds.b 1
Saved_last_star_post_hit:				ds.b 1
									ds.b 1					; Unused

Oscillating_variables:
Oscillating_Numbers:
Oscillation_Control:					ds.w 1
Oscillating_Data:						ds.b $40
Anim_Counters:						ds.b $10					; Each word stores data on animated level art, including duration and current frame
Level_trigger_array:					ds.b $10					; Used by buttons, etc
Level_trigger_array_End
Rings_frame_timer:					ds.b 1
Rings_frame:							ds.b 1
Ring_spill_anim_counter:				ds.b 1
Ring_spill_anim_frame:				ds.b 1
Ring_spill_anim_accum:				ds.b 1
									ds.b 1					; Unused
Oscillating_variables_End

Current_RAM_start					!org $FEF0				; Unused data
Current_RAM_end

System_stack_size					ds.b $100				; ~$100 bytes ; this is the top of the stack, it grows downwards($FEF0-$FFF0)
System_stack:
V_int_jump:							ds.w 1					; 6 bytes ; contains an instruction to jump to the V-int handler
V_int_addr:							ds.l 1
H_int_jump:							ds.w 1					; 6 bytes ; contains an instruction to jump to the H-int handler
H_int_addr:							ds.l 1
Checksum_string:						ds.l 1					; set to 'INIT' once the checksum routine has run
	if * > 0	; Don't declare more space than the RAM can contain!
		fatal "The RAM variable declarations are too large by $\{*} bytes."
	endif
	if MOMPASS=1
		message "The current RAM available $\{Current_RAM_end-Current_RAM_start} bytes."
	endif

	dephase		; Stop pretending
	!org	0		; Reset the program counter