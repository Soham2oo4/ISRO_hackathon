## These are your results
After Applying Hyperspectral Mixed Noise Removal By L1-Norm-Based Subspace Representation from this [research paper](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=9040508) we got the following results <br>
<img width="300" alt="image" src="https://github.com/user-attachments/assets/748d9716-95e3-431f-b878-9f7125238948">
<img width="300" alt="image" src="https://github.com/user-attachments/assets/9d8353d6-a2fa-4b44-bba2-97f8b4949a2b"><br>
Manual Mixed noise (Gaussian and Thermal Noise) is added to the original image and then denoised. The above are the results.
## The algorithm for the following is given below
# Hyperspectral Image Restoration Algorithm

## 1. Observation Model

The observed hyperspectral image `Y` is modeled as:<br>
<img width="67" alt="image" src="https://github.com/user-attachments/assets/ce4753d2-ccfc-4678-aeeb-0aa9651832cf"><br>

where:
- `X` is the true hyperspectral image.
- `N` is the additive mixed noise, including Gaussian noise, impulse noise, and stripes.

## 2. Subspace Representation

HSI data are assumed to lie in a lower-dimensional subspace S<sub>k</sub> with dimension `k` (where k << n<sub>b</sub>). Represent `X` in this subspace:<br>
<img width="67" alt="image" src="https://github.com/user-attachments/assets/feb4763f-6088-4633-a3f1-58fb4ebc5307"><br>

where:
- `E` ∈ ℝ<sup>n<sub>b</sub> × k</sup> contains the basis vectors for S<sub>k</sub>.
- `Z` ∈ ℝ<sup>k × n</sup> holds the representation coefficients.

Assuming `E` is semiunitary: E<sup>T</sup>E = I<sub>k</sub>.

## 3. Subspace Learning Against Mixed Noise
### 3.1 Median Filtering

To remove impulse noise and stripes, apply an adaptive median filter to `Y`:
Y<sub>med</sub> = med(Y)

where `med(·)` denotes the median filtering operation applied to each spectral band.

### 3.2 Coarse Image Estimation

Estimate the coarse image `&#x3C9;` by replacing values affected by impulse noise and stripes with median-filtered values:
ω<sub>ij</sub> =
if (y<sub>ij</sub> - y<sub>med,ij</sub>)<sup>2</sup> < th then
y<sub>ij</sub>
else
y<sub>med,ij</sub>
where:
- `th` is a threshold computed as:<br>
th = sort(Y - Y<sub>med</sub>, p)


Here, `sort(X, p)` returns the `⌊n<sub>b</sub> × n × p⌋`-th largest value in `X`, with `p` being the percentage of pixels suspected to be affected by impulse noise and stripes.

### 3.3 Noise Whitening

To handle non-i.i.d. Gaussian noise, whiten the noise in the coarse image `&#x3C9;` and observed image `Y`:





