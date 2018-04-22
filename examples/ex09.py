import time
import random

# simulate the value of the sum of three dice rolls (needs 16 bins)


def roll(num_sides):
    return random.randint(1, num_sides)


while True:
    r1, r2, r3 = roll(6), roll(6), roll(6)
    print('SumOfThreeDice:', r1 + r2 + r3, flush=True)
    time.sleep(0.001)

# python ex09.py | cplot -c 'SumOfThreeDice value histogram'
