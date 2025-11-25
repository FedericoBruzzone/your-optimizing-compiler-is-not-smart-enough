/*
Links:
  - http://wpage.unina.it/rcanonic/didattica/dcn/lucidi/DCN-L08-L09-OpenFlow.pdf
*/

#import "./theme/fcb.typ": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
// #codly(zebra-fill: none)
#codly(number-format: none) // #codly(number-format: it => [#it])
#codly(languages: codly-languages)

#let background = white // silver
#let foreground = navy
#let link-background = maroon // eastern
#let header-footer-foreground = maroon.lighten(50%)

#show: fcb-theme.with(
  aspect-ratio: "16-9",
  header: [#align(center)[_Your Optimizing Compiler is *Not* Optimizing Enough. To Hell With *Multiple Recursions*!_]],
  footer: [Federico Bruzzone -- Università degli Studi di Milano],
  background: background,
  foreground: foreground,
  link-background: link-background,
  header-footer-foreground: header-footer-foreground
)

#let tiny-size = 0.4em
#let small-size = 0.7em
#let normal-size = 1em
#let large-size = 1.3em
#let huge-size = 1.6em

// #set text(font: "Fira Mono")
// #show raw: it => block(
//   inset: 8pt,
//   text(fill: foreground, font: "Fira Mono", it),
//   radius: 5pt,
//   fill: rgb("#1d2433"),
// )

#title-slide[
  = Your Optimizing Compiler is Not Optimizing Enough. To Hell With Multiple Recursions!
  #v(2em)

  Federico Bruzzone, #footnote[
      ADAPT Lab -- Università degli Studi di Milano, \
      #h(1.5em) Website: #link("https://federicobruzzone.github.io/")[federicobruzzone.github.io], \
      #h(1.5em) Github: #link("https://github.com/FedericoBruzzone")[github.com/FedericoBruzzone], \
      #h(1.5em) Email: #link("mailto:federico.bruzzone@unimi.it")[federico.bruzzone\@unimi.it]
  ] PhD Student

  Milan, Italy -- #datetime.today().display("[day] [month repr:long] [year repr:full]")

  // #text(small-size)[
  //     Slides available at
  //     #v(-1em)
  //     #link("https://federicobruzzone.github.io/activities/presentations/P4-compiler-in-SDN.pdf")[federicobruzzone.github.io/activities/presentations/P4-compiler-in-SDN.pdf]
  // ]
]

#simple-slide[

    #toolbox.side-by-side(columns: (2fr, 1fr))[
      #align(horizon + center)[
      === Compilers as Musical Compositions

      #v(1em)

      Compilers are frequently perceived as intricate musical compositions---like the unfinished _J. S. Bach’s Art of Fugue_---where mathematical precision and logical interplay guide each part.

      Every module enters in perfect timing, weaving together a structure that only the keenest ears can fully grasp.
      ]
    ][
      #figure(
        image("images/opt-comp.png", width: 98%),
        numbering: none,
        caption: [#text(tiny-size)[Bacon _et al._, CSUR 1994 @Bacon94]]
      )
    ]
]

#simple-slide[
  = Premature Optimizations

  #v(2em)

  #toolbox.side-by-side(columns: (3fr, 1fr))[
    #align(horizon + center)[
      Donald E. Knuth warned in 1974 about the dangers of *premature optimization* in programming @Knuth74:

      _We should forget about small efficiencies, say about 97% of the time: premature optimization is the root of all evil. Yet we should not pass up our opportunities in that critical 3%._
    ]
  ][
    #figure(
      image("images/knuth.jpg", width: 100%),
      numbering: none,
      caption: []
    )
  ]
]

#focus-slide[
  In the absence of either empirically measured or theoretically justified performance issues, programmers should *avoid* making optimizations based *solely* on assumptions about potential performance gains.
]

#centered-slide[
  = Optimizing Compilers

  #v(0.5em)

  #one-by-one(start: 1, mode: gray)[
    Compilers use information collected during analysis passes to guide transformations @Cooper22 @Kennedy01b.
  ][

    *Compiler optimizations*#footnote[
        A _chronologically_ sorted list of papers on compiler optimization, from the works of 1952 through the techniques of 1994, is available at @Bruzzone2025papers.
      ] are such transformations (say _meaning-preserving mappings_ @Paige97) applied to the input code to improve certain aspects---such as performance, resource utilization, and power consumption---without altering its observable behavior.
  ][

    In accordance with the literature @Allen66 @Wulf73, such compilers are referred to as *optimizing compilers*.
  ]
]



