function rootDir = findGitRoot(startDir)
    % Start from given directory (e.g., location of startup.m)
    if nargin < 1
        startDir = pwd;
    end
    
    rootDir = startDir;
    while true
        if isfolder(fullfile(rootDir, '.git')) || isfile(fullfile(rootDir, '.git'))
            return;
        end
        parentDir = fileparts(rootDir);
        if strcmp(parentDir, rootDir)
            % Reached filesystem root without finding .git
            rootDir = '';
            return;
        end
        rootDir = parentDir;
    end
end