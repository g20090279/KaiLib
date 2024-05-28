% calibration of function convMatrix()
% last modification: 03.04.2021

%% calibration 1: convolution of scalar sequence (len(a) > len(b))
la = 100;   % length of sequence a
lb = 50;    % length of sequence b
a = randi(100,la,1);
b = randi(50,lb,1);
if sum( conv(a,b) == squeeze( convMatrix( reshape(a,1,1,la), ...
    reshape(b,1,1,lb) ) ) ) == la+lb-1
    disp( 'calibration 1 - passed!' );
else
    disp( 'calibration 1 - failed!' );
end

%% calibration 2: convolution of scalar sequence (len(a) < len(b))
la = 50;   % length of sequence a
lb = 100;    % length of sequence b
a = randi(100,la,1);
b = randi(50,lb,1);
if sum( conv(a,b) == squeeze( convMatrix( reshape(a,1,1,la), ...
    reshape(b,1,1,lb) ) ) ) == la+lb-1
    disp( 'calibration 2 - passed!' );
else
    disp( 'calibration 2 - failed!' );
end

%% calibration 3: exchange a & b position
la = 50;   % length of sequence a
lb = 100;    % length of sequence b
a = randi(100,la,1);
b = randi(50,lb,1);
if sum( conv(a,b) == squeeze( convMatrix( reshape(b,1,1,lb), ...
    reshape(a,1,1,la) ) ) ) == la+lb-1
    disp( 'calibration 3 - passed!' );
else
    disp( 'calibration 3 - failed!' );
end

%% calibration 4: matrix convolution
la = 10;   % length of sequence a
lb = 5;    % length of sequence b
a = randi(100,3,2,la);
b = randi(50,2,2,lb);

c = zeros(3,2,la+lb-1);
for i = 1:la+lb-1
    idxMax = min(i,la);
    idxMin = max(idxMax - la + 1,1);
    
    tmp = zeros(3,2,la+lb-1);
    tmp(:,:,i:-1:max(i-la+1,1)) = a(:,:,idxMin:idxMax);
    
    sumTmp = 0;
    for j = 1:lb
        sumTmp = sumTmp + tmp(:,:,j)*b(:,:,j);
    end
    c(:,:,i) = sumTmp;
end

c2 = convMatrix(a,b);
if sum(c(:)==c2(:)) == numel(c)
    disp( 'calibration 4 - passed!' );
else
    disp( 'calibration 4 - failed!' );
end
