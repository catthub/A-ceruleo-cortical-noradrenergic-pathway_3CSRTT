function SaveVideo(src, file, fps)
    video = VideoWriter(file); %create the video object
    video.FrameRate = fps;
    open(video); %open the file for writing
    for i=1:size(src, 2) %where N is the number of images
      %I = imread('the ith image.jpg'); %read the next image
      I = src{i};
      writeVideo(video,I); %write the image to file
    end
    close(video); %close the file
end