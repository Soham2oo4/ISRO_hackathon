## These are your results
After Applying Hyperspectral Mixed Noise Removal By L1-Norm-Based Subspace Representation from this [research paper](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=9040508) we got the following results <br>
<img width="300" alt="image" src="https://github.com/user-attachments/assets/748d9716-95e3-431f-b878-9f7125238948">
<img width="300" alt="image" src="https://github.com/user-attachments/assets/9d8353d6-a2fa-4b44-bba2-97f8b4949a2b"><br>
Manual Mixed noise (Gaussian and Thermal Noise) is added to the original image and then denoised. The above are the results.
## The algorithm for the following is given below
# Hyperspectral Image Restoration Algorithm

# Hyperspectral Image Restoration Algorithm

## 1. Observation Model

The observed hyperspectral image `Y` is modeled as:<br>
<img width="67" alt="image" src="https://github.com/user-attachments/assets/ce4753d2-ccfc-4678-aeeb-0aa9651832cf"><br>

where:
- `X` is the true hyperspectral image.
- `N` is the additive mixed noise, including Gaussian noise, impulse noise, and stripes.

## 2. Subspace Representation

HSI data are assumed to lie in a lower-dimensional subspace S<sub>k</sub> with dimension `k` (where `k << n<sub>b</sub>`). Represent `X` in this subspace:<br>
<img width="67" alt="image" src="https://github.com/user-attachments/assets/feb4763f-6088-4633-a3f1-58fb4ebc5307"><br>

where:
- `E` ∈ ℝ<sup>n<sub>b</sub> × k</sup> contains the basis vectors for S<sub>k</sub>.
- `Z` ∈ ℝ<sup>k × n</sup> holds the representation coefficients.

Assuming `E` is semiunitary: `E<sup>T</sup>E = I<sub>k</sub>`.

## 3. Subspace Learning Against Mixed Noise

### 3.1 Median Filtering

To remove impulse noise and stripes, apply an adaptive median filter to `Y`:




## 2. Subspace Representation

HSI data are assumed to lie in a lower-dimensional subspace \(S_k\) with dimension \(k\) (where \(k \ll n_b\)). Represent \(X\) in this subspace:

\[ X = E Z \]

where:
- \(E \in \mathbb{R}^{n_b \times k}\) contains the basis vectors for \(S_k\).
- \(Z \in \mathbb{R}^{k \times n}\) holds the representation coefficients.

Assuming \(E\) is semiunitary: \(E^T E = I_k\).

## 3. Subspace Learning Against Mixed Noise

### 3.1 Median Filtering

To remove impulse noise and stripes, apply an adaptive median filter to \(Y\):

\[ Y_{med} = \text{med}(Y) \]

where \(\text{med}(\cdot)\) denotes the median filtering operation applied to each spectral band.

### 3.2 Coarse Image Estimation

Estimate the coarse image \(\tilde{Y}\) by replacing values affected by impulse noise and stripes with median-filtered values:

\[
\tilde{y}_{ij} =
\begin{cases}
y_{ij} & \text{if } (y_{ij} - y_{med,ij})^2 < \text{th} \\
y_{med,ij} & \text{otherwise}
\end{cases}
\]

where:
- \(\text{th}\) is a threshold computed as:

\[ \text{th} = \text{sort}(Y - Y_{med}, p) \]

Here, \(\text{sort}(X, p)\) returns the \(\lfloor n_b \times n \times p \rfloor\)-th largest value in \(X\), with \(p\) being the percentage of pixels suspected to be affected by impulse noise and stripes.

### 3.3 Noise Whitening

To handle non-i.i.d. Gaussian noise, whiten the noise in the coarse image \(\tilde{Y}\) and observed image \(Y\):

\[
\tilde{Y} = C_{\lambda}^{-1} \tilde{Y}
\]
\[
Y = C_{\lambda}^{-1} Y
\]

where \(C_{\lambda}\) is the noise covariance matrix, and \(C_{\lambda}^{-1}\) is its inverse.

## 4. Cost Function

Estimate \(Z\) by minimizing the following cost function:

\[
Z^* = \arg \min_Z \|Y - EZ\|_{1,1} + \lambda \phi(Z)
\]

where:
- \(\|\cdot\|_{1,1}\) denotes the entry-wise \(L_1\)-norm.
- \(\phi(Z)\) is a regularization term.

## 5. Algorithm: Alternating Direction Method of Multipliers (ADMM)

The optimization problem is transformed into a constrained form:

\[
\min_{Z, V} \|V\|_{1,1} + \lambda \phi(Z)
\]
\[
\text{s.t. } Y - EZ = V
\]

### 5.1 Augmented Lagrangian Function

The augmented Lagrangian function is:

\[
L(Z, V, D) = \|V\|_{1,1} + \lambda \phi(Z) + \frac{\mu}{2} \|Y - EZ - V + \frac{1}{\mu}D\|_F^2
\]

where \(\mu\) is the penalty parameter and \(D\) is the dual variable.

### 5.2 Update Rules

1. **Update \(Z\)**:

\[
Z^{t+1} = \arg \min_Z \lambda \phi(Z) + \frac{\mu}{2} \|E^T (Y - V^t + \frac{1}{\mu}D^t) - Z\|_F^2
\]

2. **Update \(V\)**:

\[
V^{t+1} = \arg \min_V \|V\|_{1,1} + \frac{\mu}{2} \|Y - EZ^{t+1} - V + \frac{1}{\mu}D^t\|_F^2
\]

3. **Update \(D\)**:

\[
D^{t+1} = D^t + \frac{1}{\mu}(Y - EZ^{t+1} - V^{t+1})
\]

### 5.3 Soft-Thresholding

The update for \(V\) involves soft-thresholding:

\[
\Psi_{\lambda \|\cdot\|_{1,1}}(U) = \text{soft}(U, \lambda)
\]

where:

\[
\text{soft}(x, \lambda) = \text{sign}(x) \max(|x| - \lambda, 0)
\]

## 6. Restoration

After obtaining \(Z^*\), restore the hyperspectral image \(X^*\) as:

\[
X^* = E Z^*
\]

Finally, revert the noise whitening:

\[
X^* = \sqrt{C_{\lambda}} X^*
\]

## Summary

The algorithm involves:
1. **Preprocessing** to handle mixed noise.
2. **Whitening** to manage non-i.i.d. Gaussian noise.
3. **Optimization** using ADMM to estimate the subspace coefficients \(Z\).
4. **Restoration** of the hyperspectral image from the estimated coefficients.

The complexity of the algorithm is \(O((kn_b + \zeta_1) \zeta_2)\), where \(\zeta_1\) is the complexity of the denoiser and \(\zeta_2\) is the number of iterations.
