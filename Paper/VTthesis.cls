% VTthesis.cls - Provides a class for theses and dissertations
% Copyright (C) 2016,2017 Alan M. Lattimer
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
%
% Please see the GNU General Public License: <http://www.gnu.org/licenses/>.
%
%-------------------------------------------------------------------------
% Revision Information
%   v1.0 Adapted Thesis class written by Erich L. Foster, 10 April 2012
%   v1.1 Modifications by Alan Lattimer, 1/29/16
%   v1.2 Fixed TOC problems, Alan Lattimer, 3/24/16
%   v1.2 Fixed missing package problems, Alan Lattimer, 4/5/16
%   v1.4 Added the ability to change the institution, 8/16/16
%   v1.5 Added a flag to prevent page skips after the front matter, 5/2/17
%   v1.6 Added List of Abbreviations, Carrie Cross, 9/8/17
%   v1.7 Fixed excess whitespace problems, Carrie Cross & LianTze Lim, 9/20/17
%   v1.8 Modified date-setting macro, Carrie Cross, 10/5/17
%	v1.9 Changed the LaTex rendering engine, Carrie Cross & Robert Browder, 4/27/18
%	v2.0 Updated instructions, Carrie Cross & Robert Browder, 4/30/18
%   v2.1 Created flexible page numbering for front matter, Carrie Cross & Robert Browder, 12/19/19
%   v2.2 Updated code for disabling ligatures to comply with Tex Live 2019 standards, Carrie Cross & LianTze Lim, 5/8/2020
%-------------------------------------------------------------------------

%%% IDENTIFICATION --------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}[01/01/10]
\ProvidesClass{VTthesis}[2017/05/02 v1.5 Virginia Tech Proposal and Thesis Class]
\RequirePackage{etoolbox}
%Declaration of options
\newbool{@sig}
\boolfalse{@sig}
\newbool{@proposal}
\boolfalse{@proposal}
\newbool{@prelim}
\boolfalse{@prelim}
\newbool{@dbl}
\boolfalse{@dbl}
\newbool{@dft}
\boolfalse{@dft}
\newbool{@nopgskip}
\boolfalse{@nopgskip}

\DeclareOption{sig}{\booltrue{@sig}}
\DeclareOption{nosig}{\boolfalse{@sig}}
\DeclareOption{proposal}{\booltrue{@proposal}}
\DeclareOption{prelim}{\booltrue{@prelim}}
\DeclareOption{doublespace}{\booltrue{@dbl}}
\DeclareOption{draft}{\booltrue{@dft}}
\DeclareOption{nopageskip}{\booltrue{@nopgskip}}
%%% EXECUTION OF OPTIONS --------------------------------------------------
%% default to:
\ExecuteOptions{nosig}

\ProcessOptions

%%% PACKAGE LOADING -------------------------------------------------------
%% based on standard report class
\LoadClass[12pt,letterpaper,twoside]{report}

%% AMSLaTeX math environments and symbols
\RequirePackage{amsmath,amsthm,amssymb,amsfonts}
\RequirePackage[normalem]{ulem}
\RequirePackage{enumerate}
%\RequirePackage[numbers,sort]{natbib}
\RequirePackage{paralist}
\RequirePackage[titletoc,page]{appendix}
\RequirePackage[nottoc]{tocbibind}
\usepackage{bm}

%Use the following code to disable ligatures:
\usepackage{fontspec}
\setmainfont[Ligatures={NoCommon,NoRare},SmallCapsFont=TeX Gyre Termes,SmallCapsFeatures={Letters=SmallCaps}]{Latin Modern Roman}

%package required for abbreviations page
\usepackage{nomencl}
\makenomenclature
\renewcommand{\nomname}{List of Abbreviations}

\setlength{\textwidth}{6.5in}
\setlength{\textheight}{8.5in}
\setlength{\evensidemargin}{0in}
\setlength{\oddsidemargin}{0in}
\setlength{\topmargin}{0in}

\setlength{\parindent}{0pt}
\setlength{\parskip}{0.1in}

% double space option
\RequirePackage{setspace}
\ifbool{@dbl}{\doublespace}{}

% links for references
\RequirePackage[final,colorlinks=true,allcolors=blue]{hyperref}

% For including pdf images: 
\usepackage{graphicx}
\usepackage{csquotes}
%\RequirePackage{float}

% MATLAB Code formattings
\RequirePackage{listings}
\RequirePackage{verbatim}


% Misc Packages
\RequirePackage{booktabs}
\RequirePackage[mathscr]{eucal}
\RequirePackage{tikz}
\usetikzlibrary{shapes,arrows}
\usepackage{todonotes}

% Packages required for subfigures
\usepackage{caption}
\usepackage{subcaption}

% Place a Draft Watermark, if a draft document
\ifbool{@dft}{
  % \cofeAm{0.7}{0.75}{2}{0}{0}
  \usepackage[firstpage]{draftwatermark}
  \SetWatermarkScale{1} % Smaller numbers decrease the size of the watermark text. Originally set to 6. 
  \SetWatermarkLightness{0.7}
}