#simple-slide[
  ===== Machine Learning Framework are Just Optimizing Compilers #footnote[
        TensorFlow XLA, NVIDIA CUDA Compiler (NVCC), MLIR, and TVM all use *LLVM* @Lattner04.
        Li _et al._, @Li20 compiled a survey on ML compilers.
  ]
  #move(dx: 3cm)[
  #toolbox.side-by-side(columns: (1fr, 3fr))[
    #figure(
      image("images/ml-comp-cg.png", width: 170%),
      numbering: none,
      caption: []
    )
  ][
    #figure(
      image("images/ml-comp.png", width: 70%),
      numbering: none,
      caption: []
    )
  ]
  ]
]

#simple-slide[
  #codly(number-format: it => [#it])

  = Peephole Optimizations in x86-64 #text(tiny-size)[(cf. @McKeeman65 @Tanenbaum82)]

  #v(1em)

  #toolbox.side-by-side(columns: (1fr, 1fr))[
    #align(horizon)[#text(small-size)[

      #one-by-one(start: 1)[
          #codly(highlights: (
            (line: 3, start: 0, fill: red),
          ))
          ```asm
          ; x = x * 2  x: i32
          mov     eax, dword ptr [rbp - 4]
          imul    eax, 2
          mov     dword ptr [rbp - 4], eax
          ```
        ][
          #align(center)[
            The optimized version replaces the multiplication by 2 with a *more efficient* binary shift operation.
          ]
          #codly(highlights: (
            (line: 3, start: 0, fill: green),
          ))
          ```asm
          ; x = x << 1
          mov    eax, dword ptr [rbp - 4]
          shl    eax
          mov    dword ptr [rbp - 4], eax
          ```
        ]
  ]]][
  #align(horizon)[#text(small-size)[
    #one-by-one(start: 3)[
        #codly(highlights: (
          (line: 3, start: 0, fill: red),
        ))
        ```asm
        ; x = x + 0
        mov     eax, dword ptr [rbp - 4]
        add     eax, 0
        mov     dword ptr [rbp - 4], eax
        ```
      ][
        #align(center)[
          The optimized version removes the *unnecessary* addition operation.
        ]

        ```asm
        mov     eax, dword ptr [rbp - 4]
        mov     dword ptr [rbp - 4], eax
        ```
      ][
      #align(horizon)[#text(small-size)[
        #align(center)[
          #block(
            fill: red.lighten(80%),
            stroke: red,
            inset: 5pt,
            radius: 5pt
          )[The `mov` instructions are redundant and can be *pruned* as well!]
      ]]]
      ]
  ]]]

  #codly(number-format: none)
]

#simple-slide[
  = Loop Nest Optimizations --- Loop Tiling #text(tiny-size)[(cf. @Wolfe89 @Wolf91b)]

  #v(1em)

  #toolbox.side-by-side(columns: (40%, 60%))[
    #align(horizon)[#text(small-size)[
    #one-by-one(start: 1)[
      #codly(highlights: (
        (line: 3, start: 24, end: 27, fill: red),
      ))
      ```cpp
      for (int i=0; i<n; ++i) {
        for (int j=0; j<m; ++j) {
            c[i][j] = a[i] * b[j];
        }
      }
      ```

      #align(center)[
        The vector `b` *may not* fit into a line of CPU cache, causing multiple cache misses during the inner loop.

        It implies multiple *fetches* from the main memory, which is *slow*.
      ]
    ]
  ]]][
    #one-by-one(start: 2)[
      #align(horizon)[#text(small-size)[
      #codly(highlights: (
        (line: 1, start: 0, end: 11, fill: green),
        (line: 2, start: 22, end: 27, fill: green),
        (line: 4, start: 24, end: 38, fill: green),
      ))
        ```cpp
        int TS = 16; // Tile Size
        for (int jj=0; jj<m; jj+=TS) {
          for (int i=0; i<n; ++i) {
              for (int j=jj; j<MIN(jj + TS, m); ++j) {
                  c[i][j] = a[i] * b[j];
              }
          }
        }
        ```

        #align(center)[
          The inner loop works on a *tile* of `b` that fits into the cache.
        ]]]
    ][
      #align(horizon)[#text(small-size)[
        #align(center)[
          #block(
            fill: red.lighten(80%),
            stroke: red,
            inset: 5pt,
            radius: 5pt
          )[
            But, the values for the array `a` will be read `m / TS` times!
        ]]]]
    ]
  ]
]

