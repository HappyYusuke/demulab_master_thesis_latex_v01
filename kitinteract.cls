%%
%% kitinteract.cls
%% Switchable class for:
%%  - Kanazawa Institute of Technology (KIT) Master's thesis (thesis mode)
%%  - Taylor & Francis Interact / Advanced Robotics submission (ar mode)
%%
%% Usage:
%%   \documentclass[thesis]{kitinteract}  % KIT thesis PDF
%%   \documentclass[ar]{kitinteract}      % Advanced Robotics PDF (interact.cls)
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kitinteract}[2026/01/08 v0.9.2 KIT thesis / Interact switchable class]


\newif\ifkit@ar
\newif\ifkit@thesis
\newif\ifkit@maplevels
\kit@thesistrue
\kit@maplevelsfalse

% --- Options ---
\DeclareOption{ar}{\kit@artrue\kit@thesisfalse}
\DeclareOption{thesis}{\kit@thesistrue
\kit@maplevelsfalse\kit@arfalse}

% Pass-through options
\DeclareOption*{%
  \ifkit@ar
    \PassOptionsToClass{\CurrentOption}{interact}%
  \else
    \PassOptionsToClass{\CurrentOption}{report}%
  \fi
}
\ProcessOptions\relax

% Needed early because this class defines commands using \NewDocumentCommand.
\RequirePackage{xparse}
\RequirePackage{etoolbox}

% Default level mapping: ON in ar mode unless disabled
\ifkit@ar\ifkit@maplevels\else\kit@maplevelstrue\fi\fi


