
 
 rng('default') 
%% load the clean data
addpath('D:\MatlabDemo_L1HyMixDe_20200414');
switch dataset
    case 'Chand'
        load ch2_iir_nci_20240131T2241351052_d_img_d18.mat
        img_clean = all_bands ; clear all_bands
        
end

%data normalization
img_clean(img_clean<0) = 0;
img_clean  = img_clean/max(img_clean(:));
 

[M,N,B] = size(img_clean);
W1_GT = ones(size(img_clean));  
%When the elements in the noisy image is only corrupted by Gaussian noise 
%(not other kinds of noise, the corresponding elements in matrix W1_GT have
%one-value. 
%Matrix W1_GT indicates the locations of stripes and impulse noise.

%% Gaussian noise
    rng(k);k = k+1;
    switch dataset
        case 'DC'
            sigma = 0.01*rand(1,B);
        case  'Pavia'
            sigma = 0.04*rand(1,B);
        case 'Chand'
            sigma = 0.01 * rand(1,B);
              
           
               
    end
    rng(k);k = k+1;
    noise = randn(size(img_clean));
    for cb=1:B
        noise(:,:,cb) = sigma(cb)*noise(:,:,cb);
    end
 

%% Add noise to the clean image
img_noisy = img_clean + noise;

 
%% simulate diagonal stripes
if stripes
     rng(k);  k = k+1;
    b_idx_rand = randperm(B);
    band2 = b_idx_rand(1:stripe_band_num);
    rng(k); k = k+1;
    stripnum2 = 5+ceil(10*rand(1,length(band2))); 
   
    for i  = 1:length(band2)
        for no_stripes=1:stripnum2(i)
            rng(k);     k = k+1;
            idx_start_r = randi(M);
            idx_start_c = 1;%randi(N);
            t = 0;
            rng(k);     k = k+1;
            signt = sign(rand(1)-0.5);
            for ir=idx_start_r:M
                t=t+1;
                if idx_start_c+t<N
                    rng(k);     k = k+1;
                    t1 =  signt*(rand(size(img_noisy(ir,idx_start_c+t,band2(i))))*0.2+0.5);
                    img_noisy(ir,idx_start_c+t,band2(i)) = 1;
                    W1_GT(ir,idx_start_c+t,band2(i)) = 0;
                end
            end
        end
        %               simulate a wider stripe:
        t = 0;
        rng(k);     k = k+1;
        idx_start_r = randi(M);
        rng(k);     k = k+1;
        signt = sign(rand(1)-0.5);
        for ir=idx_start_r:M
            t=t+1;
            if idx_start_c+t<N
                rng(k);     k = k+1;
                t1 = signt*(rand(size(img_noisy(ir,(idx_start_c+t):min(idx_start_c+t+4,N),band2(i))))* 0.2+0.5);
                img_noisy(ir,(idx_start_c+t):min(idx_start_c+t+4,N),band2(i)) =  1;
                W1_GT(ir,(idx_start_c+t):min(idx_start_c+t+4,N),band2(i)) = 0;
            end
        end
        
        
        for no_stripes=1:fix(stripnum2(i)/2)
            rng(k);     k = k+1;
            
            idx_start_c =  randi(N);
            idx_start_r = 1;
            t = 0;
            rng(k);     k = k+1;
            signt = sign(rand(1)-0.5);
            for ic=idx_start_c:N
                t=t+1;
                if idx_start_r+t<M
                    rng(k);     k = k+1;
                    t1 =  signt*(rand(size(img_noisy(idx_start_r+t,ic,band2(i))))*0.2+0.5);
                    img_noisy(idx_start_r+t,ic,band2(i)) = 1;
                    W1_GT(idx_start_r+t,ic,band2(i)) = 0;
                end
            end
        end
        
    end    
end

%% simulate impulse
if impulse
    a1 = 0.5*ones(size(img_noisy));
    rng(k);     k = k+1;
    anoisy = imnoise(a1,'salt & pepper',impluse_ratio);
    W1_GT(anoisy~=0.5) = 0;
    rng(k);     k = k+1;
    a2 = sign(rand(size(img_noisy(anoisy~=0.5)))-0.5);
    a2(a2<-0.5)=-0.5;
    img_noisy(anoisy~=0.5) = a2.*ones(size(img_noisy(anoisy~=0.5)));
end

 
%% calculate the ground truth stadard diveration of the Gaussian noise
clear sigma1_gt;
noise = img_noisy - img_clean;
for i = 1:B
    temp = noise(:,:,i);
    w1 = W1_GT(:,:,i);
    temp = temp(logical(w1));
    sigma1_gt(i) = std(temp);
end
