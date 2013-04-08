 hvfr = vision.VideoFileReader('viptraffic.avi', ...
                                     'ImageColorSpace', 'Intensity', ...
                                     'VideoOutputDataType', 'uint8');
 
% hvfr = vision.VideoFileReader('E:\Resources\vision_data\UMN Dataset\Crowd-Activity-All.avi', ...
%   'ImageColorSpace', 'Intensity', ...
%   'VideoOutputDataType', 'uint8');
hidtc = vision.ImageDataTypeConverter; 
hof = vision.OpticalFlow('ReferenceFrameDelay', 1);
%hof = vision.OpticalFlow('ReferenceFrameDelay', 1, 'Method', 'Lucas-Kanade');
hof.OutputValue = 'Horizontal and vertical components in complex form';
hsi = vision.ShapeInserter('Shape','Lines', 'BorderColor','Custom', ...
    'CustomBorderColor', 255);
hvp = vision.VideoPlayer('Name', 'Motion Vector');
while ~isDone(hvfr)
  frame = step(hvfr);
  im = step(hidtc, frame); % convert the image to 'single' precision
  of = step(hof, im);      % compute optical flow for the video
  lines = videooptflowlines(of, 20); % generate coordinate points 
  out   =  step(hsi, im, lines); % draw lines to indicate flow
  step(hvp, out);                % view in video player
end
release(hvp);
