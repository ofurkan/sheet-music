\version "2.26.0"
\include "turkish-makam.ly"

%% =====================================================================
%%  TÜRK MÛSİKÎSİ ŞABLONU — LilyPond template for makam notation
%%
%%  Fill in the HEADER, pick a makam and an usûl, then write the
%%  sections. Everything below the "ASSEMBLY" line usually needs no
%%  editing beyond commenting out sections you don't have.
%%
%%  Derived from a working Sûznâk şarkı file. Compiled: no.
%% =====================================================================


%% ---------------------------------------------------------------------
%% 1. SOLFÈGE NOTE NAMES  (do re mi fa sol la si)
%%    Delete this block to enter notes as c d e f g a b instead.
%% ---------------------------------------------------------------------
#(define solfege-map '((c . "do") (d . "re") (e . "mi") (f . "fa")
                       (g . "sol") (a . "la") (b . "si")))

#(define turkishSolfegeNames
   (map (lambda (entry)
          (let* ((name (symbol->string (car entry)))
                 (head (string->symbol (substring name 0 1)))
                 (tail (substring name 1)))
            (cons (string->symbol
                    (string-append (assq-ref solfege-map head) tail))
                  (cdr entry))))
        turkishMakamPitchNames))

#(set! language-pitch-names
       (append language-pitch-names
               (list (cons 'turkish-solfege turkishSolfegeNames))))

\language "turkish-solfege"

%%  ACCIDENTAL SUFFIXES
%%    raise:  c koma | eb eksik bakiye | b bakiye | k küçük
%%            bm büyük mücenneb | t tanini
%%    lower:  insert f  ->  fc fi fu fb fk fbm ft
%%    e.g.  sifc = si koma bemol   fab = fa bakiye diyez
%%
%%  To see every glyph, uncomment and compile:
%%  \score { \new Staff { \omit Staff.TimeSignature \cadenzaOn
%%    do'1 doc' doeb' dob' dok' dobm' dot'
%%    do'1 dofc' dofi' dofu' dofb' dofk' dofbm' doft' \cadenzaOff } }


%% ---------------------------------------------------------------------
%% 2. USÛL DEFINITIONS
%%    Only affect automatic beaming and \bar "!" subdivisions.
%%    Add your own; the list is the beat pattern in baseMoment units.
%% ---------------------------------------------------------------------
sofyan = {                                        % 4/4  düm tek tek
  \time 4/4
  \set Timing.baseMoment = #(ly:make-moment 1/4)
  \set Timing.beatStructure = #'(2 1 1)
}

duyek = {                                         % 8/8
  \time 8/8
  \set Timing.baseMoment = #(ly:make-moment 1/8)
  \set Timing.beatStructure = #'(3 2 3)
}

aksak = {                                         % 9/8
  \time 9/8
  \set Timing.baseMoment = #(ly:make-moment 1/8)
  \set Timing.beatStructure = #'(2 2 2 3)
}

curcuna = {                                       % 10/8
  \time 10/8
  \set Timing.baseMoment = #(ly:make-moment 1/8)
  \set Timing.beatStructure = #'(3 2 2 3)
}

devrituran = {                                    % 7/8
  \time 7/8
  \set Timing.baseMoment = #(ly:make-moment 1/8)
  \set Timing.beatStructure = #'(3 2 2)
}

semai = {                                         % 3/4
  \time 3/4
  \set Timing.baseMoment = #(ly:make-moment 1/4)
  \set Timing.beatStructure = #'(1 1 1)
}


%% ---------------------------------------------------------------------
%% 3. HEADER
%% ---------------------------------------------------------------------
\header {
  title    = "ESERİN ADI"
  subtitle = "ilk mısra"
  composer = "Beste: "
  poet     = "Güfte: "
  meter    = "Usûlü: Sofyan"
  tagline  = ##f
}

\paper {
  property-defaults.fonts.serif = "Linux Libertine O"
  property-defaults.fonts.sans  = "Linux Biolinum O"
  %% If these aren't installed LilyPond falls back silently.
}


%% ---------------------------------------------------------------------
%% 4. GLOBAL SETTINGS
%%    \key <karar> \<makam>  — e.g. \key sol \suznak, \key sol \rast,
%%    \key la \ussak, \key re \hicaz. turkish-makam.ly defines 200+.
%% ---------------------------------------------------------------------
global = {
  \key sol \suznak
  \sofyan
  \override Staff.TimeSignature.style = #'numbered
  \set Staff.autoBeaming = ##f       % beam by hand: sol16[ la si do]
  \set Staff.extraNatural = ##f      % no courtesy naturals
  %% one syllable per note; slurs and ties still make melismas:
  \set melismaBusyProperties = #'(melismaBusy slurMelismaBusy tieMelismaBusy)
}


%% ---------------------------------------------------------------------
%% 5. SECTIONS
%%    Classical şarkı form: zemîn / nakarat / meyan, each usually
%%    followed by a saz (instrumental) passage with 1. and 2. endings.
%%    Delete what you don't need; s1 = one empty bar.
%% ---------------------------------------------------------------------
zemin     = \relative sol' { \global s1*3 }
zeminSazA = \relative sol' { s1 }          % 1. ending
zeminSazB = \relative sol' { s1 }          % 2. ending

nakarat     = \relative sol' { s1*3 }
nakaratSazA = \relative sol' { s1 }
nakaratSazB = \relative sol' { s1 }

meyan     = \relative sol' { s1*3 }
meyanSazA = \relative sol' { s1 }
meyanSazB = \relative sol' { s1 }

aranagmeOncesi = \relative sol' { s1 }     % pickup into the aranağme
aranagme       = \relative sol' { s1*4 }


%% ---------------------------------------------------------------------
%% 6. GÜFTE
%%    one token per note:  hece  __ (extender)  _ (skip one note)
%%    \skip 1 skips a whole bar (use for saz passages)
%%    quote anything with punctuation:  "(SAZ"
%% ---------------------------------------------------------------------
gufte = \lyricmode {
  %% Ze -- mîn ...
}


%% ---------------------------------------------------------------------
%% 7. ASSEMBLY
%%    Printed route:  zemîn → 𝄋 → nakarat (⊕ Al Coda) → meyan
%%                    → D.S. al Coda → ⊕ → aranağme
%%    These marks are typographic only; they do not affect MIDI.
%% ---------------------------------------------------------------------
\score {
  \new Staff \with { midiInstrument = "clarinet" } <<
    \new Voice = "song" {
      \global

      \repeat volta 2 { \zemin }
      \alternative { { \zeminSazA } { \zeminSazB } }

      %% 𝄋 target — the D.S. returns here
      \segnoMark 1
      \repeat volta 2 { \nakarat }
      \alternative {
        {
          \codaMark 1               % ⊕ departure
          \jump "Al Coda"
          \nakaratSazA
        }
        { \nakaratSazB }
      }

      \repeat volta 2 { \meyan }
      \alternative {
        { \meyanSazA }
        {
          \meyanSazB
          \jump "D.S. al Coda"      % send the player back to 𝄋
        }
      }

      %% ⊕ target. Plain \mark, not \codaMark, so it always prints.
      \mark \markup { \musicglyph "scripts.coda" }
      \aranagmeOncesi
      \sectionLabel "Aranağme"
      \repeat volta 2 { \aranagme }
      \bar "|."
    }
    \new Lyrics \lyricsto "song" { \gufte }
  >>
  \layout { indent = 0 }
}

%% Uncomment for MIDI. Note: microtones export as 72-EDO
%% approximations, not Turkish tuning, and the marks above are
%% ignored — use \repeat segno for MIDI that follows the route.
%% \score { \unfoldRepeats \global \midi { } }


%% =====================================================================
%%  QUICK REFERENCE
%%
%%  \bar "!"     dashed line (usûl subdivision, no measure reset)
%%  \mark \markup { \musicglyph "scripts.segno" }   manual 𝄋
%%  \grace / \acciaccatura la8                      çarpma
%%  \override NoteHead.style = #'cross              notehead styles
%%  \sectionLabel "Aranağme"                        section heading
%%
%%  Emmentaler is the only notation font LilyPond ships; alternatives
%%  need font files installed and won't work in a browser editor.
%% =====================================================================
