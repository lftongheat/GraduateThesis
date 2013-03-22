function [u, v] = lucas_kanade_matlab(files, window_size)
% Calculate optical flow with the Lucas-Kanade algorithm
% lucas_kanade(files, window)

images = {};
for file = files
  images = [images double(imread(file{:}))];
end

% Calculate derivates
fx = conv2(images{1}, 0.25 * [-1 1; -1 1]) + conv2(images{2}, 0.25 * [-1 1; -1 1]);
fy = conv2(images{1}, 0.25 * [-1 -1; 1 1]) + conv2(images{2}, 0.25 * [-1 -1; 1 1]);
ft = conv2(images{1}, 0.25 * ones(2)) + conv2(images{2}, -0.25 * ones(2));

% Calculate optical flow
window_center = floor(window_size / 2);
image_size = size(images{1});
u = zeros(image_size);
v = zeros(image_size);
for i = window_center + 1:image_size(1) - window_center
  for j = window_center + 1:image_size(2) - window_center
    % Get values for current window
    fx_window = fx(i - window_center:i + window_center, j - window_center:j + window_center);
    fy_window = fy(i - window_center:i + window_center, j - window_center:j + window_center);
    ft_window = ft(i - window_center:i + window_center, j - window_center:j + window_center);

    fx_window = fx_window';
    fy_window = fy_window';
    ft_window = ft_window';

    A = [fx_window(:) fy_window(:)];

    U = pinv(A' * A) * A' * -ft_window(:);

    u(i, j) = U(1);
    v(i, j) = U(2);
  end
end

% Define csv output format
format = [];
for i = 1:image_size
  if (i == image_size)
    format = [format '%g'];
  else
    format = [format '%g,'];
  end
end
format = [format '\n'];

% Write flow vectors to output file
file = fopen('output.csv', 'w');
fprintf(file, format, u);
fprintf(file, format, v);
fclose(file);

% Display the result
figure
axis equal
quiver(impyramid(impyramid(medfilt2(flipud(u), [5 5]), 'reduce'), 'reduce'), -impyramid(impyramid(medfilt2(flipud(v), [5 5]), 'reduce'), 'reduce'));