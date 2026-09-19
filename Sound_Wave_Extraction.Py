import numpy as np
from scipy.io import wavfile
from scipy.signal import resample

# Read your wav file
fs, x = wavfile.read('Human_and_7kHz.wav')

# Convert to mono if stereo
if x.ndim > 1:
    x = x.mean(axis=1)

# Resample to 8000 Hz
num_samples = int(len(x) * 8000 / fs)
x = resample(x, num_samples)

# Normalize and convert to Q1.15
x_fixed = np.round(x / np.max(np.abs(x)) * 32767).astype(int)

# Save to text file
np.savetxt('input.txt', x_fixed, fmt='%d')
print(f"Done! {len(x_fixed)} samples saved to input.txt")