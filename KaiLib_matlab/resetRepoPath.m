function resetRepoPath()
% Work between different git worktree. Require to have same main-part name.

rootDir = 'path\to\algo-exploration';
currentPath = path;

%%% remove all "algo-exploration" related path
pathParts = strsplit(currentPath, pathsep);
keepPaths = pathParts(~startsWith(pathParts, rootDir));

%%% add the "algo-exporation" of the current inside repo and all its subdirectories
repoRoot = findGitRoot();
repoPath = strsplit(genpath(repoRoot), pathsep);
repoPath = repoPath(~cellfun(@isempty, repoPath)); % remove empties
keepPaths = [repoPath, keepPaths];

%%% Apply new path
path(strjoin(keepPaths, pathsep));
savepath;
rehash toolboxcache;

end
