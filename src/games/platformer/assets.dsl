# moon8bit asset DSL v1
palette platformer
color 0 #2f2a3a
color 1 #4a7abf
color 2 #73c6f5
color 3 #f2c14e
color 4 #f78154
color 5 #87c38f
color 6 #f7f7ff
color 7 #7a5cff
color 8 #264653
color 9 #2a9d8f
color 10 #e9c46a
color 11 #f4a261
color 12 #e76f51
color 13 #577590
color 14 #90be6d
color 15 #ffffff
end

sound jump
wave square
attack 0.003
decay 0.12
volume 0.07
f0 420
f1 580
end

sound hit
wave triangle
attack 0.003
decay 0.16
volume 0.08
f0 280
f1 120
end

sound goal
wave sawtooth
attack 0.002
decay 0.18
volume 0.08
f0 520
f1 760
end

bgm main
wave square
volume 0.03
step_sec 0.125
loop true
notes A5 A5 G5 F5 F5 E5 D5 D5 E5 F5 F5 G5 A5 A#5 R A#5 D6 R D6 A5 ~ ~ R A5 A5 G5 F5 F5 E5 D5 C5 D5 E5 F5 G5 A5 C6 R A#5 G5 R C6 F5 ~ ~ F6 R R
end

sprite player 8 8
........
..666...
.663366.
.666666.
.666666.
.644446.
..4..4..
........
end

sprite enemy 8 8
........
..444...
.446644.
.466664.
.466664.
..4444..
..4..4..
........
end

sprite coin 8 8
...330..
..36630.
.3633030
.3633030
.3633030
.3633030
..30030.
...330..
end

# tile IDs are explicit (0..255)
tile 0 ground_top solid
55555555
55555555
55555555
55555555
33333333
33333333
33333333
33333333
end

tile 1 ground_fill solid
33333333
33333333
33333333
33333333
33333333
33333333
33333333
33333333
end

tile 2 platform solid
aaaaaaaa
33333333
33333333
33333333
bbbbbbbb
bbbbbbbb
bbbbbbbb
44444444
end

tile 3 crate solid
44444444
46666664
46666664
46666664
46666664
46666664
46666664
44444444
end

tile 4 goal
...77...
..7777..
.777777.
77777777
77777777
.777777.
..7777..
...77...
end

# tile IDs: .=transparent, 0=ground_top, 1=ground_fill, 2=platform, 3=crate, 4=goal
tilemap stage 48 18
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . 2 2 2 2 2 2 . . . . . 2 2 2 2 2 2 . . . . . 2 2 2 2 2 2 . . . . . 2 2 2 2 2 2 . . .
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . 2 2 2 2 2 . . . . . . . . 2 2 2 2 2 2 . . . . . 2 2 2 2 . . . . . . . . .
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . . . 2 2 2 2 2 2 . . . . . . . 2 2 2 2 2 2 . . . . . . . . . . .
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . . 3 . . . . . . . . . . . . 3 . . . . . . . . . 3 . . . . 4 . .
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
end

place enemy_1 enemy 80 120
place enemy_2 enemy 184 120
place enemy_3 enemy 248 120
place enemy_4 enemy 328 120
place coin_1 coin 96 104
place coin_2 coin 144 80
place coin_3 coin 216 104
place coin_4 coin 272 56
place coin_5 coin 360 104
