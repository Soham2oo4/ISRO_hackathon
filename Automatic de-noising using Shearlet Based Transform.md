# ISRO_hackathon
# **Noise Reduction**
## Method 1: Automatic de-noising of Hyper Spectral images using Shearlet based image noise reduction

### De-noising Methodology Algorithm

#### Step 1: Noise Characterisation

1. **Input:** HSI image plane \( Y_k \) for each wavelength \( k \).

2. **Output:** Classification of each image plane as low-level Gaussian noise (LGN) or high-level/mixed noise.
   - Calculate correlation coefficient \( R \) between \( Y_k \) and \( Y_{k+r} \) for neighboring wavelengths \( r \).
       ![image](https://github.com/user-attachments/assets/4bc5dc8b-8a83-4501-8d83-eb7208fd0300)

   - Compute mean correlation \( \overline{R}_k \) using a window \( w_1 \) around \( Y_k \). <br>
      ![image](https://github.com/user-attachments/assets/515652d5-90a5-499f-b1d5-d00de499273e)

   - Median of \( \overline{R}_k \) is used as a threshold to classify as LGN or mixed noise.

     ##### Output of Step 1
     <img width="258" alt="image" src="https://github.com/user-attachments/assets/c45eaffa-1d3e-4ad8-8949-7830eb659d15"><br>
     .<br>
     .<br>
     .<br>
     .<br>
     <img width="258" alt="image" src="https://github.com/user-attachments/assets/164e9600-257d-419c-acfd-d8bdcf0458dc"><br>
     #### The correlation Graph looks like this<br>
      <img width="300" alt="image" src="https://github.com/user-attachments/assets/90701137-74b5-46ca-9ef5-d6ec116d848e">

### Step 2: Shearlet Transform

1. **Input:** Image planes classified as LGN or mixed noise.

2. **Output:** NSST coefficients for each image plane.
   - Apply Non-Subsampled Shearlet Transform (NSST) to decompose each image plane.
   - Use NSP filter banks for multi-scale decomposition without downsampling.
   - Use NSS filter banks for directional decomposition, iteratively applied for multi-scale and multi-directional decomposition.
     ### <img src="https://github.com/user-attachments/assets/e725dd8c-c09e-40fc-b24b-9fb80a08d8c3" alt="image" width="300">

      - A and D denote low and high frequency sub-images, respectively.
      - NSP refers to nonsubsampled pyramids.
      - NSS stands for nonsubsampled shearlets.
      - l values represent the sizes of the sub-images at different scales (16, 8, and 4 for scales 1, 2, and 3, respectively).

### Step 3: De-noising Image Planes

1. Input
NSST coefficients for each image plane.

2. Output
De-noised image planes.

- Apply thresholding to NSST coefficients to distinguish noise from signal.
- For LGN image planes:
  - Use BayesShrink method to determine threshold \( T_{s,t} \). <br>
  ![image](https://github.com/user-attachments/assets/affda977-f273-4182-b303-4d207b23e2df) <br>
  -The standard deviation (σs t, ) of the signal measured from the sub-image Ys,t at scale s and direction t is estimated as <br>
  ![image](https://github.com/user-attachments/assets/7cf83ab6-3f17-4af1-9f33-ee8d78ba3400)


- For mixed noise image planes:
  - Fuse shearlet coefficients from adjacent LGN image planes.
  - Weighted average of coefficients based on proximity.
- Reconstruct de-noised image planes using inverse NSST.

### Final Output
- De-noised HSI image planes ready for further classification and analysis.



