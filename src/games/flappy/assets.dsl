# moon8bit asset DSL v1
palette dawn
color 0 #0f1a20
color 1 #274060
color 2 #2e8b57
color 3 #f2aa4c
color 4 #e94f37
color 5 #8f6f4f
color 6 #f6f7eb
color 7 #7f5af0
color 8 #264653
color 9 #2a9d8f
color 10 #e9c46a
color 11 #f4a261
color 12 #e76f51
color 13 #577590
color 14 #90be6d
color 15 #ffffff
end

sound flap
wave square
attack 0.003
decay 0.10
volume 0.07
f0 520
f1 360
end

sound hit
wave triangle
attack 0.002
decay 0.16
volume 0.09
f0 300
f1 110
end

sound reset
wave sine
attack 0.003
decay 0.12
volume 0.08
f0 240
f1 420
end

bgm main
wave square
volume 0.04
step_sec 0.15
loop true
notes A5 A5 G5 F5 F5 E5 D5 D5 E5 F5 F5 G5 A5 A#5 R A#5 D6 R D6 A5 ~ ~ R A5 A5 G5 F5 F5 E5 D5 C5 D5 E5 F5 G5 A5 C6 R A#5 G5 R C6 F5 ~ ~ F6 R R
end

sprite bird 8 8
...000..
..03330.
.0330340
.0333300
0033330.
0333330.
.03330..
..0000..
end

# tile IDs are explicit (0..255)
tile 0 ground_surface solid
55555555
55555555
55555555
55555555
33333333
33333333
33333333
33333333
end

# tile IDs: .=transparent, 0=ground_surface
tilemap stage 16 16
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . .
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
end
