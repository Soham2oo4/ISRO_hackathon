## These are your results
After Applying Hyperspectral Mixed Noise Removal By L1-Norm-Based Subspace Representation from this [research paper](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=9040508) we got the following **results** <br><br>
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

Estimate the coarse image &#x3C9; by replacing values affected by impulse noise and stripes with median-filtered values:
ω<sub>ij</sub> =
if (y<sub>ij</sub> - y<sub>med,ij</sub>)<sup>2</sup> < th then
y<sub>ij</sub>
else
y<sub>med,ij</sub>
where:
- `th` is a threshold computed as:<br>
th = sort(Y - Y<sub>med</sub>, p)


Here, `sort(X, p)` returns the ⌊n<sub>b</sub> × n × p⌋ -th largest value in `X`, with `p` being the percentage of pixels suspected to be affected by impulse noise and stripes.

### 3.3 Noise Whitening

To handle non-i.i.d. Gaussian noise, whiten the noise in the coarse image &#x3C9; and observed image `Y`:
ω = C<sub>λ</sub><sup>-1</sup> ω
Y = C<sub>λ</sub><sup>-1</sup> Y

where C<sub>&#x3bb;</sub> is the noise covariance matrix, and C<sub>&#x3bb;</sub><sup>-1</sup> is its inverse.

## 4. Cost Function

Estimate `Z` by minimizing the following cost function:
Z* = argmin<sub>Z</sub> ||Y - EZ||<sub>1,1</sub> + λφ(Z)


where:
- ||·||<sub>1,1</sub> denotes the entry-wise L<sub>1</sub>-norm.
- &#x3c6;(Z) is a regularization term.

## 5. Algorithm: Alternating Direction Method of Multipliers (ADMM)

The optimization problem is transformed into a constrained form:
min<sub>Z, V</sub> ||V||<sub>1,1</sub> + λφ(Z)
subject to: Y - EZ = V


The augmented Lagrangian function is:
L(Z, V, D) = ||V||<sub>1,1</sub> + λφ(Z) + (μ/2) ||Y - EZ - V + (1/μ) D||<sub>F</sub><sup>2</sup>


where &#x3bc; > 0 is the ADMM penalty parameter.

The ADMM algorithm proceeds with the following steps:

1. Initialize `t = 0`, choose &#x3bc; > 0, V<sub>0</sub>, D<sub>0</sub>.
2. Repeat until convergence:
   - Update Z:

     
     Z<sub>t+1</sub> = argmin<sub>Z</sub> &#x3bb;&#x3c6;(Z) + (&#x3bc;/2) ||Y - EZ - V<sub>t</sub> + (1/&#x3bc;) D<sub>t</sub>||<sub>F</sub><sup>2</sup>
     

   - Update V:

     
     V<sub>t+1</sub> = argmin<sub>V</sub> ||V||<sub>1,1</sub> + (&#x3bc;/2) ||Y - EZ<sub>t+1</sub> - V + (1/&#x3bc;) D<sub>t</sub>||<sub>F</sub><sup>2</sup>
     

   - Update D:

     D<sub>t+1</sub> = D<sub>t</sub> + &#x3bc;(Y - EZ<sub>t+1</sub> - V<sub>t+1</sub>)

3. Increment `t`.

After obtaining `Z*`, estimate the denoised image:
X* = EZ*
Convert back to the original image space:
X* = ΠC<sub>λ</sub>X*

## Summary

The algorithm involves:
1. **Preprocessing** to handle mixed noise.
2. **Whitening** to manage non-i.i.d. Gaussian noise.
3. **Optimization** using ADMM to estimate the subspace coefficients \(Z\).
4. **Restoration** of the hyperspectral image from the estimated coefficients.









