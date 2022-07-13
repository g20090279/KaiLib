function parSave(fname,varargin)
%
% Author:       Zekai Liang
% Last Update:  14.04.2021 Monday
    
% number of variable-value pair
numVar = length(varargin)/2;

% separate variable name and value
varName = cell(numVar,1);
varValue= cell(numVar,1);
for i = 1:2:length(varargin)
    j = (i+1)/2;
    varName{j} = varargin{i};
    varValue{j}= varargin{i+1};
    
    % put the value in the workspace
    eval([varName{j},'=varValue{j}']);
end

save(fname,varName{:});

% EOF
end