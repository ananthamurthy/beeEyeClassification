% DATASETS: Reshma Basak
% AUTHOR: Kambadur Ananthamurthy
% PURPOSE: Find the standard crop using "getTheEyeCrop.m" and then
% analyse for the "red-ness" of the pixels defining the eye.
% NOTES: Reshma studies bees and her data is in the form of .jpg images, manually sorted based on eye
% colour. The task is to automate loading the datasets, analysis to
% identify the eye and score it based on red/pink-ness.

tic %Start time for code run

clear
close all

%Operations
saveData = 0; % Binary switch. 0: No (for testing). 1: Yes (for production run).
manualMode = 1; % Binary switch. 0: No. 1: Yes.

HOME_DIR = '/home/ananth/Documents/beeEyeClassification';
DATA_DIR = '/home/ananth/Desktop/sorted';

sortedTitle = {'1_very light pink eyes'; ...
    '2_light pink eyes'; ...
    '3_orange eyes'; ...
    '4_brown eyes'; ...
    '5_dark brown eyes'; ...
    '6_yellow body and dark eyes'; ...
    '7_wings darkened and curled'; ...
    '8_pigmented almost ready'}; % MATLAB Structure.
%nCaseStudies = length(sortedTitle); % Will pull out largent dimension. Alternatively, use size(sortedTitle, 1).
nCaseStudies = 1; %Test mode

% For MATLAB Structures, call indexed values using var{index}.
% The var(index) nomenclature will pull out a cell array instead of type string.

% Identifying Parameters for filename
hives = {'C1'; 'F'};
%nHives = length(hives);
nHives = 1; %Test mode

batches = {'1'; '2'; '3'};
%nBatches = length(batches);
nBatches = 3; %Test mode

%nPupae = 20; %total
nPupae = 1; %Test mode
pupae = string(1:nPupae); %string array. This would work with integers as well.

%nOrientations = 6; %total
nOrientations = 1; %Test mode
orientations = string(1:nOrientations);  %string array

% Setting default parameters for image
% Setting default params for immage.
xmin0 = 1150; %please change to adapt for datasets. This is just the default
ymin0 = 150; %please change to adapt for datasets. This is just the default.
WIDTH = 600; % !! Don't change. Keep the same for all datasets, unless magnification is different
HEIGHT = 600; % !! Don't change. Keep the same for all datasets, unless magnification is different
defaultCrop = [xmin0 ymin0 WIDTH HEIGHT]; %[xmin ymin width height] of reference image - default.

missingDatasets = [];

for topFolderNumber = 1:nCaseStudies
    filepath = strcat(DATA_DIR, '/', sortedTitle{topFolderNumber}); %horizontal string concatenation [IMPORTANT: be careful for "/"s. Keep to one format.]
    fprintf('>>> [INFO] Now Analyzing Top Folder: %s/%s ...\n', DATA_DIR, sortedTitle{topFolderNumber}) %Prints to console

    %File specifics. One should ideally avoid nested loops with more than 3 levels,
    %but the following is foolproof.
    for hive = 1:nHives
        for batch = 1:nBatches
            for pupa = 1:nPupae
                for orientation = 1:nOrientations
                    filename = strtrim(sprintf('Hive%s_Batch%s_Pupa%s_%s\n', ...
                        hives{hive}, ...
                        batches{batch}, ...
                        pupae(pupa), ...
                        orientations(orientation)));
                    fprintf('>>> [INFO] Filename: %s ...\n', filename)
                    fullFilePath = strtrim(sprintf('%s/%s.jpg', filepath, filename));

                    % Analysis Section
                    %1. Load File
                    try
                        image = imread(fullFilePath);
                        %Alternatively, we could use exist(fullFilePath,
                        %'dir') to check (might even be faster)
                    catch
                        warning('Unable to find %s', fullFilePath) % Includes top directory
                        %warning('Unable to find %s\n', filepath)
                        missingDatasets = [missingDatasets; filename];
                        fprintf('>>> ... Skipping for now ...\n')
                        continue
                    end

                    %2. Crop for eye
                    if manualMode
                        disp('>>> [INFO] Manual Mode: Find and save crop coordinates ...')
                        arguments.DATA_DIR = DATA_DIR;
                        arguments.filepath = filepath;
                        arguments.filename = filename;
                        arguments.topFolderNumber = topFolderNumber;
                        arguments.sortedTitle = sortedTitle;
                        arguments.defaultCrop = defaultCrop;
                        arguments.saveData = saveData;
                        crop = getTheEyeCrop(arguments);
                    else
                        disp('>>> [INFO] Loading crop parameters directly ...')
                        %load crop parameters from preliminary manual analysis.
                        load(strtrim(sprintf('%s/%s-cropParams.mat', ...
                            filepath, ...
                            filename))); %Loads (conveniently) as a variable "crop"
                    end
                    %3. Intensity based binarization
                    %image = imread(fullFilePath);
                    fig3 = figure(3);
                    set(fig3,'Position', [1500, 1000, 200, 150]);
                    clf
                    croppedImage = imcrop(image, crop);
                    imshow(croppedImage)
                    title(sprintf('Cropped with xmin = %d and ymin = %d', crop(1), crop(2)))

                    %4. Classification metrics

                    disp('...... done!') %disp() is like a sprintf() but not as powerful.
                end
            end
        end
    end
    disp('... All done!')
end
elapsedTime = toc;