% Define Theorems and such
\newtheorem{proposition}{Proposition}[chapter]
\newtheorem{theorem}[proposition]{Theorem}
\newtheorem{lemma}[proposition]{Lemma}
\newtheorem{corollary}[proposition]{Corollary}
\newtheorem{conjecture}[proposition]{Conjecture}

% Define style for definitions, etc.
\theoremstyle{definition}
\newtheorem{example}[proposition]{Example}
\newtheorem{definition}[proposition]{Definition}
\newtheorem{remark}[proposition]{Remark}
\newtheorem{algorithm}[proposition]{Algorithm}

\lstset{ % command to set programming language parameter(s)
frame=single,
  showstringspaces=false,
  showlines=false, %get rid of trailing white lines
  emptylines=1, %allow blank line
  breaklines=true, %get rid of overflow lines and enter \n
  numbers=left, %line number
  numberstyle=\scriptsize, %make line numbers small
  stepnumber=1, %line number every line
  numbersep=5pt,
  tabsize=2, %set tabs to two spaces
  basicstyle=\footnotesize, % print whole listing small
  keywordstyle=\bfseries,% green keywords
  stringstyle=\ttfamily % typewriter type for strings
  captionpos=b,% sets the caption-position to bottom
}

% \author,\title are defined in book; here are the rest of the front matter defining macros:
\def\@title{}
\def\@author{}
\def\@degree{Doctor of Philosophy}
\def\@program{Mathematics}
\def\@institution{Virginia Polytechnic Institute and State University}
\def\@instaddress{Blacksburg, Virginia}
\def\@submitdate{\the\day \space \ifcase\the\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space \number\the\year}

\def\type#1{\gdef\@type{#1}}
\def\degree#1{\gdef\@degree{#1}}
\def\program#1{\gdef\@program{#1}}
\def\institution#1{\gdef\@institution{#1}}
\def\instaddress#1{\gdef\@instaddress{#1}}
\def\submitdate#1{\gdef\@submitdate{#1}}

\ifnum\month>9
    \@tempcnta=\year 
    % Un-comment the following line to advance the date by one year:
    %\advance\@tempcnta by 1 
    \edef\@copyrightyear{\number\the\@tempcnta}
\else
    \def\@copyrightyear{\number\the\year}
\fi

%committee information
\newbool{@1st}
\boolfalse{@1st}
\newbool{@2nd}
\boolfalse{@2nd}
\newbool{@3rd}
\boolfalse{@3rd}
\newbool{@4th}
\boolfalse{@4th}
\newbool{@5th}
\boolfalse{@5th}
\newbool{@coad}
\boolfalse{@coad}
\def\@principaladvisor{}
\def\@coadvisor{}
\def\@firstreader{}
\def\@secondreader{}
\def\@thirdreader{}
\def\@fourthreader{}
\def\@fifthreader{}
\def\principaladvisor#1{\gdef\@principaladvisor{#1}}
\def\coadvisor#1{\booltrue{@coad} \gdef\@coadvisor{#1}}
\def\firstreader#1{\booltrue{@1st} \gdef\@firstreader{#1}}
\def\secondreader#1{\booltrue{@2nd} \gdef\@secondreader{#1}}
\def\thirdreader#1{\booltrue{@3rd} \gdef\@thirdreader{#1}}
\def\fourthreader#1{\booltrue{@4th} \gdef\@fourthreader{#1}}
\def\fifthreader#1{\booltrue{@5th} \gdef\@fifthreader{#1}}

%abstract, acknowledgements, dedication, and keywords setup
\def\@abstract{}
\def\@abstractgenaud{}
\def\@acknowledge{}
\def\@dedication{}
\def\@keywords{}
\newbool{@key}
\boolfalse{@key}
\newbool{@abs}
\boolfalse{@abs}
\newbool{@gaa}
\boolfalse{@gaa}
\newbool{@ack}
\boolfalse{@ack}
\newbool{@ded}
\boolfalse{@ded}
\def\abstract#1{\booltrue{@abs} \gdef\@abstract{#1}}
\def\abstractgenaud#1{\booltrue{@gaa} \gdef\@abstractgenaud{#1}}
\def\acknowledge#1{\booltrue{@ack} \gdef\@acknowledge{#1}}
\def\dedication#1{\booltrue{@ded} \gdef\@dedication{#1}}
\def\keywords#1{\booltrue{@key} \gdef\@keywords{#1}}

\newcommand{\@vtcopyright}{Copyright \@copyrightyear, \@author}

% Set up the header and footer
\RequirePackage{fancyhdr}
\setlength{\headheight}{15pt}
\pagestyle{fancy}

