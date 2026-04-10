# moon8bit asset DSL v1
palette space
color 0 #000010
color 1 #0a0a2a
color 2 #4444cc
color 3 #cc4444
color 4 #44cc44
color 5 #cccc44
color 6 #f0f0f0
color 7 #cc44cc
end

sound shoot
wave square
attack 0.001
decay 0.06
volume 0.06
f0 900
f1 420
end

sound hit
wave triangle
attack 0.002
decay 0.09
volume 0.07
f0 520
f1 260
end

sound die
wave sawtooth
attack 0.003
decay 0.18
volume 0.09
f0 280
f1 80
end

sprite player 8 8
...66...
...66...
..6666..
..6666..
.666666.
.6.66.6.
........
........
end

sprite enemy 8 8
........
.3.33.3.
.333333.
..3333..
..3333..
...33...
...33...
........
end
