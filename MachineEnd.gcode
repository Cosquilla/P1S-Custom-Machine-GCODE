;===== date: 20230428 =====================
M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
G1 E-0.8 F1800 ; retract
G1 Z{max_layer_z + 0.5} F900 ; lower z a little
G1 X65 Y245 F12000 ; move to safe pos 
G1 Y265 F3000

G1 X65 Y245 F12000
G1 Y265 F3000

;The fans and bed will get the turn off command after chamber cooldown for following types of material: ASA, ABS, PA(Nylon), PA-CF(Nylon Carbonfibre)
{if (filament_type[initial_tool]=="ASA") || (filament_type[initial_tool]=="ABS") || (filament_type[initial_tool]=="PA-CF") || (filament_type[initial_tool]=="PA")}
{else} 
    M140 S0 ; turn off bed
    M106 S0 ; turn off fan
    M106 P2 S0 ; turn off remote part cooling fan
    M106 P3 S0 ; turn off chamber cooling fan
{endif}

G1 X100 F12000 ; wipe
G1 E-20 F200   ;Filament is pushed out 20 mm. 
M400           ;Waits until pushing out is completed before doing anything else.  
; pull back filament to AMS
M620 S255
G1 X20 Y50 F12000
G1 Y-3
T255
G1 X65 F12000
G1 Y265
G1 X100 F12000 ; wipe
M621 S255
M104 S0 ; turn off hotend

M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S3 ;wait for last picture to be taken
M623; end of "timelapse_record_flag"

M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom
{if (max_layer_z + 100.0) < 250}
    G1 Z{max_layer_z + 100.0} F600
    G1 Z{max_layer_z +98.0}
{else}
    G1 Z250 F600
    G1 Z248
{endif}

;===== slow heatbed cooldown ====================
; will be performed for the following types of material: ASA, ABS, PA(Nylon), PA-CF(Nylon Carbonfibre)
{if (filament_type[initial_tool]=="ASA") || (filament_type[initial_tool]=="ABS") || (filament_type[initial_tool]=="PA-CF") || (filament_type[initial_tool]=="PA")}
    M140 S90 ;set bed temperature to 90°C
    G4 S90 ; wait 90 seconds
    G4 S90 ; wait 90 seconds
    G4 S90 ; wait 90 seconds
    M190 S80 ;set bed temperature to 80°C
    G4 S90 ; wait 90 seconds
    G4 S90 ; wait 90 seconds
    G4 S90 ; wait 90 seconds
    M190 S70 ;set bed temperature to 70°C
    G4 S90 ; wait 90 seconds
    G4 S90 ; wait 90 seconds
    G4 S90 ; wait 90 seconds
    M190 S60 ;set bed temperature to 60°C
    G4 S90 ; wait 90 seconds
    G4 S90 ; wait 90 seconds
    G4 S90 ; wait 90 seconds
    M190 S55 ;set bed temperature to 55°C
    G4 S90 ; wait 90 seconds
    G4 S90 ; wait 90 seconds
    G4 S90 ; wait 90 seconds
    M190 S50 ;set bed temperature to 50°C
    G4 S90 ; wait 90 seconds
    G4 S90 ; wait 90 seconds
    G4 S90 ; wait 90 seconds
    M190 S45 ;set bed temperature to 45°C
    G4 S90 ; wait 90 seconds
    G4 S90 ; wait 90 seconds
    G4 S90 ; wait 90 seconds
    M190 S40 ;set bed temperature to 40°C
    G4 S90 ; wait 90 seconds
    G4 S90 ; wait 90 seconds
    G4 S90 ; wait 90 seconds
    M140 S0 ; turn off bed
    M106 S0 ; turn off fan
    M106 P2 S0 ; turn off remote part cooling fan
    M106 P3 S0 ; turn off chamber cooling fan
{endif}

M400 P100
M17 R ; restore z current

G90
G1 X128 Y250 F3600

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0

M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
