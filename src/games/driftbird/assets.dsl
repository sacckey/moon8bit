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
step_sec 0.125
loop true
notes C4 E4 G4 E4 C4 E4 G4 R
end

sprite bird 8 8
........
..3334..
.333334.
333663..
.333334.
..33....
...1....
........
end

tilemap bg 8 6
0 0 0 0 0 0 0 0
0 0 1 0 0 1 0 0
0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0
1 0 0 1 0 0 1 0
end

tilemap ground 8 2
5 5 5 5 5 5 5 5
3 3 3 3 3 3 3 3
end
