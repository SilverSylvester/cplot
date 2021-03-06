import wave
import numpy as np
import time

spf = wave.open('example.wav', 'r')  # give it any .wav file
signal = np.fromstring(spf.readframes(-1), 'Int16')

channels = [[] for channel in range(spf.getnchannels())]
for index, datum in enumerate(signal):
    channels[index % len(channels)].append(datum)

fs = spf.getframerate()
Time = np.linspace(0, len(signal) / len(channels) / fs,
                   num=len(signal) / len(channels))


wave_points = zip(Time, channels[0][:10000000])
for t, c in wave_points:
    print('chart:', t, c, flush=True)
    time.sleep(0.0001)

# python ex02.py | cplot -c 'chart wav line'
