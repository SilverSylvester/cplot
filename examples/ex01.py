import time
import math
import itertools

for x in itertools.count():
    print('chart:', x / 50, math.sin(x / 50), flush=True)
    time.sleep(0.01)

# python ex01.py | cplot -c 'chart sin line'
