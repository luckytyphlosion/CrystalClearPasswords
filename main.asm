INCLUDE "macros/enum.asm"
INCLUDE "constants/item_constants.asm"
INCLUDE "constants/move_constants.asm"
INCLUDE "constants/pokemon_constants.asm"

wOptions EQU $cfcc
hBGMapThird EQU $ffd5

SECTION "Fix Instant Text Hook", ROM0[$3190]
	jp FixInstantTextHook
FixInstantTextHookReturn::

SECTION "Fix Instant Text", ROM0[$3e68]
; Note to ShockSlayer:
; this is so text will unconditionally
; print instantly for the NONE option
; regardless of whether the player is
; holding A or B
FixInstantTextHook::
	ld a, [wOptions]
	and %111
	ret z
	push hl
	push de
	push bc
	ld a, 2
	ld [hBGMapThird], a
	jp FixInstantTextHookReturn

SECTION "Fix Default Text Speed", ROMX[$4fc4], BANK[$5]
; Note to ShockSlayer:
; this is DefaultOptions, consider changing the default text speed
; to FAST/NONE
	db 0 ; for instant text speed

SECTION "Patch Password Reference", ROMX[$57b5], BANK[$13]
	ld hl, NewPasswords

SECTION "Patch Password Terminator Check", ROMX[$57c4], BANK[$13]
; Note to ShockSlayer:
; Your end-of-terminator code is buggy.
; By checking the terminator before the constant add,
; you are checking the terminator when hl can be at any point in the password
; and not at the proper end location
; this snippet will properly fix the code
;	call CompareBytes
;	jr c, .matchingPassword
;	inc hl
	add hl, bc
	nop
	nop
	nop
	nop ; remove nops for actual source fix
	ld a, [hl]
	cp $ff
	jr z, $57f1 ; end of terminator label, hardcoded address
	; jr .loop

SECTION "Patch Pokemon Data Reference 1", ROMX[$5817], BANK[$13]
; Note to ShockSlayer:
; Not zero-indexing the entry index?

; for indices 01-7e
	ld hl, NewPokemonSource

SECTION "Patch Pokemon Data Reference 2", ROMX[$5832], BANK[$13]
; Note to ShockSlayer:
; sub $e4 here when index compared is $e0? maybe has something to do
; with the multiple give mon function
; also, the ifgreater script command is not the same as the nc flag
; ifgreater $e0 would only accept values of $e1 and above
; while cp $e0 \ jr nc will accept values of $e0 and above

; for indices >= $e0
	ld hl, NewPokemonSource

SECTION "Patch Pokemon Data Reference 3", ROMX[$583f], BANK[$13]
; Note to ShockSlayer:
; sub $7f when the index compared is $7e?

; for indices $7e <= index < $e0
	ld hl, NewPokemonSource

SECTION "New Passwords", ROMX[$78e4], BANK[$13]
; format:
; 8 decimal numbers, then entry index of pokemon to give (one-indexed because ???)
; indices above $e0 don't set an event flag
; but are probably buggy due to messy comparisons
; enough space for 79 pokemon
; also, indices 1 through 6 inclusive will allow inscribing a trophy for PIGYournament winners

NewPasswords::
	; 16 -> 58913? I wonder what could this mean...
	; this is a joke, password can be whatever
	db 1, 6, 0, 5, 8, 9, 1, 3
	db 1 ; corresponds to first entry
	db 0, 4, 0, 3, 2, 9, 5, 6
	db 2 ; corresponds to second entry, pattern should be easy to follow
	db 2, 0, 1, 8, 1, 0, 0, 5
	db 3
	db 0, 0, 1, 8, 3, 9, 5, 4
	db 4
	db 0, 2, 3, 5, 0, 8, 1, 7
	db 5
	db 0, 0, 1, 3, 5, 9, 0, 0
	db 6
	db $ff ; terminator

SECTION "New Pokemon Source", ROMX[$7bad], BANK[$13]
; format:
; first 14 bytes of the battle_mon_struct
; see macros/wram.asm in pokecrystal
; alternatively:
; \1Species::   db
; \1Item::      db
; \1Moves::     ds NUM_MOVES
; \1MovesEnd::
; \1DVs::       dw
; \1PP::        ds NUM_MOVES
; \1Happiness:: db
; \1Level::     db
NewPokemonSource::
; first entry
	db MACHAMP ; species

	db BLACKBELT ; item

	; moves
	db CROSS_CHOP
	db ROCK_SLIDE
	db EARTHQUAKE
	db HIDDEN_POWER ; bug
	
	; dvs
	dn 13, 13, 15, 15

	; pp (only for PP Ups)
	db 255, 255, 255, 255

	; happiness
	db 255
	; level
	db 100

; second entry
	db OCTILLERY ; species

	db MYSTIC_WATER ; item

	; moves
	db FLAMETHROWER
	db SURF
	db RETURN
	db ICE_BEAM

	; dvs
	dn 15, 15, 15, 15

	; pp (only for PP Ups)
	db 255, 255, 255, 255

	; happiness
	db 255
	; level
	db 100
; third entry
; ultimate(-ish) HM slave
	db RAICHU ; species

	db MAGNET ; item

	; moves
	db THUNDERBOLT
	db SURF
	db THUNDER_WAVE
	db SEISMIC_TOSS

	; dvs
	dn 15, 15, 15, 15

	; pp (only for PP Ups)
	db 255, 255, 255, 255

	; happiness
	db 255
	; level
	db 100
; fourth entry
	db PIDGEOT ; species

	db POLKADOT_BOW ; item

	; moves
	db RETURN
	db FLY
	db STEEL_WING
	db HIDDEN_POWER ; ground

	; dvs
	dn 12, 15, 15, 15

	; pp (only for PP Ups)
	db 255, 255, 255, 255

	; happiness
	db 255
	; level
	db 100

; fifth entry
	db HOUNDOOM ; species

	db CHARCOAL ; item

	; moves
	db FLAMETHROWER
	db CRUNCH
	db SUNNY_DAY
	db SOLARBEAM

	; dvs
	dn 15, 15, 15, 15

	; pp (only for PP Ups)
	db 255, 255, 255, 255

	; happiness
	db 255
	; level
	db 100

; sixth entry
	db NIDOKING ; species

	db SOFT_SAND ; item

	; moves
	db EARTHQUAKE
	db LOVELY_KISS
	db ICE_BEAM
	db THUNDERBOLT

	; dvs
	dn 15, 15, 15, 15

	; pp (only for PP Ups)
	db 255, 255, 255, 255

	; happiness
	db 255
	; level
	db 100

; Note to ShockSlayer:
; Unrelated to this patch, but you do not need
; to use a text_jump for text in the same bank.
; All you need to do is use the "text" macro.
; Example:
; SampleText:
;     text_jump .ThisIsAUselessJump
;     db "@"
; .ThisIsAUselessJump:
;     text "Sample Text"
;     done
; This should be converted to:
; SampleText:
;     text "Sample Text"
;     done

; These two patches remove the jump that redirects script execution
; to sample trophy text.
SECTION "Patch Dummied Gold Trophy Jump", ROMX[$6ed8], BANK[$9]
	dw @ + 2 ; jump 2 ahead to actual trophy winner code

SECTION "Patch Dummied Silver Trophy Jump", ROMX[$6f03], BANK[$9]
	dw @ + 2 ; jump 2 ahead to actual trophy winner code