#simple-slide[
  = Loop Tiling Visualization#footnote(
    link("https://colfaxresearch.com/how-series/#ses-10")[A. Vladimirov, Session 10 --- Access to Caches and Memory]
  )
  #align(horizon)[
    #figure(
      image("images/loop-tiling.png", width: 78%),
      numbering: none,
      caption: []
    )
  ]
]

#simple-slide[
  = Tail Call/Recursion Optimization #text(tiny-size)[(cf. @Aho86 @Muchnick97 @Cooper22)]

  #v(2em)

  #toolbox.side-by-side(columns: (3fr, 1fr))[
      #align(horizon + center)[
        Guy L. Steele, Jr. in 1977 observed that *tail-recursive procedure calls* can be optimized to avoid growing the call stack @Steele77:

        _In general, procedure calls may be usefully thought of as GOTO statements which also pass parameters, and can be uniformly coded as [machine code] JUMP instructions._
    ]][
      #figure(
        image("images/steele.jpg", width: 100%),
        numbering: none,
        caption: []
      )
    ]
]


#simple-slide[
  ====== From Recursive to Iterative Functions #text(small-size)[(cf. @Liu99)]

  #toolbox.side-by-side(columns: (3fr, 1fr))[

    #one-by-one(start: 1)[
      // #set math.cases(reverse: true)
      // #set math.cases(gap: 1em)
      $
        bold(f)(x) = cases(
          b(x_0) "if" x = x_0,
          a(x, bold(f)(d(x))) "otherwise"
        ) \
        italic("s.t.") a, b, "and so on may denote any pieces of code."
      $
    ][
      #text(small-size)[
        To transform recursive function $bold(f)$ into iterative form, we need to:

        1. Identifies an increment $xor$ to the argument of $bold(f)$, i.e., $x' = x xor y$ such that $x = italic("prev")(x')$, where $italic("prev")$ is based on the arguments of the recursive call. In this case, $italic("prev")(x) = d(x)$ and, if $d^(-1)$ exists, $x xor y = d^(-1)(x)$, can be plugged in for $y$.
        2. Derives an incremental program $bold(f)'(x, r)$ that computes $bold(f)(x)$ using an accumulator $r$ of $bold(f)(italic("prev")(x))$.
        3. Forms an iterative version that initializes using the base case of $bold(f)$ and iteratively applies $bold(f)'$ until reaching the desired argument.
      ]
    ]
  ][
    #one-by-one(start: 3)[
    #text(small-size)[
    #align(horizon)[
      $
        & bold(f)(x) = { \
        & #h(1cm) x_1 = x_0; r = b(x_0); \
        & #h(1cm) "while" (x_1 != x) { \
        & #h(2cm) x_1 = d^(-1)(x_1); \
        & #h(2cm) r = a(x_1, r); \
        & #h(1cm) } \
        & #h(1cm) "return" r; \
        & }
      $
    ]]
    ][
      #align(horizon)[#text(tiny-size)[
        #align(center)[
          #block(
            fill: green.lighten(80%),
            stroke: green,
            inset: 5pt,
            radius: 5pt
          )[Note that, when $a$ is in the form $a(a_1(x), y)$ and $a$ is associative, we do not need $d^(-1)$ and $x_1$.]
        ]]]
    ]
  ]
]

