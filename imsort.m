function db2 = imsort(fileNameCell,tileDir,col2row, nTile)
% imsort - store the tile images into variabel 'db2'
% 
% Input:
%   files   - image name, cell {n x 1}
%   tileDir - file directory of tile images
%   nTile   - the max number of tile images
% 
% Output:
%   db2     - properties datas of tile images
%     { name    - name of tile image
%       avg     - average rgb (0,1) of tile image, size [1,3]
%       score   - distance of average rgb to target rgb
%       img     - color image data 
%       parts   - average rgb of 3x3 divided parts, size [9,3]
%     }
% 
% Todo:
%   1. parallelization
% 
% Author:
%   li12242 - Department of Civil Engineering in Tianjin University
%   Daniel Claxton  - University of Florida
% Email:
%   li12242@tju.edu.cn
% 
% 
%% check & load exit file 'db.mat'

if isdbFun(tileDir)
    answer = questdlg('Would you like to use cached thumbnails?', ...
        'Thumnails Found', ...
        'Yes','No','Yes'); % default "yes"
    if strcmp(answer,'Yes'),
        fprintf('Loading Sorting Tile Images\n');
        load([tileDir '/db.mat']);
        return
    end% if
end% if

%% cal tile files

n = size(fileNameCell,1);
k = 1; % contour for tile images
db = struct([]); db2 = struct([]);

for i=1:n
    if k >= nTile
        break
    end% if
    file = [tileDir '/' char(fileNameCell(i,:))]; % full path & filename
    [pathstr,name,ext] = fileparts(file);
    if isImgFun(ext(2:end)) % is an image ifle
        img = imread([pathstr '/' name ext]);
        
        [tileRow, tileCol, ~] = size(img);
        % cut the tile image
        if tileCol/tileRow > col2row
            img = img(:, 1:floor(col2row*tileRow), :);
        else % too long
            img = img(1:floor(tileCol/col2row), :, :);
        end
        
        % store into the variable db
        db(k).name = file;
        db(k).avg = imavg(img); % count the average RGB (0~1) of img [3x1]
        db(k).score = clrdist(db(k).avg,[1, 1, 1]);    % Need to figure out sorting filter
        db(k).img = img;
        parts = imparts(img,3,3); % cell {3x3}
        db(k).parts = zeros(9, 3);
        for j=1:9
            db(k).parts(j,:) = imavg(parts{j}); % [3x1]
        end
        k = k+1;
    end
    fprintf('Loading Sorting Tile Images, %f\n', i/n);
end

%% sort and restore tile images

[~,ind] = sort(cell2mat({db.score}));
% resort the image data into db2
for i=1:length(db)
    db2(i).score = db(ind(i)).score;
    db2(i).img = db(ind(i)).img;
    db2(i).name = db(ind(i)).name;
    db2(i).avg = db(ind(i)).avg;
    db2(i).parts = db(ind(i)).parts;
end% for

end% func

%% local function

function out = isdbFun(tiledir)
% isdbFun - exits tile data file
% Input:
% Output:
% 
isdb = exist([tiledir, '/db.mat'], 'file');

switch isdb
    case 2
        out = 1;
    case 0
        out = 0;
end
end% func

function out = isImgFun(ext)
% isimg - judge an image file by extersion
% Input:
%   ext - extersion string of file, e.g, "png", "tif"
% Output:
%   out - 
%       1, is an image file
%       0, isnot an image file
% 
formats = ['bmp';'JPG';'tif';'png';'gif';'cur';'ico'];
for i = 1:size(formats, 1)
    out = strcmp(formats(i,:), ext);
    while out
        return
    end
end
end% func

function d = clrdist(a,b)
% clrdist - calculate the distance of two vectors
% Input:
%   a - row vector, data [1,3]
%   b - row vector, data [1,3]
% Output:
%   d - distance of two point
d = sqrt(sum((a-b).^2));
end% func