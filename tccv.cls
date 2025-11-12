% Copyright (C) 2012, 2013, 2021 Nicola Fontana <ntd at entidi.it>
%
% This program can be redistributed and/or modified under
% the terms of the LaTeX Project Public License, either
% version 1.3 of this license or (at your option) any later
% version. The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all LaTeX distributions
% version 2005/12/01 or later.
%
% Based on the original idea by Alessandro Plasmati found at
% http://www.latextemplates.com/template/two-column-one-page-cv

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tccv}
              [2021/12/16 v1.3.1
 Two Column Curriculum Vitae]

\LoadClass[10pt]{scrartcl}

\setcounter{secnumdepth}{-1}
\RequirePackage[hmargin=1.25cm,vmargin=1.25cm,twocolumn,columnsep=1.25cm]{geometry}
\RequirePackage{bookman,etoolbox,hyperref,marvosym,needspace,tabularx,xcolor, eso-pic}

% Capitalize words of at least a minimum length (default to 3 chars).
% The text is capitalized before being expanded.
% This macro uses Lua to do the job but fails gracefully (that is,
% return the text as is) if \directlua is not available.
\newcommand\ucwords[2][3]{%
    % Fails gracefully if not in LuaLaTeX
    \providecommand\directlua[1]{#2}%
    \directlua{%
    local minlen=tonumber("#1")
    local src="\luaescapestring{\unexpanded{#2}}"
    local dst={}
    for w in src:gmatch('[^\string\%s]+') do
        if w:len() >= minlen then w = w:sub(1,1):upper()..w:sub(2) end
        table.insert(dst, w)
    end
    tex.print(dst)}}

\pagestyle{empty}
\setlength\parindent{0pt}
\color[HTML]{303030} % Default foreground color
\definecolor{link}{HTML}{506060} % Hyperlinks
\hypersetup{colorlinks,breaklinks,urlcolor=link,linkcolor=link}
\setkomafont{disposition}{\color[HTML]{1111ec}}
\setkomafont{section}{\scshape\Large\mdseries}

% In tccv \part must contain the subject of the curriculum vitae.
% The command will start a new page and output in onecolumn the
% subject (first and last name) with the hardcoded text
% "Curriculum vitae" under it.
\renewcommand\part[1]{%
    \twocolumn[%
    \begin{center}
    \vskip-\lastskip%
    {\usekomafont{part} #1} \medskip\\
    \bigskip
    \end{center}]}

% Overrides the \section command to capitalize every
% word for cosmetic purposes and draws a rule under it.
\makeatletter
\let\old@section\section
\renewcommand\section[2][]{%
    \old@section[#1]{\ucwords{#2}}%
    \newdimen\raising%
    \raising=\dimexpr-0.3\baselineskip\relax%
    \vskip\raising\hrule height 0.4pt\vskip-\raising}
\makeatother

% Renders a personal data box:
% \personal[optional: web site]
%           {address}{email}{phone number}
\newcommand\personal[4][]{%
    \needspace{0.5\textheight}%
    \newdimen\boxwidth%
    \boxwidth=\dimexpr\linewidth-2\fboxsep\relax%
    \colorbox[HTML]{ffe599}{% Reverted color to user's original
    \begin{tabularx}{\boxwidth}{c|X}
    \Writinghand & {#2}\smallskip\\
    \Letter & \href{mailto:#3}{#3}
    \ifstrempty{#1}{}{\smallskip\\ \Industry & \href{#1}{#1}} % Reverted \Computer to \Industry
    \ifstrempty{#4}{}{\smallskip\\ \Telefon & {#4}}\\ % Changed to another common symbol
    \end{tabularx}}}

% \item{date range}{company}{role}
% Description of what achieved during this application.
\newenvironment{eventlist}{%
    \newcommand*\inskip{}
    \renewcommand\item[3]{% three items
        \inskip%
        {\raggedleft\textsc{##1}\\[1pt]} % dates, on the right 
        {##2}\\[2pt]                        % second item, the institution
        {\Large\textit{##3}}                % third item, the title
        \vspace{2pt}                        % space between each item
        \renewcommand\inskip{\vspace{1pt}}} %redefines inskip
    }

% \item[optional: what has been achieved]{years}{subject}{notes}
\newenvironment{yearlist}{%
    \renewcommand\item[4][]{%
    {\textsc{##2}} & {\bfseries ##3} \\
    \ifstrempty{##1}{}{& {\textsc{##1}} \\}
    & {\textit{##4}}\medskip\\}
    \tabularx{\linewidth}{rX}}
    {\endtabularx}

% \item{fact}{description}
\newenvironment{factlist}{%
    \newdimen\unbaseline
    \unbaseline=\dimexpr-\baselinestretch\baselineskip\relax
    \renewcommand\item[2]{%
    \textsc{##1} & {\raggedright ##2\medskip\\}\\[\unbaseline]}
    \tabularx{\linewidth}{rX}}
    {\endtabularx}

% Privacy disclaimer (GDPR consent) spanning across both columns
\newcommand{\privacyDisclaimer}{%
  \AddToShipoutPictureFG*{%
    \put(0,15){%
      \parbox[b][\paperheight][b]{\paperwidth}{%
        \centering
        \vspace{0.5em}
        {\fontsize{6.5 pt}{0pt}\selectfont 
        According to law 679/2016 of the Regulation of the European Parliament of 27th April 2016,\\[-5pt]
        I hereby express my consent to process and use my data provided in this CV and application for recruiting purposes.}
        \vspace{0.5em}
      }%
    }%
  }%
}

%%
%% End of file `tccv.cls'.