
% Define the function
function img_denoised = L1HyMixDe1(img_ori, k_subspace, p)
    % Input: ------------------------------------------------------------
    % img_ori        hyperspectral data set of size (row x column x band)
    % k_subspace     signal subspace dimension
    % p              the percentage of elements corrupted by impulse noise and
    %                stripes (default value is 5%)
    % Output: ------------------------------------------------------------
    % img_denoised Denoised hyperspectral data with (row x column x band)
    % ---------------------------------------------------------------------

    [row, column, band] = size(img_ori);
    N = row * column;
    Y_ori = reshape(img_ori, N, band)';

    % Subspace Learning Against Mixed Noise
    for ib = 1:band
        img_median(:, :, ib) = adpmedian(img_ori(:, :, ib), 21);
    end
    Y_median = reshape(img_median, N, band)';

    % Detect pixel indexes of impulse noise and stripes
    img_dif = abs(img_ori - img_median);
    mask_outlier = (img_dif > p);
    img_remove_outlier = img_ori;
    img_remove_outlier(mask_outlier) = img_median(mask_outlier);
    Y_remove_outlier = reshape(img_remove_outlier, N, band)';

    % Check for NaNs after noise removal
    if any(isnan(Y_remove_outlier(:)))
        error('NaNs found in Y_remove_outlier');
    end

    [w, Rw] = estNoise(Y_remove_outlier, 'additive');
    Rw_ori = Rw;
    disp(Rw_ori)
    % Check for NaNs in noise estimation
    if any(isnan(Rw(:)))
        error('NaNs found in Rw');
    end

    % Data whitening so that noise variances of each band are the same
    Y_ori = inv(sqrt(Rw)) * Y_ori;
    img_ori = reshape(Y_ori', row, column, band);
    Y_median = inv(sqrt(Rw)) * Y_median;
    img_median = reshape(Y_median', row, column, band);
    Y_remove_outlier = inv(sqrt(Rw)) * Y_remove_outlier;

    % Check for NaNs after data whitening
    if any(isnan(Y_ori(:))) || any(isnan(Y_median(:))) || any(isnan(Y_remove_outlier(:)))
        error('NaNs found after data whitening');
    end

    % Subspace learning from the coarse image without stripes and impulse noise
    [E, S, ~] = svd(Y_remove_outlier * Y_remove_outlier' / N);
    E = E(:, 1:k_subspace);

    % Check for NaNs in subspace learning
    if any(isnan(E(:)))
        error('NaNs found in subspace learning matrix E');
    end
    
    % L1HyMixDe
    % Initialization
    Z = E' * Y_median;
    img_dif = img_ori - img_median;
    V = reshape(img_dif, N, band)';
    D = zeros(band, N);
    mu = 1;


    for ite = 1:40
        % Updating Z: Z_{k+1} = argmin_Z lambda*phi(Z) + mu/2 || Y-EZ-V_k-D_k||_F^2
        Y_aux = Y_ori - V + D;
        img_aux = reshape(Y_aux', row, column, band);
        Rw_fasthyde = eye(band); % Noise covariance matrix Rw_fasthyde is identity matrix because the image has been whitened.
        Z = FastHyDe_fixEreturnZ(img_aux, E, Rw_fasthyde);

        % Check for NaNs after updating Z
        if any(isnan(Z(:)))
            error('NaNs found after updating Z');
        end

        % Updating V: V_{k+1} = argmin_V ||V||_1 + mu/2 || Y-EZ_{k+1}-V-D_k||_F^2
        V_aux = Y_ori - E * Z + D;
        par = 1;
        V = sign(V_aux) .* max(abs(V_aux) - par, 0);

        % Check for NaNs after updating V
        if any(isnan(V(:)))
            error('NaNs found after updating V');
        end

        % Updating D: D_{k+1} = D_k - (Y-EZ_{k+1}-V_{k+1})
        D = D + (Y_ori - E * Z - V);

        if ite > 1
            criterion(ite) = norm(Z - Z_old, 'fro') / norm(Z_old, 'fro');
            if criterion(ite) < 0.001
                break;
            end
        end

        Z_old = Z;
    end

    figure; plot(criterion, '-o');
    Y_denoised = E * Z;
    Y_denoised = sqrt(Rw_ori) * Y_denoised;
    img_denoised = reshape(Y_denoised', row, column, band);

    % Check for NaNs in the final output
    if any(isnan(img_denoised(:)))
        error('NaNs found in the final denoised image');
    end
end

