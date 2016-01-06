function match = imatch(nCol,nRow,photoData,tileData,r)
% imatch - matching the mosaic part of photo with tile image
% 
% Input:
%   nCol - column number of the mosaic poicture
%   nRow - row number of the mosaic poicture
%   photoData - porperties of each parts of photo
%   tileData - properties datas of tile images
%   r - radius of proximity
% 
% Output:
%   match - the match matrix of tile image index to each parts of photo
% 
% Usages:
%   match = imatch(photoImg,nMosaicCol,nMosaicRow,photoData,tileData,r);
% 
% Author:
%   li12242 - Department of Civil Engineering in Tianjin University
%   Daniel Claxton  - University of Florida
% Email:
%   li12242@tju.edu.cn
% 
%%

tilePartsRGB = {tileData.parts};
photoPartsRGB = {photoData.parts};

match = ones(nRow,nCol)*nan; 
poss = zeros(length(tileData), 1);

for i=1:length(photoData)
    
    b = assembleRGB(photoPartsRGB{i});
    for j=1:length(tileData)
        a = assembleRGB(tilePartsRGB{j});
        % cal each tile image match score with photo parts
        poss(j) = colorad(a,b); 
    end% for

    [~,ind] = sort(poss); % sort the tile images according to its match score
    [ii, jj] = ind2sub([nRow,nCol], i);
    k = 1; temp = ind(k);
    while isNeighbour(match, ind(k), [ii,jj], r)
        % if current image [ind(k)] is in close proximity to [ii,jj], choose another one
        k = k+1; % ind(k+1)
        if k > length(ind)-1
            %  If no matter what, we're near another like tile, 
            %  randomly chose one of the top half best choices
            rp = randperm(floor( length(ind)/2 ));
            temp = ind(rp(1));
            break
        end
        temp = ind(k);          
    end% while
    match(i) = temp;
    % Test if current image is in close proximity to other images
%     fprintf('Building Mosaic Progress: %f\n',i/length(photoData));
end% for
match = match(:);
end% func

%% local function

function rgb = assembleRGB(a)
% formatcell - assemble average rgb of 3x3 parts into Matrix
% 
% Input:
%   a - average rgb of 3x3 parts, row element: [r,g,b], size [9,3]
% Output:
%  rgb - average RGB matrix of 3x3 parts, size [3,3,3]
% 
% ------------------------------------------------------------------------
rgb = reshape(a,3,3,3); % assemble average rgb of 3x3 parts into Matrix;
end% func

function out = isNeighbour(Mat,val,pos,r)
% isNeighbour - if val is in close proximity to position 'pos' with radius
%   'r' in Mattrix 'Mat'
% 
% Input:
%   Mat - martix
%   val - value
%   pos - index of position, [row, col]
%   r   - radius
% 
% Output:
%   out - (0)not exists (1)exists
% ------------------------------------------------------------------------
row = pos(1); col = pos(2);
TOL = 1e-6;
ind = (Mat - val)<TOL;
[ii, jj] = find(ind);
out = sum((abs(ii - row) + abs(jj - col)) < r);
end% func

function c = colorad(a,b)
% colorad - calculate two figure distance
% ------------------------------------------------------------------------
% c = sqrt(sum(sum(sum(a-b,1)).^2));
c = sqrt(mean2( (a-b).^2 ));
end% func