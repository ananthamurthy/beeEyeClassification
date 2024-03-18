
function crop = getTheEyeCrop(arguments)

% For the current dataset
fprintf('[INFO] Now Analyzing Top Folder: %s%s ...\n', arguments.DATA_DIR, arguments.sortedTitle{arguments.topFolderNumber}) %Prints to console
fullFilePath = strtrim(sprintf('%s/%s.jpg', arguments.filepath, arguments.filename));

image = double(imread(fullFilePath));
fig1 = figure(1);
set(fig1,'Position', [0, 0, 1000, 400]);
clf
imshow(image)
title('Reference Image')

crop = arguments.defaultCrop; %Initially, at aleast
while 1
    fig2 = figure(2);
    set(fig2,'Position', [1500, 1000, 200, 150]);
    clf
    croppedImage = imcrop(image, crop);
    imshow(croppedImage)
    title(sprintf('Cropped with xmin = %d and ymin = %d', arguments.defaultCrop(1), arguments.defaultCrop(2)))
    
    userAnswer = input('Are you happy with this crop (y/n)? ',"s");
    if strcmpi(userAnswer, 'y')
        %Save coordinates:
        if arguments.saveData
            disp('>>>>>> [INFO] Saving crop parameters ...')
            save(strtrim(sprintf('%s/%s-cropParams.mat', ...
                arguments.filepath, ...
                arguments.filename)), ...
                'crop')
        end
        break %Currently, the only way to break out of this while loop.
    else
        xmin = input('Please input a new xmin: '); % There has to be a faster algorithm here. Too tired to thing. Basically, format to integer.
        ymin = input('Please input a new ymin: ');

        %Set argument parser. Basically so the user doesn't enter out of
        %bounds values.
        if xmin < 0 || ymin < 0
            disp('[WARNING] Please choose positive integer values for xmin and ymin.')
            xmin = input('Please input a new xmin: '); % There has to be a faster algorithm here. Too tired to thing. Basically, format to integer.
            ymin = input('Please input ymin: ');
        end

        if xmin > size(image, 1) || ymin > size(image, 2)
            disp('[WARNING] Please choose xmin and ymin based on the total image size.')
            xmin = arguments('Please input a new xmin: '); % There has to be a faster algorithm here. Too tired to thing. Basically, format to integer.
            ymin = arguments('Please input a new ymin: ');

        end
        % Updated crop parameters
        crop = [xmin ymin WIDTH HEIGHT]; %[xmin ymin width height] of reference image; updated
        fprintf('[INFO] New xmin = %i, ymin = %i\n', xmin, ymin)

        fig2 = figure(2);
        set(fig2,'Position', [1500, 1000, 200, 150]);
        clf %clears current figure for update
        %pause(0.5)
        croppedImage = imcrop(image, crop);
        imshow(croppedImage)
        title(sprintf('Cropped with xmin = %i and ymin = %i', xmin, ymin))
    end
end
crop
end
%disp('All Done!')