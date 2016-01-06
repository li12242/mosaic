function rgb = imavg(img)
% rgb   - calculate the average rgb (0,1) of color average 
% 
% Input:
%   img - color average, data [m,n,3]
% Output:
%   rgb - average rgb
% 

rgb = zeros(1,3);
for i=1:3
    rgb(i) = mean2( img(:,:,i) );
end
rgb = rgb/255;

end% func