function out = imparts(img,nCol,nRow)
% divide an image into [nRow,nCol] parts
% 
% Input:
%   img - color image, data [m, n, 3]
%   nCol - dividing No. of column
%   nRow - dividing No. of row
% Output:
%   out - image parts, store by column, cell {nCol*nRow, 1}
% 
% Author:
%   li12242 - Department of Civil Engineering in Tianjin University
% Email:
%   li12242@tju.edu.cn
% 
%%

col = size(img,2); row = size(img,1);

colNum = round(linspace(1,col,nCol+1));
rowNum = round(linspace(1,row,nRow+1));

k=1;
out = cell(nCol*nRow, 1);

for j = 1:nCol
    for i = 1:nRow
        out{k} = img(rowNum(i):rowNum(i+1), colNum(j):colNum(j+1), :);
        k = k+1;
    end
end

end% func