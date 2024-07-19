

clear;clc;close all;

case_num = 1; %1:4
dataset ='Chand';%'DC'; 
% %--------------------------
%case_num = 1;  
%dataset ='DC';  
% %--------------------------




 
addpath("D:\MatlabDemo_L1HyMixDe_20200414\L1HyMixDe");
addpath('dataset');
    switch case_num
                   
        case 1  % non i.i.d. Guassian noise 
             k_subspace = 8;
            k = 233;
            stripes = 0;
            impulse = 0;
            stripe_band_num = 60; % the number of band to add stripes. DC -> 60       Pavia -> 30
            impluse_ratio = 0.1; 
            noise_simulation_Gaussian;   % use the script to simulate the synthetic noise
        case 2  % non i.i.d. Guassian noise + stripes
            k_subspace = 8;
            k = 233;
            stripes = 1;
            impulse = 0;
            stripe_band_num = 60; % the number of band to add stripes. DC -> 60       Pavia -> 30
            impluse_ratio = 0.1;
            noise_simulation_Gaussian;   % use the script to simulate the synthetic noise
      case 3  % non i.i.d. Guassian noise + salt&pepper noise
           k_subspace = 8;
            k = 233;
            stripes = 0;
            impulse = 1;
            stripe_band_num = 60; % the number of band to add stripes. DC -> 60       Pavia -> 30
            impluse_ratio = 0.005;
            noise_simulation_Gaussian;   % use the script to simulate the synthetic noise
        case 4  % non i.i.d. Guassian noise + stripes + salt&pepper noise
             k_subspace = 8;
            k = 233;
            stripes = 1;
            impulse = 1;
            stripe_band_num = 60; % the number of band to add stripes. DC -> 60       Pavia -> 30
            impluse_ratio = 0.005;
            noise_simulation_Gaussian;   % use the script to simulate the synthetic noise
        
    end
    
    
    %% compute the quantitive assement indexes of the noisy HSI
    num = 1;
    disp('*********************** noisy ************************');
    [MPSNR(num),PSNRV(:,num),MSSIM(num),SSIMV(:,num),MFSIM(num),FSIMV(:,num) ] = QuanAsse_psnr_ssim_fsim(img_clean,img_noisy);
    
    
    
    %%  HSI denoising by L1HyMixDe method
    num = 2;
    tStart = tic;
    k_subspace = 5;
    p = 0.1;
    img_L1HyMixDe = L1HyMixDe(img_noisy, k_subspace, p);
    time_L1HyMixDe = toc(tStart);
    disp('*********************** L1HyMixDe ************************');
    [MPSNR(num),PSNRV(:,num),MSSIM(num),SSIMV(:,num),MFSIM(num),FSIMV(:,num) ] = QuanAsse_psnr_ssim_fsim(img_clean,img_L1HyMixDe);
    

 
%%%%%%%%%%%%%%%%  show original and reconstructed data   %%%%%%%%%%%
exist band2 var; %The variable band2 exists only when stripe noise is simulated.
if ans
    b_show = band2(1);
else
    b_show = 75;
end
figure;
max_v = max(max(img_clean(:,:,b_show)));
min_v = min(min(img_clean(:,:,b_show)));
subplot(1,3,1);
imagesc(img_clean(:,:,b_show),[min_v, max_v]);
title(['Clean band #',num2str(b_show)]);
subplot(1,3,2);
imagesc(img_noisy(:,:,b_show),[min_v, max_v]);
title({['Noisy band #',num2str(b_show)]; ['PSNR: ', num2str(MPSNR(1)),'dB']});
subplot(1,3,3);
imagesc(img_L1HyMixDe(:,:,b_show),[min_v, max_v]);
title({['Denoised band #',num2str(b_show), 'by L1HyMixDe']; ['PSNR: ', num2str(MPSNR(2)),'dB']});




 