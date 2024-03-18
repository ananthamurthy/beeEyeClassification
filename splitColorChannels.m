function [croppedImage_red, croppedImage_green, croppedImage_blue] = splitColorChannels(croppedImage, crop, plotData)

%Isolating channels - RED
croppedImage_red = croppedImage; %initializing
croppedImage_red(:, :, 2:3) = 0; %removing green and blue channels

%Isolating channels - GREEN
croppedImage_green = croppedImage; %initializing
%croppedImage_green(:, :, 1:2:3) = 0; %removing red and blue channels
croppedImage_green(:, :, 1) = 0; %removing red channel
croppedImage_green(:, :, 3) = 0; %removing blue channel

%Isolating channels - BLUE
croppedImage_blue = croppedImage; %initializing
croppedImage_blue(:, :, 1:2) = 0; %removing red and green channels

if plotData
    fig4 = figure(4);
    set(fig4,'Position', [1500, 1000, 1200, 800]);
    clf
    subplot(1, 3, 1)
    imshow(croppedImage_red)
    title(sprintf('RED - Cropped with xmin = %d and ymin = %d', crop(1), crop(2)))

    subplot(1, 3, 2)
    imshow(croppedImage_green)
    title(sprintf('GREEN - Cropped with xmin = %d and ymin = %d', crop(1), crop(2)))

    subplot(1, 3, 3)
    imshow(croppedImage_blue)
    title(sprintf('BLUE - Cropped with xmin = %d and ymin = %d', crop(1), crop(2)))
end
end