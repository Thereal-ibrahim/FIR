"""
Convert FIR filter output.txt (raw Q-format fixed-point integers)
into a playable .wav file.

Usage:
    python output_to_wav.py

Adjust FRAC_BITS below to match your accumulator's fractional bit width
(30 in this project, since inputs/coefficients are Q1.15 and were never
rescaled after multiplication).
"""

import numpy as np
from scipy.io import wavfile

# ---- Settings: change these if your design changes ----
INPUT_FILE   = "output.txt"      # raw integer samples, one per line
OUTPUT_WAV   = "filtered_voice.wav"
SAMPLE_RATE  = 8000               # Hz, matches the filter's design sample rate
FRAC_BITS    = 30                 # fractional bits in the output format (Q?.30)
# ---------------------------------------------------------

def main():
    # Load raw integer samples from the text file
    raw = np.loadtxt(INPUT_FILE)

    # Convert from fixed-point back to real decimal values
    real = raw / (2 ** FRAC_BITS)

    print(f"Loaded {len(real)} samples")
    print(f"Min value: {real.min():.6f}, Max value: {real.max():.6f}")

    # Normalize to avoid clipping when saving as audio
    peak = np.max(np.abs(real))
    if peak == 0:
        raise ValueError("All samples are zero — check your output.txt file")
    normalized = real / peak

    # Convert to 16-bit PCM range
    audio_int16 = np.int16(normalized * 32767)

    # Save as WAV
    wavfile.write(OUTPUT_WAV, SAMPLE_RATE, audio_int16)
    print(f"Saved {OUTPUT_WAV} ({len(audio_int16)/SAMPLE_RATE:.2f} seconds)")


if __name__ == "__main__":
    main()