\renewcommand{\chaptermark}[1]{ \markboth{\chaptername \ \thechapter.\ #1}{}}
\renewcommand{\sectionmark}[1]{\markright{\thesection.\ #1}}

%Set up up frontmatter, mainmatter, backmatter...
%The formatting for these sections will be different.
\newcommand{\frontmatter}{
  \ifbool{@nopgskip}
    {\clearpage}
    {\cleardoublepage}
  \clearpage
  \pagenumbering{roman} % defines page number style for front matter
  \fancyhead[L,R]{}
  \ifbool{@dft}{\fancyhead[C]{\textbf{DRAFT}}}{\fancyhead[C]{}}
  \fancyfoot[C]{\thepage}
  \fancyfoot[L,R]{}
  \renewcommand\headrulewidth{0.0pt}}
  
\newcommand{\mainmatter}{
  \ifbool{@nopgskip}
    {\clearpage}
    {\cleardoublepage}
  \pagenumbering{arabic} % defines page number style for main matter
  \fancyhead[LE,RO]{\thepage}
  \fancyhead[RE]{\sc \leftmark}
  \fancyhead[LO]{\sc \rightmark}
  \ifbool{@dft}{\fancyfoot[C]{\textbf{DRAFT}}}{\fancyfoot[C]{}}
  \renewcommand\headrulewidth{0.0pt}}
  
\newcommand{\biblio}{
  \fancyhead[C]{\bibname}}
  
\newcommand{\backmatter}{
  \ifbool{@nopgskip}
    {\clearpage}
    {\cleardoublepage}
  \addappheadtotoc
  \renewcommand{\chaptername}{\appendixname}
}

\apptocmd{\appendix}{\backmatter}{}{}

%Set up title page, abstract page, dedication page, and acknowledgement page
\def\titlepage{
  \thispagestyle{empty}
  \begin{center}
  {\Large \@title}\\
  \vfill
  \rm \@author\\
  \vfill

  \ifbool{@proposal}{
    \noindent Thesis proposal for}
    {\ifbool{@prelim}
      {\noindent Preliminary Exam}
      {\noindent Thesis submitted to the Faculty of \\
        \@institution \\
        in partial fulfillment of the requirements for the degree of \\}
    }

  \vfill
  \@degree \\
  in \\
  \@program \\
  \vfill

  \noindent \@principaladvisor, \ifbool{@coad}{Co-c}{C}hair \\
  \ifbool{@coad}{\@coadvisor, Co-chair\\}{}
  \ifbool{@1st}{\@firstreader\\}{}
  \ifbool{@2nd}{\@secondreader\\}{}
  \ifbool{@3rd}{\@thirdreader\\}{}
  \ifbool{@4th}{\@fourthreader\\}{}
  \ifbool{@5th}{\@fifthreader\\}{}
  \vfill

  \@submitdate\\
  \@instaddress\\

  \ifbool{@key}{\vfill
    Keywords: \@keywords\\}{}

  \@vtcopyright \\

  \end{center}

  \newpage % This applies to the numbering of the front matter.
  \addtocounter{page}{1} 
}

\def\abspage{
\pagestyle{empty} % Suppresses page numbers for all abstract pages.
  \noindent {\Large \@title} \\
    
  \vfill
  \noindent  \@author \\
  \vfill

  (ABSTRACT)
  \vfill

  \@abstract
  \vfill
 \newpage

}

\def\absgapage{
\pagestyle{empty} % Suppresses page numbers for all general audience abstract pages.
  \noindent {\Large \@title} \\

  \vfill
  \noindent  \@author \\
  \vfill

  (GENERAL AUDIENCE ABSTRACT)
  \vfill
  \@abstractgenaud
  \newpage

}

\def\ackpage{
  \chapter*{Acknowledgments}
  \@acknowledge
  \newpage
}

\def\dedpage{
\pagestyle{fancy} % Restores all page numbers going forward, beginning at the dedication.
\chapter*{Dedication}
  \vspace*{\fill}
  \begingroup
  \begin{center}
    \emph{\@dedication}
  \end{center}
  \endgroup
  \vspace*{\fill}
  \newpage
}

%This is where the main magic happens.
\renewcommand\maketitle{
  \setcounter{page}{0}
  \pdfbookmark[1]{Titlepage}{titlepage}
  \titlepage
  \ifbool{@abs}{
    \pdfbookmark[1]{Abstract}{abstract}
    \abspage}{}
  \ifbool{@gaa}{
    \pdfbookmark[1]{General Audience Abstract}{abstractgenaud}
    \absgapage}{}
  \ifbool{@ded}{
    \pdfbookmark[1]{Dedication}{dedication}
    \dedpage}{}
  \ifbool{@ack}{
    \pdfbookmark[1]{Acknowledgements}{acknowledgements}
    \ackpage}{}
}

\patchcmd{\@makechapterhead}{\vspace*{50\p@}}{}{}{}  %% for numbered chapters \chapter{...}
\patchcmd{\@makeschapterhead}{\vspace*{50\p@}}{}{}{} %% for unnumbered chapters \chapter*{...}