#centered-slide[
    ===== Tail-recursive Factorial Function

    #toolbox.side-by-side(columns: (40%, 60%))[
      #one-by-one(start: 1)[
      #text(tiny-size)[
        #codly(highlights: (
          (line: 2, start: 9, end: 14, fill: green),
          (line: 3, start: 16, end: 16, fill: blue),
          (line: 3, start: 9, end: 14, fill: yellow),
          (line: 5, start: 21, end: 25, fill: orange),
          (line: 5, start: 12, end: 12, fill: teal),
          (line: 5, start: 14, end: 14, fill: fuchsia),
          (line: 5, start: 5, end: 10, fill: yellow),
          (line: 2, start: 5, end: 8, fill: red),
          (line: 2, start: 15, fill: red),
          (line: 4, start: 5, end: 5, fill: red),
          (line: 5, start: 16, end: 20, fill: red),
          (line: 5, start: 26, fill: red),
        ))
        ```cpp
        int fact(int n) {
            if (n == 0) {
                return 1;
            }
            return n * fact(n - 1);
        }
        ```

        The replacement of $n * ((n - 1) * (n - 2))$ by $(n * (n - 1)) * (n - 2)$ is valid due to the *associativity* of multiplication.

        $
          & bold(f)(x) = { \
          & #h(1cm) r = b(x_0); \
          & #h(1cm) "while" (x != x_0) { \
          & #h(2cm) r = a(r, a_1(x)); \
          & #h(2cm) x = d(x); \
          & #h(1cm) } \
          & #h(1cm) "return" r; \
          & }
        $
    ]][
      #align(horizon)[#text(tiny-size)[
                #align(center)[
                  #block(
                    fill: red.lighten(80%),
                    stroke: red,
                    inset: 5pt,
                    radius: 5pt
                  )[Note that, (i) when dealing with IEEE754 numbers, multiplication is *not* strictly associative, and (ii) the latter _might be_ slower due to multiply bigger numbers.]
      ]]
    ]]][
      #one-by-one(start: 3)[
        #align(horizon)[#text(tiny-size)[
      #codly(highlights: (
        (line: 3, start: 3, fill: green),
        (line: 11, start: 3, fill: green),

        (line: 4, start: 3, end: 13, fill: red),
        (line: 12, start: 3, end: 12, fill: red),

        (line: 14, start: 29, end: 29, fill: blue),

        (line: 4, start: 16, end: 28, fill: yellow),
        (line: 12, start: 15, end: 27, fill: yellow),
        (line: 13, start: 0, end: 7, fill: yellow),
        (line: 15, start: 3, end: 5, fill: yellow),

        (line: 9, start: 3, fill: orange),
        (line: 7, start: 3, end: 8, fill: orange),
        (line: 7, start: 22, end: 25, fill: orange),

        (line: 8, start: 3, end: 10, fill: teal),
        (line: 8, start: 24, end: 27, fill: teal),

        (line: 10, start: 3, end: 6, fill: teal),
        (line: 10, start: 10, end: 20, fill: fuchsia),
        (line: 10, start: 22, end: 27, fill: orange),
        (line: 10, start: 30, fill: teal),

        (line: 14, start: 67, end: 70, fill: teal),

        (line: 4, start: 31, end: 44, fill: maroon.lighten(80%)),
        (line: 6, start: 0, fill: maroon.lighten(80%)),
        (line: 7, start: 28, end: 35, fill: maroon.lighten(80%)),
        (line: 8, start: 30, end: 37, fill: maroon.lighten(80%)),
        (line: 12, start: 30, fill: maroon.lighten(80%)),
        (line: 14, start: 73, end: 80, fill: maroon.lighten(80%)),
      ))
      ```
      define i32 @fact(int)(i32 %n)  {
      entry:
        %cmp3 = icmp eq i32 %n, 0
        br i1 %cmp3, label %return, label %if.else ; label %if.else.preheader
      ; if.else.preheader -> vector.ph -> vector.body -> middle.block -> if.else.preheader7
      if.else:
        %n.tr5 = phi i32 [ %sub, %if.else ], [ %n.tr5.ph, %if.else.preheader7 ]
        %acc.tr4 = phi i32 [ %mul, %if.else ], [ %acc.tr4.ph, %if.else.preheader7 ]
        %sub = add nsw i32 %n.tr5, -1
        %mul = mul nsw i32 %n.tr5, %acc.tr4
        %cmp = icmp eq i32 %sub, 0
        br i1 %cmp, label %return, label %if.else
      return:
        %acc.tr.lcssa = phi i32 [ 1, %entry ], [ %4, %middle.block ], [ %mul, %if.else ]
        ret i32 %acc.tr.lcssa
      }
      ```
    ]]]]
]

// #hidden-bibliography(
#text(small-size)[
  #bibliography("local.bib")
]
// )
