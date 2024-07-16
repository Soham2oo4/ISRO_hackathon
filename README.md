# ISRO_hackathon
**Noise Reduction**
# Method 1: Automatic de-noising of Hyper Spectral images using Shearlet based image noise reduction

## De-noising Methodology Algorithm

### Step 1: Noise Characterisation

1. **Input:** HSI image plane \( Y_k \) for each wavelength \( k \).

2. **Output:** Classification of each image plane as low-level Gaussian noise (LGN) or high-level/mixed noise.
   - Calculate correlation coefficient \( R \) between \( Y_k \) and \( Y_{k+r} \) for neighboring wavelengths \( r \).
   - Compute mean correlation \( \overline{R}_k \) using a window \( w_1 \) around \( Y_k \).
   - Median of \( \overline{R}_k \) is used as a threshold to classify as LGN or mixed noise.

## Step 2: Shearlet Transform

1. **Input:** Image planes classified as LGN or mixed noise.

2. **Output:** NSST coefficients for each image plane.
   - Apply Non-Subsampled Shearlet Transform (NSST) to decompose each image plane.
   - Use NSP filter banks for multi-scale decomposition without downsampling.
   - Use NSS filter banks for directional decomposition, iteratively applied for multi-scale and multi-directional decomposition.
