function C = convMatrix(A,B)
% CONVMATRIX calculate the convolution between A and B. Each element of A
% or B is a matrix. A or B should be a three-dimensional matrix, and each
% element of A or B should has an appropriate size.
% A(i), i = 0, 1, 2, ..., Na-1
% B(i), i = 0, 1, 2, ..., Nb-1
% C(i) = sum_(j=0)^(Na-1) A(j)*B(i-j)
%
% If A, B are vectors, compatible for normal vector convolution. In this
% case, output is also a vector;

% reverse A, keep B in the same order
%
% Author:       Zekai Liang
% Last Update:  14.04.2021 Monday

[dimA1, dimA2, dimA3] = size(A);
[dimB1, dimB2, dimB3] = size(B);

if dimA2 ~= dimB1
    error('Dimension of A and B does not match.');
end

% output matrix length
dimC3 = dimA3 + dimB3 - 1;
C = zeros(dimA1, dimB2, dimC3);

% execute convultion
for i = 1 : dimC3
    
    idxAMin = i - dimA3 + 1;
    idxAMax = i;
    idxBMin = 1;
    idxBMax = dimB3;
    
    idxSumMin = max(idxAMin, idxBMin);
    idxSumMax = min(idxAMax, idxBMax);
    
    tmp = 0;
    for j = idxSumMin : idxSumMax
        tmp = tmp + A(:,:,idxAMax-j+1) * B(:,:,j);
    end
    C(:,:,i) = tmp;
    
end

end