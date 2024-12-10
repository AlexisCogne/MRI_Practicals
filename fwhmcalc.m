% STEP 1: load the filtered FWHM maps
% Define the folder paths and subfolder paths
rat_dates = {'08042022','13042022','18102021','31052022'};
folder_paths = {'Filter-Denoising Project/DenoisedData/08042022', ...
                'Filter-Denoising Project/DenoisedData/13042022', ...
                'Filter-Denoising Project/DenoisedData/18102021', ...
                'Filter-Denoising Project/DenoisedData/31052022'};

subfolder_paths = {'filtered', ...
                   'LR Denoising_quantified', ...
                   'MP-PCA Denoising_quantified', ...
                   'No Denoising_quantified'};

% Path to the mat file within each subfolder
mat_file = 'Slice_N1/Results/metab_map.mat';

% Get the current working directory
current_dir = pwd;

% Initialize a structure array to hold the loaded data
loaded_data = struct();

% Loop over each folder and subfolder to load the mat file
for i = 1:length(folder_paths)
    for j = 1:length(subfolder_paths)
        % Construct the full path to the mat file
        full_path = fullfile(current_dir, folder_paths{i}, subfolder_paths{j}, mat_file);
        
        % Load the mat file
        if isfile(full_path)
            data = load(full_path);
            disp(full_path)
            
            % Store the loaded data in the structure
            % Using dynamic field names based on folder and subfolder indices
            loaded_data(i, j).folder = folder_paths{i};
            loaded_data(i, j).subfolder = subfolder_paths{j};
            loaded_data(i, j).data = data;
        else
            warning('File not found: %s', full_path);
        end
    end
end

% Display the structure array to verify the loaded data
disp(loaded_data);

%%
fwhms = [];
for i=1:4
    fwhm_map = loaded_data(i,4).data.met_map.FWHM;
    snr_map = loaded_data(i,4).data.met_map.SNR;
    mask = snr_map > 4;

    fwhm_map_filtered = fwhm_map(mask);

    % Compute the mean concentration where SNR > 4
    mean_fwhm = mean(fwhm_map_filtered);
    fwhms = [fwhms, mean_fwhm];

end

disp(mean(fwhms))
%%
