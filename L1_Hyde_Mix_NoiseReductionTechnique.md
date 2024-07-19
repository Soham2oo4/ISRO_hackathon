## These are your results
After Applying Hyperspectral Mixed Noise Removal By L1-Norm-Based Subspace Representation from this [research paper](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=9040508) we got the following results <br>
<img width="300" alt="image" src="https://github.com/user-attachments/assets/748d9716-95e3-431f-b878-9f7125238948">
<img width="300" alt="image" src="https://github.com/user-attachments/assets/9d8353d6-a2fa-4b44-bba2-97f8b4949a2b"><br>
Manual Mixed noise (Gaussian and Thermal Noise) is added to the original image and then denoised. The above are the results.
## The algorithm for the following is given below
### 1. Observation Model
The observed hyperspectral image 
Y is modeled as: <br>
<img width="80" alt="image" src="https://github.com/user-attachments/assets/c2d5df36-7d7d-46bb-aafd-ecc1605ff528"><br>
where: <br>
X is the true hyperspectral image. <br>
N is the additive mixed noise, including Gaussian noise, impulse noise, and stripes.

