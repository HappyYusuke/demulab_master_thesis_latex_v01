# kitinteract.cls（KIT修士論文 ↔ Advanced Robotics 切替クラス）

## 目的
- **KIT修士論文PDF**（表紙・Abstract/Key words・目次・図目次・表目次・本文・参考文献・学術発表論文ページ）と、
- **Advanced Robotics投稿用PDF**（`interact.cls`）

を、**同じTeXソース**で `\documentclass` のオプションだけで切替できるようにするためのクラスです。

---

## 切替方法（最短）

### KIT修士論文PDF
```tex
\documentclass[thesis]{kitinteract}
```

### Advanced Robotics投稿用PDF（interact.cls）
```tex
\documentclass[ar]{kitinteract}
```

---

## 共通で一度だけ書く（推奨）

### Abstract / Key words（英語のみ）
本文ソースで **一度だけ**以下を書けば、両モードに反映できます。

```tex
\kitabstract{...}   % 英語要旨
\kitkeywords{...}   % キーワード（; 区切り等は好みで）
```

---

## KIT校章（表紙ロゴ）の挿入（修論のみ）
デフォルトで `KIT_kosho.eps` を探して、存在すれば表紙上部中央に挿入します。

明示的に指定する場合（推奨）：

```tex
\kitlogo{KIT_kosho.eps}
\kitlogowidth{24mm} % 任意（デフォルトは 24mm）
```

※ `KIT_kosho.eps` が見つからない場合は警告を出してスキップします。

---

## 前付け（front matter）の作り方

### もっとも簡単：\makefrontmatter（推奨）
`\begin{document}` の直後に置きます。

```tex
\begin{document}
\makefrontmatter
```

- **thesis モード**：表紙 → Abstract/Key words → 目次 → 図目次 → 表目次（必要ページ数）
- **ar モード**：`\maketitle` → Abstract → Key words（提供済みの内容がある場合のみ）

### 個別に呼びたい場合（任意）
- thesis：`\makekitfrontmatter`（上と同等）
- ar：`\makearfrontmatter`（`\maketitle` + Abstract/Key words）

---

## 学術発表論文ページ（修論のみ）
最後に 1 ページ程度でまとめたい場合、以下を使います。

```tex
\publicationspage{
  \begin{enumerate}
    \item ...
  \end{enumerate}
}
```

---

## 重要メモ
- thesis モードのデフォルト値：
  - `\kitfaculty{Graduate School of Engineering}`
  - `\kitdepartment{Mechanical Engineering}`
  - `\kitsupervisor{Prof. Kosei Demura}`
  （必要に応じて本文側で上書きできます）
- 余白・行間・表紙の記載事項などは、KITの正式要項に合わせて `kitinteract.cls`（thesis 部分）を調整してください。
- ar モードは `interact.cls` の流儀（所属、謝辞、図表配置など）に従って追記してください。

## v0.7: Thesis chapters -> Journal sections (single-source)

### Automatic mapping in `ar` mode (default: ON)
If you write your thesis using `\chapter`, `\section`, `\subsection`...,
the same source can compile in `ar` mode by shifting heading levels down by one:

- `\chapter` → `\section`
- `\section` → `\subsection`
- `\subsection` → `\subsubsection`
- `\subsubsection` → `\paragraph`

Disable this behavior with:
```tex
\documentclass[ar,nomaplevels]{kitinteract}
```

### Wrapper commands (recommended)
For maximum clarity and control, you can also use these wrappers in your source:

- `\kitchapter{...}` / `\kitchapter*{...}`
- `\kitsection{...}` / `\kitsection*{...}`
- `\kitsubsection{...}` / `\kitsubsection*{...}`
- `\kitsubsubsection{...}` / `\kitsubsubsection*{...}`
- `\kitparagraph{...}` / `\kitparagraph*{...}`

These wrappers map thesis levels to journal levels as follows:

- thesis `\chapter` ↔ ar `\section`
- thesis `\section` ↔ ar `\subsection`
- thesis `\subsection` ↔ ar `\subsubsection`
- thesis `\subsubsection` ↔ ar `\paragraph`


## References heading
This class forces the bibliography heading to "References" in both modes.
