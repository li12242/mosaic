function outfig = mosaic(tileDir, photoFile)
% mosaic    - main function
% 
% Description:
%   creates a photomosaic from your collection of photos
% Input:
%   dbdir   -
%   baseimg - 
% Output:
%   outfig  - 
% 
% Usages:
%   baseimg = '/Users/mac/Documents/MATLAB/mosaic/Base/IMG_3784.JPG';
%   dbdir = '/Users/mac/Documents/MATLAB/mosaic/testDataBase';
%   outimg = mosaic(dbdir, baseimg);
% 
% Author:
%   li12242 - Department of Civil Engineering in Tianjin University
%   Daniel Claxton  - University of Florida
% Email:
%   li12242@tju.edu.cn
% -------------------------------------------------------------------------
% Ver0.0 by Daniel
%	<http://nl.mathworks.com/matlabcentral/fileexchange/7876-mosaic>
% Ver1.0 (2016/1/6) by li12242
% 	1. discard the gui
% 
% 

%% set parameters
% dbdir = '/Users/mac/Documents/MATLAB/mosaic/TileImgDataBase';
% baseim = '/Users/mac/Documents/MATLAB/mosaic/Base/IMG_3784.JPG';
% img = imfinfo(baseimg);
nMosaicCol = 10; % column number of the mosaic poicture
nMosaicRow = 10; % row number of the mosaic poicture
nTile = 100; % the max number of tile images
radius = 5; % radius of proximity
tweekRatio = 0.5; % tweek ratio for the tile image
mixRaio = 0.5;

%% 
dirInfoStruct = dir(tileDir);
fileNameCell = {dirInfoStruct.name}';
% read photo image
photoImg = imread(photoFile); 
[nRow, nColm, ~] = size(photoImg);
colm2row = nColm/nRow;

% store and rank image tiles into 'tileData'
tileData = imsort(fileNameCell, tileDir, colm2row, nTile);

% Divide base image into [nx x ny] parts & store information of each parts into photoData
photoData = imDevide(photoImg, nMosaicCol, nMosaicRow);
% Pick best tiles to match each parts of mosaic picture
match = imatch(nMosaicCol,nMosaicRow,photoData,tileData,radius);

tiles = {tileData.img};

% Assemble tiles into one image
mos = imassem(photoImg,tiles(match),photoData,nMosaicCol,nMosaicRow,tweekRatio);

% Add tow image according to mixRation
outfig = imfade(mos,photoImg,mixRaio);

imshow(outfig);
end

function img = imfade(img1,img2,ratio)
s1 = ratio; 
s2 = 1-s1;
img = (imadd(immultiply(img2,s1),immultiply(img1,s2)));
end