function [quotient, remainder] = fxp_udiv_restoring(dividend, divisor)
% two's complement data format
% support bit length 8 (A-4bit, Q-4bit), 16 (A-8bit, Q-8bit), 32 (A-16bit, Q-16bit), 64 (A-32bit, Q-32bit)
% restoring algorithm

% Note: bin3dec works only up to 52 bits. It returns a double, not uint64.
if divisor <= 2^5-1 && dividend <= 2^5-1
    numBit = 4;
    regAQ = uint8(dividend);    % A-remainder, Q-quotion
elseif divisor <= 2^9-1 && dividend <= 2^9-1
    numBit = 8;
    regAQ = uint16(dividend);
elseif divisor <= 2^17-1 && dividend <= 2^17-1
    numBit = 16;
    regAQ = uint32(dividend);
elseif divisor <= 2^33-1 && dividend <= 2^33-1
    numBit = 32;
    regAQ = uint64(dividend);
else
    error('Error: input are larger than 32 bits');
end

if divisor >= 2^numBit
    error(['Error: divisor can not be longer than ', num2str(numBit-1), ' bits.']);
end

maskA = binchar2uint([repmat('1',1,numBit), repmat('0',1,numBit)], 2*numBit);  % '1111111111111111111111111111111100000000000000000000000000000000'
maskQ = binchar2uint([repmat('0',1,numBit), repmat('1',1,numBit)], 2*numBit);  % '0000000000000000000000000000000011111111111111111111111111111111';

val = typecast(regAQ, ['int',num2str(numBit)]);
pValA = dec2bin(val(2), numBit);
pValQ = dec2bin(val(1), numBit);
pValB = dec2bin(divisor, numBit);
disp(['Binary resotring division: divide ', num2str(dividend), ' by ', num2str(divisor)]);
disp(['Quotient Q (initialized with dividend): ', pValQ]);
disp(['Remainder A (initialized with 0): ', pValA]);
disp(['Divisor B: ', pValB]);
fprintf(['\t\t%-8s %-', num2str(numBit), 's %-', num2str(numBit), 's %-6s %-', num2str(numBit), 's %-', num2str(numBit), 's\n'], 'Step', 'A', 'Q', 'A-B<0?', 'A', 'Q');

for i = numBit:-1:1

    % shift left register AQ
    regAQ = bitsll(regAQ, 1);
    
    % check if A is larger than divisor
    valHalfLen = typecast(regAQ, ['int',num2str(numBit)]);
    regQ = valHalfLen(1);
    regA = valHalfLen(2);

    pValQ1 = dec2bin(regQ, numBit);
    pValA1 = dec2bin(regA, numBit);

    % subtract
    regA = regA - divisor;

    if regA < 0 % signed bit is 1 (in 2's complement data format), the current dividend is smaller than divisor, nothing happens, restore regA
        regA = regA + divisor;
        pValE = 'Y';
    else  % lsb of regAQ is 1
        regQ = regQ + 1;
        pValE = 'N';
    end

    % mimic to update the regAQ
    regAQ = typecast([regA,0], ['uint',num2str(2*numBit)]);
    regQ  = typecast([regQ,0], ['uint',num2str(2*numBit)]);
    regAQ = bitor(bitshift(regAQ,numBit), regQ);

    val = typecast(regAQ, ['int',num2str(numBit)]);
    pValA2 = dec2bin(val(2), numBit);
    pValQ2 = dec2bin(val(1), numBit);

    fprintf(['\t\t%-8s %-', num2str(numBit), 's %-', num2str(numBit), 's %-6s %-', num2str(numBit), 's %-', num2str(numBit), 's\n'], num2str(numBit-i+1), pValA1, pValQ1, pValE, pValA2, pValQ2);

end

valHalfLen = typecast(regAQ, ['int',num2str(numBit)]);
regQ = valHalfLen(1);
regA = valHalfLen(2);
quotient = regQ;
remainder = regA;

end