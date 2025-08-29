function uintVal = binchar2uint(bitArray, targetBitLen)

if nargin < 2
    targetBitLen = -1;
end

bitArray = bitArray - '0';

% determine the actual bit length by detecting leading 1
bitLen = length(bitArray);
i = 1;

while (bitArray(i)~=1 && i<=length(bitArray))
    bitLen = bitLen - 1;
    i = i + 1;
end

bitArray = bitArray(i:end);

% support only uint8, uint16, uint32, and uint64
if bitLen <=8
    uintVal = uint8(sum(bitArray .* bitshift(1, bitLen-1:-1:0)));
elseif bitLen <= 16
    uintVal = uint16(sum(bitArray .* bitshift(1, bitLen-1:-1:0)));
elseif bitLen <= 32
    uintVal = uint32(sum(bitArray .* bitshift(1, bitLen-1:-1:0)));
elseif bitLen <= 64
    uintVal = uint64(sum(bitArray .* bitshift(1, bitLen-1:-1:0)));
else
    error('Error: can not be larger than 64 bits');
end

% convert to target bit length if it is set
if targetBitLen > 0 && targetBitLen < bitLen
    warning('Warning: target bit length is smaller than the actual one. The input target bit length is ignored.');
elseif targetBitLen == 8
    uintVal = uint8(uintVal);
elseif targetBitLen == 16
    uintVal = uint16(uintVal);
elseif targetBitLen == 32
    uintVal = uint32(uintVal);
elseif targetBitLen == 64
    uintVal = uint64(uintVal);
else
    warning('Warning: allowed bit lengths are 8, 16, 32, 64. The input target bit length is ignored.')
end

end