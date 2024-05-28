function res = FIGUREOPT (optname, optval)

if nargin<2,optval=0;end
if optname == "marker"
    switch optval
        case 0
            res = 'o+*.xsd^v><ph';
        case 1
            res = 'o';	% Circle
        case 2
            res = '+';	% Plus sign
        case 3
            res = '*';	% Asterisk
        case 4
            res = '.';	% Point
        case 5
            res = 'x';	% Cross
        case 6
            res = 's';	% Square
        case 7
            res = 'd';	% Diamond
        case 8
            res = '^';	% Upward-pointing triangle
        case 9
            res = 'v';	% Downward-pointing triangle
        case 10
            res = '>';	% Right-pointing triangle
        case 11
            res = '<';	% Left-pointing triangle
        case 12
            res = 'p';	% Pentagram
        case 13
            res = 'h';	% Hexagram
        otherwise
            error(['wrong ',optname,' option']);
    end
elseif optname == "color"
    switch optval
        case 0
            res = 'rgbcmyk';
        case 1
            res = 'r';	% red
        case 2
            res = 'g';	% green
        case 3
            res = 'b';	% blue
        case 4
            res = 'c';	% cyan
        case 5
            res = 'm';	% magenta
        case 6
            res = 'y';	% yellow
        case 7
            res = 'k';	% black
        otherwise
            error(['wrong ',optname,' option']);
    end
else
    error('wrong figure option');
end
end