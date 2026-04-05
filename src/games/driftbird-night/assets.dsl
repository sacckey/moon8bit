# moon8bit asset DSL v1
# sfx-event flap Wing
# sfx-event hit Crash
# sfx-event reset Retry
palette night
color 0 #0b1020
color 1 #1b263b
color 2 #3a5a40
color 3 #f4a261
color 4 #e76f51
color 5 #5c4d7d
color 6 #f1faee
color 7 #7f5af0
end

sprite bird 8 8
........
...33...
..33334.
.3336334
.3353334
..33333.
...33...
........
end

tilemap bg 8 6
0 0 1 0 0 1 0 0
0 0 0 0 0 0 0 0
0 1 0 0 1 0 0 1
0 0 0 0 0 0 0 0
0 0 1 0 0 1 0 0
1 0 0 1 0 0 1 0
end

tilemap ground 8 2
5 5 5 5 5 5 5 5
2 2 2 2 2 2 2 2
end
