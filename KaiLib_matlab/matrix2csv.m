function matrix2csv (fileName, data, header, isOverwrite, csvComment)
% MATRIX2CSV writes the data with header into a .csv file. The length of
% header should be equal the number of columns in the matrix "data".
% 
% An example for inputs is
% title1, title2, ..., titleM
% data11, data12, ..., data1M
%  ...,     ...,  ...,  ...
% dataN1, dataN2, ..., dataNM
%
% Input(s):
% - fileName (char array or string)
%       the filename (with path) that you want to create
% - data (matrix)
% - header (string array) [optional]
%       the title of each column, use empty array [] if no header is given
% - isOverwrite (boolean):
%       0: overwriting existed file is not allowed;
%       1: ~ is allowed.
% - csvComment (string)
%
% %% --- Example ---
% berUser1 = [0.1, 0.09, 0.07, 0.03, 0.005, 0.001]';
% berUser2 = [0.1, 0.08, 0.07, 0.05, 0.03, 0.02]';
% snr = [0, 2, 4, 6, 8, 10]';
% 
% % The data should be combined into a matrix. The first column should be
% % x-axis, and the other columns are the values of multiple lines. In this
% % example, we want to plot something
% %        ^
% %    b   |  \  -
% %    e   |   \   \   u2
% %    r   |u1  \    \
% %        |     |     \
% %  ----------------------------------->
% %                 snr
% 
% data = [snr, berUser1, berUser2];
% header = ["snr", "user1", "user2"];
% isOverwrite = 0;
% csvComment = "This is an example to save snr-ber plot in a .csv format";
% fileName = "example_matrix2csv.csv";
% 
% matrix2csv(fileName, data, header, isOverwrite, csvComment);
% ---
%
% Author:       Zekai Liang
% Last Update:  02.02.2022 Wednesday

% header is not necessary
if nargin < 5, csvComment = []; end
if nargin < 4, isOverwrite = 0; end
if nargin < 3, header = []; end

[nRow, nCol] = size(data);

% check if dimension of data and header match or not
if nCol ~= length(header)
    error('Length of data and header do not match.');
end

% check if the file exists
if exist(fileName, 'file') == 2 && ~isOverwrite
    error('File exists already. Use another file name or set isOverwrite to be true.');
end

% open or create file
fid = fopen(fileName, 'w+');

% write comment
if ~isempty(csvComment)
    fprintf(fid, '# %s\n', csvComment);
end

% write title
if ~isempty(header)
    fprintf(fid, '%s\n', strjoin(header, ', '));
end

% write data
data = string(data);
pFormat = [repmat('%s, ',1,nCol-1),'%s\n'];
for i = 1:nRow
    fprintf(fid, pFormat, data(i,:) );
end

% close file
fclose(fid);

end