#lang scribble/manual
@require[@for-label[slib/format
                    (except-in racket/base format)
                    racket/pretty]]

@title{SLIB/Common Lisp format for Racket}
@author{@author+email["Shawn Wagner" "shawnw.mobile@gmail.com"]}

@defmodule[slib/format]

A port of @hyperlink["https://people.csail.mit.edu/jaffer/SLIB"]{SLIB} format 3.1 to Racket. Original code by Dirk Lutzebaeck and Aubrey Jaffer.

@hyperlink["https://people.csail.mit.edu/jaffer/slib/Format.html#Format"]{SLIB documentation}. A few portions have been excerpted below.

@section{Format Interface}

@defproc[(format [destination (or/c output-port? boolean? string? number?)] [format-string (or/c string? any/c)] [arg any/c] ...)
         (or/c boolean? string?)]{

An almost complete implementation of Common LISP format description according to the CL reference book Common LISP from Guy L. Steele, Digital Press.
Backward compatible to most of the available Scheme format implementations.

Returns @code{#t}, @code{#f} or a string; has side effect of printing according to @code{format-string}. If @code{destination} is @code{#t}, the output is to the current output
port and @code{#t} is returned. If @code{destination} is @code{#f}, a formatted string is returned as the result of the call. @bold{NEW}: If @code{destination} is a string,
@code{destination} is regarded as the format string; @code{format-string} is then the first argument and the output is returned as a string. If @code{destination} is a number, the
output is to the current error port if available by the implementation. Otherwise destination must be an output port and @code{#t} is returned.

@code{format-string} must be a string. In case of a formatting error @code{format} returns @code{#f} and prints a message on the current output or error port. Characters are
output as if the string were output by the @code{display} function with the exception of those prefixed by a tilde (@tt{~}). For a detailed description of the @code{format-string}
syntax please consult a Common LISP format reference manual. For a test suite to verify this format implementation @code{(require slib/formatst)}
(Note: The test script will always fail a few cases; it does with Guile too. The failures seem to be related to not saving output column between calls when returning a string).

@bold{Racket-specific changes}: The pretty print format @tt{~Y} uses the standard Racket @code{pretty-print} routine, not
@hyperlink["https://people.csail.mit.edu/jaffer/slib/Pretty_002dPrint.html#Pretty_002dPrint"]{the version included in SLIB}.

}

@section{Configuration Variables}

What are @hyperlink["https://people.csail.mit.edu/jaffer/slib/Format-Specification.html#Configuration-Variables"]{simple variables in the SLIB version}
are parameters in this one.

@defparam[format:symbol-case-conv converter (or/c (-> string? string?) #f) #:value #f]{

Symbols are converted by @code{symbol->string} so the case type of the printed symbols is implementation dependent. @code{format:symbol-case-conv} is a one arg closure which is
either @code{#f} (no conversion), @code{string-upcase}, @code{string-downcase} or @code{string-titlecase}.
}

@defparam[format:iobj-case-conv converter (or/c (-> string? string?) #f) #:value #f]{
 As @code{format:symbol-case-conv} but applies for the representation of implementation internal objects.
}

@defparam[format:expch ch char? #:value #\E]{

The character prefixing the exponent value in @tt{~E} printing.

}

@defboolparam[format:iteration-bounded bounded? #:value #t]{

When @code{#t}, a @tt{~{...~}} control will iterate no more than the number of times specified by @code{format:max-iterations} regardless of the number of iterations implied by
modifiers and arguments. When @code{#f}, a @tt{~{...~}} control will iterate the number of times implied by modifiers and arguments, unless termination is forced by language or
system limitations.

}

@defparam[format:max-iterations iterations exact-nonnegative-integer? #:value 100]{

The maximum number of iterations performed by a @tt{~{...~}} control. Has effect only when @code{format:iteration-bounded} is @code{#t}.

}

