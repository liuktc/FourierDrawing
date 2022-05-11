import matplotlib.pyplot as plt
import numpy as np
from scipy.fft import fft, fftfreq
import svg

SAMPLE_FROM_IMAGE = True
ImagePath = "SampleImages/earth.svg"
OutputFileName = "output.txt"
samples = []
num_samples = 2000
sampling_frequency = 2000
function_period = 2 * np.pi


# If SAMPLE_FROM_IMAGE is False it samples the function f(t)
def f(t):
    # return np.cos(3*t) + 1j * np.sin(t)
    return np.cos(t / 2) * np.sin(8 * t) * np.exp(1j * t)
    # return interpolator_complex(t)


fig, ax = plt.subplots()

if SAMPLE_FROM_IMAGE:
    samples = svg.getpoints(ImagePath, num_samples)
else:
    for i in range(num_samples):
        # The time elapsed at the i-th sample is i*T -> 1/f
        t = function_period * i / sampling_frequency
        samples.append(f(t))

# extract real part
x_p = [ele.real for ele in samples]
# extract imaginary part
y_p = [ele.imag for ele in samples]

# plot the complex numbers
plt.scatter(x_p, y_p)
plt.ylabel('Imaginary')
plt.xlabel('Real')
plt.show()

fig.savefig("Samples in complex plane.png")

# Calculating the fft and the corresponding frequencies
fourier_transform = fft(samples)
fourier_frequencies = fftfreq(num_samples, 1 / sampling_frequency)

fig, ax = plt.subplots()

ax.plot(fourier_frequencies, np.abs(fourier_transform))

fig.savefig("Fourier Transform.png")

# Calculating the maximum abs value of the fft values to normalize them
max_abs = 0
for i in fourier_transform:
    if np.abs(i) > max_abs:
        max_abs = np.abs(i)

# Writing the data to the output file
f = open(OutputFileName, "w")
for i in range(num_samples):
    omega = str(fourier_frequencies[i])
    mod = str(np.abs(fourier_transform[i]) / max_abs) # Dividing by max_abs to normalize the values
    phase = str(np.angle(fourier_transform[i]))
    f.write(omega + ";" + mod + ";" + phase + "\n")
