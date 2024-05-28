function waitingBar(ind,iter,mode,testMode)

% mode 1: display hints every 1%
% mode 2: display hints every 5%
% mode 3: display hints every 10%

if nargin < 4, testMode = 0; end
if nargin < 3, mode = 3; end

if iter<100 && iter>=50
    if mode==1
        warning('Change to "display hints every 5%"');
        mode = 2;
    end
elseif iter<20
    if mode==1 || mode==2
        warning('Change to "display hints every 10%"');
        mode = 3;
    end
end

switch mode
    case 1
        indShow = 1:100;
    case 2
        indShow = 5:5:100;
    case 3
        indShow = 10:10:100;
    otherwise
end

indShowAbs = round(0.01*indShow*iter);
indShowPer = floor(ind/iter*100/10);
dispText = '|';
for i = 1:indShowPer
    dispText = [dispText,'x|'];
end
for i = 1:10-indShowPer
    dispText = [dispText,'_|'];
end

if testMode
    disp([dispText,' ',num2str(indShowPer),'%']);
else
    comp = ind == indShowAbs;
    if any(comp)
        disp([dispText,' ',num2str(indShowAbs(comp)),'%']);
    end
end

% EOF
end