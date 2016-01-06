function imData = imDevide(photoImg, nMosaicCol, nMosaicRow)
% imDevide - devide photo into [nMosaicCol, nMosaicRow] parts
% 
% Input:
%   photoImg - color image, size [m, n, 3]
%   nMosaicCol - divided parts in column
%   nMosaicRow - divided parts in row
% 
% Output:
%   imData - properties of each parts
%    {  
%       avg - average rgb value, size [1,3]
%       parts - average rgb value of subdivide 3x3 parts, size [9,3] 
%    }
% 
% Author:
%   li12242 - Department of Civil Engineering in Tianjin University
%   Daniel Claxton  - University of Florida
% Email:
%   li12242@tju.edu.cn
% 
%%
partImg = imparts(photoImg,nMosaicCol,nMosaicRow);

imData = struc([]);
for i=1:length(partImg)
    imData(i).avg = imavg(partImg{i});
    subpart = imparts(partImg{i},3,3);
    imData(i).parts = zeros(9, 3);
    for j=1:9
        imData(i).parts(j, :) = imavg(subpart{j});
    end
%     fprintf('Partitioning Base Image: %f\n', i/length(partImg));
end