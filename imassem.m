function newImg = imassem(photoImg,tilesImg,photoData,nMosaicCol,nMosaicRow,tweekRatio)
% iassem - assemble the taile images according mathc matrix
% 
% Input:
%   photoImg - color image of photo
%   tilesImg - color image of tiles pictures, cell {nMosaicCol x nMosaicRow, 1}
%   photoData - properties of photo
%   nMosaicCol - column number of the mosaic poicture
%   nMosaicRow - row number of the mosaic poicture
%   tweekRatio - the ratio for tweek the tile image
% 
% Output:
%   newImg - the new assembled tiles images
% 
% Usages: 
%   mos = imassem(photoImg,tiles(match),photoData,nMosaicCol,nMosaicRow, cc);
% Todo:
%   1. parallelization
% 
% 
%%
[nRow, nCol, ~] = size(photoImg);

colNum = round(linspace(0,nCol,nMosaicCol+1));
rowNum = round(linspace(0,nRow,nMosaicRow+1));

newImg = zeros(nRow,nCol,3,'uint8'); % allocate memory for result
k = 1; tol = nMosaicCol*nMosaicRow;
for j = 1:nMosaicCol
    for i = 1:nMosaicRow
        
        avgRGBDiff = photoData(k).avg - imavg(tilesImg{k});
        temp = imtweek(tilesImg{k}, avgRGBDiff*tweekRatio); % tweek the tile image
        temp = imresize(temp, [rowNum(i+1)-rowNum(i), colNum(j+1)-colNum(j)]);
        newImg( (rowNum(i)+1):rowNum(i+1), (colNum(j)+1):colNum(j+1), :) = temp;
        
        fprintf('Assembling Tile Images, %f\n', k/tol)
        k = k+1; 
    end% for
end% for
end% func

%% local function

function img = imtweek(img,normDelta)
% imtweek - tweek the tile image
% 
% Input:
%   img - initial image
%   normDelta - the difference of average rgb between tile image and photo
%       parts
% 
% Output:
%   img - tile image after tweek
% 
rgbDelta = round(normDelta*255);
for i=1:3
    img(:,:,i) = imadd(img(:,:,i),rgbDelta(i));
end
end