% Convenience conditionals for authors
\newcommand{\thesisonly}[1]{\ifkit@thesis#1\fi}
\newcommand{\aronly}[1]{\ifkit@ar#1\fi}
\newcommand{\KITifThesis}[2]{\ifkit@thesis#1\else#2\fi}
\newcommand{\KITifAR}[2]{\ifkit@ar#1\else#2\fi}

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% Thesis<->Journal structural mapping helpers
% -----------------------------------------------------------------------------
% Use these wrappers if you want a single .tex to compile cleanly as:
%  - KIT thesis (chapter-based, report class)
%  - Advanced Robotics paper (section-based, interact class)
%
% Starred + optional short titles are supported:
%   \kitchapter{Long Title}
%   \kitchapter[Short]{Long Title}
%   \kitchapter*{Unnumbered}
%
\NewDocumentCommand{\kitchapter}{s o m}{%
  \IfBooleanTF{#1}{%
    \KITifThesis{\chapter*{#3}}{\section*{#3}}%
  }{%
    \KITifThesis{%
      \IfNoValueTF{#2}{\chapter{#3}}{\chapter[#2]{#3}}%
    }{%
      \IfNoValueTF{#2}{\section{#3}}{\section[#2]{#3}}%
    }%
  }%
}

\NewDocumentCommand{\kitsection}{s o m}{%
  \IfBooleanTF{#1}{%
    \KITifThesis{\section*{#3}}{\subsection*{#3}}%
  }{%
    \KITifThesis{%
      \IfNoValueTF{#2}{\section{#3}}{\section[#2]{#3}}%
    }{%
      \IfNoValueTF{#2}{\subsection{#3}}{\subsection[#2]{#3}}%
    }%
  }%
}

\NewDocumentCommand{\kitsubsection}{s o m}{%
  \IfBooleanTF{#1}{%
    \KITifThesis{\subsection*{#3}}{\subsubsection*{#3}}%
  }{%
    \KITifThesis{%
      \IfNoValueTF{#2}{\subsection{#3}}{\subsection[#2]{#3}}%
    }{%
      \IfNoValueTF{#2}{\subsubsection{#3}}{\subsubsection[#2]{#3}}%
    }%
  }%
}

\NewDocumentCommand{\kitsubsubsection}{s o m}{%
  \IfBooleanTF{#1}{%
    \KITifThesis{\subsubsection*{#3}}{\paragraph*{#3}}%
  }{%
    \KITifThesis{%
      \IfNoValueTF{#2}{\subsubsection{#3}}{\subsubsection[#2]{#3}}%
    }{%
      \IfNoValueTF{#2}{\paragraph{#3}}{\paragraph[#2]{#3}}%
    }%
  }%
}

\NewDocumentCommand{\kitparagraph}{s o m}{%
  \IfBooleanTF{#1}{%
    \KITifThesis{\paragraph*{#3}}{\subparagraph*{#3}}%
  }{%
    \KITifThesis{%
      \IfNoValueTF{#2}{\paragraph{#3}}{\paragraph[#2]{#3}}%
    }{%
      \IfNoValueTF{#2}{\subparagraph{#3}}{\subparagraph[#2]{#3}}%
    }%
  }%
}


% -----------------------------------------------------------------------------
% Shared metadata interface (works in both modes)
% -----------------------------------------------------------------------------

% -----------------------------------------------------------------------------
% Optional: 1-page front note (before cover / title)
% -----------------------------------------------------------------------------
% Use in main.tex:
%   \frontnote{0_frontnote.tex}
% Then the page is inserted automatically by \makefrontmatter in both modes.
%
% Formatting policy:
% - Same formatting for thesis and AR modes
% - Tight line spacing ONLY on this single page (does not affect the body)
%
\newcommand\kit@frontnote{}
\newcommand{\frontnote}[1]{\gdef\kit@frontnote{#1}}

\newcommand{\makefrontnote}{%
  \ifstrempty{\kit@frontnote}{}{%
    \clearpage
    \begingroup
      \thispagestyle{empty}%
      \setlength{\parindent}{0pt}%
      \setlength{\parskip}{0.35\baselineskip}%
      \linespread{0.92}\selectfont% tight spacing (front note only)
      \small
      \input{\kit@frontnote}%
    \endgroup
    \clearpage
  }%
}

\newcommand\kit@university{Kanazawa Institute of Technology}
\newcommand\kit@degree{Master's Thesis}
\newcommand\kit@faculty{Graduate School of Engineering}
\newcommand\kit@department{Mechanical Engineering}
\newcommand\kit@major{}
\newcommand\kit@title{}
\newcommand\kit@author{}
\newcommand\kit@studentid{}
\newcommand\kit@supervisor{Prof. Kosei Demura}
\newcommand\kit@date{}


\newcommand\kit@abstract{}
\newcommand\kit@keywords{}

% --- KIT cover logo (thesis mode only) ---
% Default filename is KIT_kosho.eps (auto-skipped if not found).
\newcommand\kit@logo{KIT_kosho.eps}
\newlength\kit@logowidth
\setlength\kit@logowidth{24mm}
\newcommand{\kitlogo}[1]{\gdef\kit@logo{#1}}
\newcommand{\kitlogowidth}[1]{\setlength\kit@logowidth{#1}}

\newcommand{\kitabstract}[1]{\gdef\kit@abstract{#1}}
\newcommand{\kitkeywords}[1]{\gdef\kit@keywords{#1}}

\newcommand{\kituniversity}[1]{\gdef\kit@university{#1}}
\newcommand{\kitdegree}[1]{\gdef\kit@degree{#1}}
\newcommand{\kitfaculty}[1]{\gdef\kit@faculty{#1}}
\newcommand{\kitdepartment}[1]{\gdef\kit@department{#1}}
\newcommand{\kitmajor}[1]{\gdef\kit@major{#1}}

\newcommand{\kittitle}[1]{\gdef\kit@title{#1}\aronly{\title{#1}}}
\newcommand{\kitauthor}[1]{\gdef\kit@author{#1}\aronly{\author{#1}}}
\newcommand{\kitstudentid}[1]{\gdef\kit@studentid{#1}}
\newcommand{\kitsupervisor}[1]{\gdef\kit@supervisor{#1}}
\newcommand{\kitsubmissiondate}[1]{\gdef\kit@date{#1}}

% -----------------------------------------------------------------------------
% Mode-specific implementations
% -----------------------------------------------------------------------------
\ifkit@ar
  % =======================
  % Advanced Robotics mode
  % =======================
  % NOTE: do NOT forward kitinteract-specific options (e.g., [ar]) to interact.cls.
  % Unknown options intended for interact.cls are forwarded via \DeclareOption*.
  \LoadClass{interact}

  % ---------------------------------------------------------------------------
  % Compatibility patch for interact.cls + modern LaTeX / enumitem
  %
  % Some versions of interact.cls redefine \small in a way that accidentally
  % redefines the internal macro \@list, which then breaks list-like
  % environments (e.g., center/itemize/enumerate) with errors such as:
  %   "Use of \@list doesn't match its definition."
  % We defensively restore the kernel \@list right after each \small.
  % ---------------------------------------------------------------------------
  \let\kit@kernel@list\@list
  \let\kit@interact@small\small
  \renewcommand\small{%
    \kit@interact@small
    \let\@list\kit@kernel@list
  }

  

% -----------------------------------------------------------------------------
% Automatic level mapping in ar mode (optional)
% -----------------------------------------------------------------------------
% In ar mode, if maplevels is enabled (default: ON), we shift thesis-style levels:
%   \chapter      -> \section
%   \section      -> \subsection
%   \subsection   -> \subsubsection
%   \subsubsection-> \paragraph
%
% This allows a thesis-written source (using \chapter/\section/...) to compile
% as an Advanced Robotics paper without rewriting headings.
%
\ifkit@ar
\ifkit@maplevels
  \let\KIT@orig@section\section
  \let\KIT@orig@subsection\subsection
  \let\KIT@orig@subsubsection\subsubsection
  \let\KIT@orig@paragraph\paragraph

  % Define \chapter for interact (it doesn't exist in article-like classes)
  \NewDocumentCommand{\chapter}{s o m}{%
    \IfBooleanTF{#1}{%
      \KIT@orig@section*{#3}%
    }{%
      \IfNoValueTF{#2}{\KIT@orig@section{#3}}{\KIT@orig@section[#2]{#3}}%
    }%
  }

  % Shift the remaining levels down by one
  \RenewDocumentCommand{\section}{s o m}{%
    \IfBooleanTF{#1}{%
      \KIT@orig@subsection*{#3}%
    }{%
      \IfNoValueTF{#2}{\KIT@orig@subsection{#3}}{\KIT@orig@subsection[#2]{#3}}%
    }%
  }

  \RenewDocumentCommand{\subsection}{s o m}{%
    \IfBooleanTF{#1}{%
      \KIT@orig@subsubsection*{#3}%
    }{%
      \IfNoValueTF{#2}{\KIT@orig@subsubsection{#3}}{\KIT@orig@subsubsection[#2]{#3}}%
    }%
  }

  \RenewDocumentCommand{\subsubsection}{s o m}{%
    \IfBooleanTF{#1}{%
      \KIT@orig@paragraph*{#3}%
    }{%
      \IfNoValueTF{#2}{\KIT@orig@paragraph{#3}}{\KIT@orig@paragraph[#2]{#3}}%
    }%
  }
\fi
\fi

% If level mapping is disabled, still provide \chapter as a thin alias of \section.
\ifkit@maplevels\else
  \ProvideDocumentCommand{\chapter}{s o m}{%
    \IfBooleanTF{#1}{%
      \section*{#3}%
    }{%
      \IfNoValueTF{#2}{\section{#3}}{\section[#2]{#3}}%
    }%
  }
\fi

% Minimal compatibility so one source can compile in both modes.
  % In ar mode, we downgrade report-style structure to article-style.
  \providecommand{\frontmatter}{}
  \providecommand{\mainmatter}{}
  \providecommand{\backmatter}{}

  % Thesis front matter commands become no-ops in ar mode.
  \newcommand{\makekitcover}{\ClassWarning{kitinteract}{\string\makekitcover ignored in ar mode. Use \string\maketitle etc.}}
  \newcommand{\makekitfrontmatter}{\relax}


% Unified front matter for ar mode (title + abstract + keywords, if provided)
\newcommand{\makearfrontmatter}{%
  \makefrontnote
  \maketitle
  \ifstrempty{\kit@abstract}{}{%
    \begin{abstract}\kit@abstract\end{abstract}%
  }%
  \ifstrempty{\kit@keywords}{}{%
    \begin{keywords}\kit@keywords\end{keywords}%
  }%
}
\newcommand{\makefrontmatter}{\makearfrontmatter}

  % A helper to include the publications page as a normal unnumbered section.
  \newcommand{\publicationspage}[1]{%
    \section*{Publications Related to This Thesis}%
    #1%
  }

\else
  % =================
  % KIT thesis mode
  % =================
  \LoadClass[12pt,a4paper,oneside]{report}

  \RequirePackage[left=30mm,right=30mm,top=30mm,bottom=30mm]{geometry}
  \RequirePackage{setspace}
  \RequirePackage{graphicx}
  \RequirePackage{iftex}
  % Allow including EPS (e.g., KIT_kosho.eps) when compiling with pdfLaTeX.
  % (Requires restricted \write18; otherwise convert EPS->PDF manually.)
  \ifPDFTeX
    \RequirePackage{epstopdf}
    \epstopdfsetup{update}
  \fi
  \RequirePackage{titlesec}
  \RequirePackage{tocloft}
  \RequirePackage{hyperref}

  % Line spacing: thesis-friendly default
  \onehalfspacing

  % Basic paragraph layout
  \setlength{\parindent}{1em}
  \setlength{\parskip}{0pt}

  % Cover logo printer (skips if empty or file not found)
  \newcommand{\kit@printlogo}{%
    \ifstrempty{\kit@logo}{}{%
      \IfFileExists{\kit@logo}{%
        \includegraphics[width=\kit@logowidth]{\kit@logo}\par
        \vspace{12mm}%
      }{%
        \ClassWarning{kitinteract}{Logo file `\kit@logo` not found. Skipping.}%
      }%
    }%
  }

  % Headings (simple, readable)
  \titleformat{\chapter}{\normalfont\Large\bfseries}{\thechapter.}{1em}{}
  \titleformat{\section}{\normalfont\large\bfseries}{\thesection}{1em}{}
  \titleformat{\subsection}{\normalfont\normalsize\bfseries}{\thesubsection}{1em}{}
  % ToC / LoF / LoT use default spacing (no forced 1-page constraint)
  \renewcommand{\cftchapfont}{\normalfont}
  \renewcommand{\cftchappagefont}{\normalfont}

  % Book-like front/main/back matter helpers
  \newcommand{\frontmatter}{%
    \clearpage
    \pagenumbering{roman}%
  }
  \newcommand{\mainmatter}{%
    \clearpage
    \pagenumbering{arabic}%
  }
  \newcommand{\backmatter}{\clearpage}

  % Cover page
  \newcommand{\makekitcover}{%
    \begin{titlepage}
      \thispagestyle{empty}
      \centering
      \vspace*{15mm}
      \kit@printlogo
      {\Large \kit@university\par}
      \vspace{6mm}
      \ifstrempty{\kit@faculty}{}{\large \kit@faculty\par}
      \ifstrempty{\kit@department}{}{\large \kit@department\par}
      \ifstrempty{\kit@major}{}{\large \kit@major\par}
      \vspace{12mm}
      {\Large \kit@degree\par}
      \vspace{20mm}
      {\LARGE\bfseries \kit@title\par}
      \vfill
      {\large \kit@author\par}
      \ifstrempty{\kit@studentid}{}{\vspace{2mm}{\large Student ID: \kit@studentid\par}}
      \vspace{6mm}
      \ifstrempty{\kit@supervisor}{}{\large Supervisor: \kit@supervisor\par}
      \vspace{10mm}
      \ifstrempty{\kit@date}{}{\large \kit@date\par}
    \end{titlepage}
  }

  % One-call front matter generator:
  % Cover (1p) + ToC (1p) + LoF (1p) + LoT (1p)
  
% Abstract page (English only) for thesis mode
\newcommand{\makekitabstract}{%
  \clearpage
  \chapter*{Abstract}
  \addcontentsline{toc}{chapter}{Abstract}
  \kit@abstract\par
  \ifstrempty{\kit@keywords}{}{%
    \vspace{1em}\noindent\textbf{Key words:} \kit@keywords\par
  }%
  \clearpage
}

% One-call front matter generator:
% Cover (1p) + Abstract (if provided) + ToC + LoF + LoT
\newcommand{\makekitfrontmatter}{%
  \makefrontnote
  \makekitcover
  \frontmatter
  \setcounter{page}{1}% start roman numbering at i
  \ifstrempty{\kit@abstract}{}{\makekitabstract}%
  \tableofcontents\clearpage
  \listoffigures\clearpage
  \listoftables\clearpage
}
\newcommand{\makefrontmatter}{\makekitfrontmatter}


  % Publications page (typically 1 page)
  \newcommand{\publicationspage}[1]{%
    \clearpage
    \chapter*{Publications Related to This Thesis}
    \addcontentsline{toc}{chapter}{Publications Related to This Thesis}
    #1
    \clearpage
  }
\fi

% --- Force bibliography heading to "References" in both thesis (book-like) and AR (article-like) modes ---
% BibTeX uses \refname (article-like) or \bibname (book-like) for the heading.
% Some classes define these late; to be robust, we define/override at \begin{document}.
\AtBeginDocument{%
  \@ifundefined{refname}{\gdef\refname{References}}{\renewcommand{\refname}{References}}%
  \@ifundefined{bibname}{\gdef\bibname{References}}{\renewcommand{\bibname}{References}}%
}

\endinput

