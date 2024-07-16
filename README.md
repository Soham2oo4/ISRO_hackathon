# ISRO_hackathon
**Noise Reduction**
# Method 1: Automatic de-noising of Hyper Spectral images using Shearlet based image noise reduction

## De-noising Methodology Algorithm

### Step 1: Noise Characterisation

1. **Input:** HSI image plane \( Y_k \) for each wavelength \( k \).

2. **Output:** Classification of each image plane as low-level Gaussian noise (LGN) or high-level/mixed noise.
   - Calculate correlation coefficient \( R \) between \( Y_k \) and \( Y_{k+r} \) for neighboring wavelengths \( r \).
       ![image](https://github.com/user-attachments/assets/4bc5dc8b-8a83-4501-8d83-eb7208fd0300)

   - Compute mean correlation \( \overline{R}_k \) using a window \( w_1 \) around \( Y_k \).
      ![image](https://github.com/user-attachments/assets/515652d5-90a5-499f-b1d5-d00de499273e)

   - Median of \( \overline{R}_k \) is used as a threshold to classify as LGN or mixed noise.

## Step 2: Shearlet Transform

1. **Input:** Image planes classified as LGN or mixed noise.

2. **Output:** NSST coefficients for each image plane.
   - Apply Non-Subsampled Shearlet Transform (NSST) to decompose each image plane.
   - Use NSP filter banks for multi-scale decomposition without downsampling.
   - Use NSS filter banks for directional decomposition, iteratively applied for multi-scale and multi-directional decomposition.
      ![image](https://github.com/user-attachments/assets/e725dd8c-c09e-40fc-b24b-9fb80a08d8c3)
      - A and D denote low and high frequency sub-images, respectively.
      - NSP refers to nonsubsampled pyramids.
      - NSS stands for nonsubsampled shearlets.
      - l values represent the sizes of the sub-images at different scales (16, 8, and 4 for scales 1, 2, and 3, respectively).


