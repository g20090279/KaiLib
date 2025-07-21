local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.t

return {
    -- 'tikz' is the trigger word
    s("tikz", {
        t({"\\documentclass{standalone}",""}),
        t({"\\usepackage{tikz}",""}),
        t({"\\begin{document}",""}),
        t({"\\begin{tikzpicture}",""}),
        t({"",""}),
        i(1, "%%% Your Tikz Code Here"),  -- Placeholder for the node content;
        t({"",""}),
        t({"",""}),
        t({"\\end{tikzpicture}",""}),
        t({"\\end{document}",""}),
    }),
}
