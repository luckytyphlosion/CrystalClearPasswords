INCLUDE "macros/enum.asm"
INCLUDE "constants/item_constants.asm"
INCLUDE "constants/move_constants.asm"
INCLUDE "constants/pokemon_constants.asm"

wOptions EQU $cfcc

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

NewPasswords::
	; 16 -> 58913? I wonder what could this mean...
	; this is a joke, password can be whatever
	db 1, 6, 0, 5, 8, 9, 1, 3
	db 1
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
	db DONPHAN ; species
	
	db BERSERK_GENE ; item
	
	; moves
	db DOUBLE_EDGE
	db EARTHQUAKE
	db REST
	db SLEEP_TALK
	
	; dvs
	dn 15, 10, 10, 10
	
	; pp
	db 4, 20, 6, 9

	; happiness
	db 255
	; level
	db 60
