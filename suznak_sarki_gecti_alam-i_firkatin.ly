\version "2.24.0"
\include "turkish-makam.ly"

%% ---------------------------------------------------------------------
%% Custom Solfège Mapping for Turkish Makam accidentals
%% (do, re, mi, fa, sol, la, si) + (c, b, k, bm, fc, fb, fk, fbm)
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

%% =====================================================================
%%  SÛZNÂK ŞARKI — "Geçti Âlâm-ı Firâkın Cânıma"
%% =====================================================================
\paper {
  property-defaults.fonts.serif = "Linux Libertine O"
  property-defaults.fonts.sans = "Linux Biolinum O"
  property-defaults.fonts.typewriter = "DejaVu Sans Mono"
}

\header {
  title    = "SÛZNÂK ŞARKI"
  subtitle = "Geçti Âlâm-ı Firâkın Cânıma"
  composer = "Müzik: Klârinetçi İbrahim Efendi"
  poet     = "Söz: —"
  meter    = "Usûlü: Sofyan"
  tagline  = ##f
}

global = {
  \override Staff.TimeSignature.style = #'numbered
  \key sol \suznak
  \time 4/4
  \set Staff.autoBeaming = ##f
  \set Staff.extraNatural = ##f
  \set melismaBusyProperties = #'(melismaBusy slurMelismaBusy tieMelismaBusy)
}

%% ---------------------------------------------------------------------
%% ZEMÎN (Entered in Solfège)
%% ---------------------------------------------------------------------
zemin = \relative sol' {
  sol'8.[ re16 re8 re8] mifb16[ fab16 mifb16 re16] do8[ sifc8] | 
  do16[ re16 do8] re4 mifb16[ fab16 mifb8] fab4 |
  sifk16[ la16 sol16 la16] sol8[ fab8] sol16[ fab16 mifb16 fab16] mifb8[ mifb16 re16]
}

zeminSazA = \relative sol'' { re4. fab16[ mifb16] re16[ do16 sifc16 lafb16] sol4 }  % volta 1
zeminSazB = \relative sol'' { re4. re16[ mifb16] re16[ do16 sifc16 do16] re4 }      % volta 2

%% ---------------------------------------------------------------------
%% NAKARAT (Entered in Solfège)
%% ---------------------------------------------------------------------
nakarat = \relative sol'' {
  mifb8.[ mifb16] mifb8[ mifb16 re16] mifb16[ fab16 mifb16 re16] do8[ sifc8] | 
  do16[ re16 do8] sifc4 do16[ re16 do8] re4 |
  mifb16[ re16 do16 re16] do8[ sifc8] do16[ sifc16 lafb16 sifc16] lafb8[ lafb16 sol16]
}

nakaratSazA = \relative sol' { sol4. re'16[ mifb16] re16[ do16 sifc16 do16] re4 } % volta 1
nakaratSazB = \relative sol' { sol4. la'16[ sifk16] la16[ sol16 sol16 fa16] sol4 } % volta 2

%% ---------------------------------------------------------------------
%% MEYAN (Entered in Solfège)
%% ---------------------------------------------------------------------
meyan = \relative sol'' {
  fa8.[ sol16 sol8 sol8] sol8[\acciaccatura la8 sol16 fa16] mifc8[ re8] | mifc16 [fa16 mifc8] fa16 [sol16 fa8] sol16 [la16 sol8] la4 |
  sifk16 [la16 sol16 la16] sol8 [fab8] sol16 [fab16 mifb16 fab16] mifb8 [mifb16 re16]
}

meyanSazA = \relative sol'' { re4. la'16[ sifk16] la16[ sol16 sol16 fa16] sol4 }
meyanSazB = \relative sol'' { re4. re16 [mifb16] re16 [do16 sifc16 do16] re4 }

%% ---------------------------------------------------------------------
%% ARANAĞME
%% ---------------------------------------------------------------------

aranagmeOncesi = \relative sol' {sol8 sol'4 fab16 [mifb16] re16 [do16 sifc16 lafb16] sol4}
aranagme = \relative sol'' {
    sol16 [fab sol mifb] re4 fab16 [mifb fab re] do4 | sifc16 [do re mifb] fab [sol fab mifb] re [do sifc do] re4 |
    sol16 [fab sol mifb] re4 fab16 [mifb fab re] do4 | sifc16 [do re mifb] re [do do sifc] sifc [lafb lafb sol] sol4
}

%% ---------------------------------------------------------------------
%% Lyrics
%% ---------------------------------------------------------------------
zeminGufte = \lyricmode { 
  Geç ti â la mı __ _ fi __ _ ra kın câ __ _ _ _ _ _ _ _ câ __ _ _ _ _ _ _ _ _ _ _ nı __ _ 
  ma SAZ __ _ _ _ _ _ _ ma SAZ __ _ _ _ _ _ _ 
  Gel be nim a __ _ hu __ _ ba __ _ kış lım ya __ _ _ _ ya __ _ _ _ ya __ _ _ _ _ _ _ _ _ _ _ nı __ _ ma
  (SAZ __ _ _ _ _ _ _) ma (SAZ __ _ _ _ _ _ _)
  Bâ is ol ma na le __ _ vü ef gâ __ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ nı __ _ ma 
  (SAZ __ _ _ _ _ _ _) ma (SAZ __ _ _ _ _ _ _) ma 
  (SAZ __ _ _ _ _ _ _ _)
}

nakaratGufte = \lyricmode {
  
}

%% ---------------------------------------------------------------------
%% Assembly
%% ---------------------------------------------------------------------
\score {
  \new Staff \with { midiInstrument = "clarinet" } <<
    \new Voice = "song" {
      \global
      \repeat volta 2 { \zemin }
      \alternative { 
        { \zeminSazA } 
        { \zeminSazB } 
      }

      \segnoMark 1
      
        \repeat volta 2 { \nakarat }
        \alternative { 
          { 
            \codaMark 1
            \nakaratSazA 
          } 
          { \nakaratSazB } 
        }
      

      \repeat volta 2 { \meyan }
      \alternative { 
        { \meyanSazA } 
        { 
          \meyanSazB 
          \once \override Score.SegnoMark.break-visibility = #begin-of-line-invisible
          \segnoMark 1
        } 
      }
      

      \mark \markup { \musicglyph "scripts.coda" }
      \aranagmeOncesi
      \sectionLabel "Aranağme"
      \repeat volta 2 {\aranagme}
      
    }
    \new Lyrics \lyricsto "song" { \zeminGufte }
  >>
  \layout { indent = 0 }
}