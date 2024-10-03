function convGdbLog2Mat (fileName)

logFile = {};

if nargin > 0
    if isfile(fileName)
        logFile = {fileName};
    end
else
    fileName = '.';
end

if exist(fileName,'dir') == 7  % 7 = directory
    fileSearch = [fileName,'/gdb.log.*'];
    disp(['Searching for ',fileSearch]);
    fileInfo = dir(fileSearch);
    cFiles = 0;
    if ~isempty(fileInfo)
        for iFile=1:length(fileInfo)
            % Only Process File with Name Beginning with gdb.log and Not with
            % File Extension .mat
            [~,fileName,fileExt] = fileparts(fileInfo(iFile).name);
            if ~strcmp(fileExt,'.mat') && strcmp(fileName(1:8),'gdb.log.')
                cFiles = cFiles + 1; % counter
                logFile = [logFile, [fileInfo(iFile).folder,'\' fileInfo(iFile).name]];
                continue;
            end
        end
    end
end

disp([num2str(length(logFile)),' File(s) found.'])

if ~isempty(logFile)

    % Begin Converting
    for iFile = 1:length(logFile)

        disp(['Processing File ', logFile{iFile}, ' ...']);

        fid = fopen(logFile{iFile});
        tLine = fgetl(fid);

        % Initialize values
        isFound = false;     % if a gdb log file for dump data from nrsim is found
        isOneline = false;   % if Eigen data is one-line data or spans into multiple lines
        isComplete = false;  % if the data is complete (need for multiple line)

        while ischar(tLine)
            % Note 1: the data structure is always: the innermost is Eigen, capsulated by multiple std::vector.
            % Note 2: the eigen matrix has maximum two dimensions.
            % Note 3: matrix element listing begins from innermost.

            % Find std::vector
            if ~isFound  % searching for first line

                % Detect pattern example: $2 = std::vector of length 14,
                % Example: capacity 14 = {Eigen::Matrix<std::complex<double>,1200,2,ColMajor> (data ptr: 0x4fcfe80) = {[0,0] = {_M_value = -0.063488650798086924 + 0.10254959057443244 * I}, [1,0] = ...
                isValid = regexp(tLine, '\$([\d]+) = std::vector of length|\$([\d]+) = Eigen::Matrix','tokens', 'once');  % starting with std::vector or Eigen::Matrix

                if isempty(isValid)
                    % Read the New Line and Then Continue
                    tLinePrev = tLine;
                    tLine = fgetl(fid);
                    continue;
                end

                % Get the GDB command index (e.g. $2), which will be used to name the file if recoding the command is not enabled in GDB
                indCommand = str2double(isValid{1});
                isSameDim = false;        % if all the Eigen::Matrix has same dimension for all std::vector

                % Detect if valid Eigen data
                resStdVec = regexp(tLine, 'std::vector of length ([\d]+), capacity ([\d]+)', 'tokens');        % must not use 'once' flag
                resEig = regexp(tLine, 'Eigen::Matrix<[\w:<>]+,([\d]+),([\d]+),[\w]+>', 'tokens', 'once');     % must not be empty, occurs once for multline data, and multipl for oneline data. For checking, just need to detect if it exists or not.

                if ~isempty(resStdVec) || ~isempty(resEig)
                    % Check if the data is one line or spans multiple lines
                    numLeftBracket = sum(tLine=='{');
                    numRightBracket = sum(tLine=='}');
                    if numLeftBracket == numRightBracket
                        isOneline = true;
                    end

                    % Dimensions of std::vector part, can be multiple std::vector
                    dimStdVec = zeros(length(resStdVec),1);
                    for i = 1:length(resStdVec)
                        dimStdVec(i) = str2double(resStdVec{i}{1});
                    end
                    numElsStdVec = prod(dimStdVec);

                    % Dimension of Eigen::Matrix part, it may be different for each std::vector.
                    dimEigMatInVec = zeros(numElsStdVec, 2);

                    if isOneline % Has enough info by using this line
                        dimEigMat = regexp(tLine, 'Eigen::Matrix<[\w:<>]+,([\d]+),([\d]+),[\w]+>','tokens');  % Record all dim of Eigen::Matrix

                        if length(dimEigMat) ~= numElsStdVec  % #occurrence of Eigen::Matrix should equal to #elements of all std::vector
                            error('Dimension Error: Occurrence of Eigen::Matrix is not equal the sum of std::vector elements!');
                        end

                        for i = 1:numElsStdVec
                            dimEigMatInVec(i,1) = str2double(dimEigMat{i}{1});
                            dimEigMatInVec(i,2) = str2double(dimEigMat{i}{2});
                        end
                    else  % Need to go next lines until this data block ends or new data block begins or end of file
                        % Save the current position
                        posFid = ftell(fid);

                        % Use the number of '{' and '}' to check if the current data block ends
                        cnt = 0;
                        isNewData = false;
                        tLineTmp = tLine;
                        while  numLeftBracket~=numRightBracket && ~isNewData && cnt<numElsStdVec
                            % Search only for Eigen::Matrix
                            dimEigMat = regexp(tLine, 'Eigen::Matrix<[\w:<>]+,([\d]+),([\d]+),[\w]+>','tokens');  % Record all dim of Eigen::Matrix

                            % Get new line and check "{" and "}"
                            tLine = fgetl(fid);
                            numLeftBracket = numLeftBracket + sum(tLine=='{');
                            numRightBracket = numRightBracket + sum(tLine=='}');

                            if isempty(dimEigMat)
                                continue;
                            end

                            if length(dimEigMat) ~= 1
                                error('Multi-line data can only have one Eigen::Matrix at one line.');
                            end

                            % Record all dim of Eigen::Matrix
                            cnt = cnt + 1;
                            dimEigMatInVec(cnt,1) = str2double(dimEigMat{1}{1});
                            dimEigMatInVec(cnt,2) = str2double(dimEigMat{1}{2});

                            % Check data block ending indicators. If the current data block ends, break the while.
                            if ~ischar(tLine), isNewData = true; continue; end

                            findTextGdb = regexp(tLine, 'gdb = std::vector of length','tokens', 'once');
                            if ~isempty(findTextGdb), isNewData = true; continue; end

                            findTextDollar = regexp(tLine, '\$([\d]+) = std::vector of length','tokens', 'once');
                            if ~isempty(findTextDollar)
                                if str2double(findTextDollar{1}) ~= indCommand
                                    isNewData = true;
                                end
                            end
                        end

                        if cnt ~= numElsStdVec
                            error('Dimension Error: Occurrence of Eigen::Matrix is not equal the sum of std::vector elements!');
                        else  % Full data collected
                            % Go back to first line of the data
                            fseek(fid,posFid,'bof');
                            tLine = tLineTmp;
                        end
                    end

                    dimEigMat = max(dimEigMatInVec);

                    % Dimension of the data. Eigen::Matrix column-weise. Eigen data is the innermost
                    dimAll = [dimStdVec.', fliplr(dimEigMat)];   % use this format vector(outer)..vector(inner),Eigen::Matrix.numCols,Eigen::Matrix.numRows is to preserve column dimension by preventing auto-squeezing in Matlab
                    numDimAll = length(dimAll);

                    % Initialize Variables
                    logData = zeros(prod(dimAll),1);
                    isFound = true;
                    isComplete = false;
                    cntData = 1; % number of elements of current Eigen::Matrix may be different from maximum number of elements among all Eigen::Matrix
                    cntVec = 1;
                end

                if isFound
                    [~,fileName,~] = fileparts(logFile{iFile});
                    varPrint = regexp(tLinePrev, '^+p(?=rint)* ([\w\d]+)', 'tokens', 'once');
                    if isempty(varPrint)
                        fname = [fileName, '_var', num2str(indCommand), '.mat'];
                        disp(['Data $',num2str(indCommand),' is found! Start converting ...']);
                    else
                        fname = [fileName, '_', varPrint{1}, '.mat'];
                        disp(['Data $',num2str(indCommand),' ',varPrint{1},' is found! Start converting ...']);
                    end
                    
                end
            end

            if isFound  % If data block is found

                if isOneline % No need to read next lines; support different dims in different std::vector

                    positionEigenMatrix = regexp(tLine, 'Eigen::Matrix<[\w:<>]+,([\d]+),([\d]+),[\w]+>');
                    
                    %

                    indLogData = 1;
                    for iDimVec = 1:numElsStdVec
                        resValue = regexp(tLine, '\[([\d]+)(?:[,\d]+)*\] = {_M_value = ([\d.-]+)(?: \+ )*([\d.-]+)*(?: \* I)*|\[([\d]+)\] = ([\d.-]+)', 'tokens');
                    end

                else
                    % Check if out of data block
                    findTextDollar = regexp(tLine, '\$([\d]+) = std::vector of length','tokens', 'once');
                    if ~isempty(findTextDollar)
                        if str2double(findTextDollar{1}) ~= indCommand
                            isFound = false;
                            disp('Error: data block terminates.');
                        end
                    end

                    findTextGdb = regexp(tLine, 'gdb = std::vector of length', 'once');
                    if ~isempty(findTextGdb)
                        isFound = false;
                        disp('Error: data block terminates.');
                    end
                    
                    % Capture Eigen::Matrix data.
                    % Pattern 1 - vector with real valued data:    Eigen::Matrix<int,864,1,ColMajor> (data ptr: 0x25276f0) = {[0] = 3"                                                                                % for one-column data, [0] instead of [0,0]
                    % Pattern 2 - vector with complex-valued data: Eigen::Matrix<std::complex<double>,144,1,ColMajor> (data ptr: 0x1d5a2f0) = {[0] = {_M_value = 0.44140625 + -0.8759765625 * I"                      % _M_value is present for complex-valued data
                    % Pattern 3 - matrix with complex-valued data: Eigen::Matrix<std::complex<double>,288,2,ColMajor> (data ptr: 0x1d927c0) = {[0,0] = {_M_value = 0.21752604580125023 + -0.43954164224987846 * I"
                    % Note 1: For column data, the second element of resValue is empty.
                    % Note 2: For real-valued data, the fourth element of resValue is empty.
                    resValue = regexp(tLine, '\[([\d]+)(?:,)?([\d]+)*\][\s]*=[\s]*(?:{_M_value[\s]*=[\s]*)?([\d.-]+)(?:[\s]*\+[\s]*)*([\d.-]+)*(?:[\s]*\*[\s]*I)*', 'tokens');

                    if ~isempty(resValue)
                        if length(resValue) ~= 1  % For multi-line data, only one element is present on each line.
                            isFound = false;
                            disp('Error: For multi-line data, only one data appears on each line!');
                            continue;
                        end

                        if isempty(resValue{1}{2})
                            currColInd = 1;
                        else
                            currColInd = str2double(resValue{1}{2}) + 1;
                        end

                        if cntData == 1
                            prevRowInd = dimEigMatInVec(cntVec,1);
                            currRowInd = 1;
                        else
                            prevRowInd = currRowInd;
                            currRowInd = str2double(resValue{1}{1}) + 1;
                        end

                        if cntData ~= (cntVec-1)*prod(dimEigMat) + (currColInd-1)*dimEigMat(1) + currRowInd % Track global counter and the corresponding index in a column
                            isFound = false;
                            disp("Error: Log data index doesn't match due to data incomplete!");
                            continue;
                        end

                        if prevRowInd > currRowInd && prevRowInd ~= dimEigMatInVec(cntVec,1) % New column, check if lack of Eigen::Matrix column data
                            isFound = false;
                            disp(['Error: The ', num2str(cntVec), ' std::vector has not enough data!']);
                            continue;
                        end

                        % Write Data, complex-valued or real-valued
                        if isempty(resValue{1}{4}) % Real-valued
                            logData(cntData) = str2double(resValue{1}{3});
                        else % Complex-valued
                            logData(cntData) = str2double(resValue{1}{3}) + 1i * str2double(resValue{1}{4});
                        end
                        cntData = cntData + 1;

                        % Increase index and check if enough data for this Eigen::Matrix column
                        if mod(cntData-1, dimEigMat(1)) == dimEigMatInVec(cntVec,1) || mod(cntData-1, dimEigMat(1)) == 0 % Enough data for this column
                            cntData = cntData + dimEigMat(1) - dimEigMatInVec(cntVec,1);
                            currRowInd = dimEigMat(1);
                            if currColInd == dimEigMatInVec(cntVec,2)  % If the last column in the std::vector, increase std::vector index
                                cntVec = cntVec + 1;
                            end
                            
                            % Check if all data are captured
                            if cntVec == numElsStdVec + 1
                                isComplete = true;
                            end
                        end
                    end
                end
                
                % If data is complete in this data block
                if isComplete
                    % Reshape Data Back to Origin Dimensions
                    if numDimAll > 1
                        % Note: reshape will sequeeze out one-dim
                        logData = reshape(logData, fliplr(dimAll));
                        logData = permute(logData, [length(size(logData)):-1:3,1,2]);
                        logData = reshape(logData, [dimStdVec.',dimEigMat]);
                    end

                    % Write into .mat file
                    disp('Conversion done successfully!');
                    %dimEigMatInVec
                    save(fname,'logData');

                    % Reset parameters
                    isFound = false;
                    isComplete = false;
                    isOneline = false;
                end
            end

            % Read the New Line
            tLine = fgetl(fid);

        end

    end

    fclose(fid);

end

end