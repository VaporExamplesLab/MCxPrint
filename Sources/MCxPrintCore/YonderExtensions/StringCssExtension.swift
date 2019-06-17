//
//  StringCssExtension.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.11.
//

import Foundation

public struct CssColor {
    static let green = "#00ff00"
    static let yellow = "#00ff00"
    static let blue = "#00ff00"
    static let gray = "#00ff00"
    static let orange = "#00ff00"
    static let red = "#00ff00"
    
    static let stroke1 = "#b871ff"
    static let stroke2 = "#20ff00"
    static let stroke3 = "#ff0000"
    static let stroke4 = "#ff9900"
    static let stroke5 = "#990043"
    static let stroke6 = "#ffff00"
    static let stroke7 = "#999999"
    static let stroke8 = "#55ffbf"
    static let stroke9 = "#381cff"
    static let stroke0 = "#00aa2a"
}

public struct CssFontName {
    // DejaVu Uppercase Q drops slightly below baseline.
    static let arial = "Arial"
    static let arialItalic = "Arial Italic"
    static let arialBold = "Arial Bold"
    static let arialBoldItalic = "Arial Bold Italic"
    static let arialNarrow = "Arial Narrow"
    static let arialNarrowItalic = "Arial Narrow Italic"
    static let arialNarrowBold = "Arial Narrow Bold"
    static let arialNarrowBoldItalic = "Arial Narrow Bold Italic"
    static let arialBlackRegular = "Arial Black Regular"
    static let arialRoundedMTBoldRegular = "Arial Rounded MT Bold Regular"
    
    // Based on DejaVu Sans Mono.
    // Slightly modified for markup languages such as LaTeX, Asciidoc, or markdown.
    // Useful for marking up classical text documents, helping to distinguish between similar-looking glyphs.
    // • A modified endash to distinguish from a hyphen and a emdash.
    // • A modified minus sign to distinguish from the endash.
    static let dejaVuMarkup = "DejaVu Markup"
    static let dejaVuMarkupOblique = "DejaVu Markup Oblique"
    static let dejaVuMarkupBold = "DejaVu Markup Bold"
    static let dejaVuMarkupBoldOblique = "DejaVu Markup Bold Oblique"
    
    // DejaVu Uppercase J, Q drop below baseline.
    static let dejaVuSans = "DejaVu Sans"
    static let dejaVuSansExtraLight = "DejaVu Sans ExtraLight"
    static let dejaVuSansOblique = "DejaVu Sans Oblique"
    static let dejaVuSansBold = "DejaVu Sans Bold"
    static let dejaVuSansBoldOblique = "DejaVu Sans Bold Oblique"
    static let dejaVuSansCondensed = "DejaVu Sans Condensed"
    static let dejaVuSansCondensedOblique = "DejaVu Sans Condensed Oblique"
    static let dejaVuSansCondensedBold = "DejaVu Sans Condensed Bold"
    static let dejaVuSansCondensedBoldOblique = "DejaVu Sans Condensed Bold Oblique"
    
    static let dejaVuSansMono = "DejaVu Sans Mono"
    static let dejaVuSansMonoOblique = "DejaVu Sans Mono Oblique"
    static let dejaVuSansMonoBold = "DejaVu Sans Mono Bold"
    static let dejaVuSansMonoBoldOblique = "DejaVu Sans Mono Bold Oblique"
    
    static let noteworthyLight = "Noteworthy Light"
    static let noteworthyBold = "Noteworthy Bold"
    
}

public struct CssFontStyle {
    
    // font-family="DejaVuSansMono, 'DejaVu Sans Mono', monospace"
    // font-family="ArialMT, Arial, 'Helvetica Neue', Helvetica, sans-serif"
    // font-family="Noteworthy-Light, Noteworthy, sans-serif"
    
    // <text  fill="rgb(0, 0, 0)" font-family="DejaVuSansMono-BoldOblique, 'DejaVu Sans Mono', monospace" font-style="oblique" font-weight="bold" font-size="17" x="38" y="28"><tspan x="38" y="55">Hello, World!</tspan></text>
    
    public static let arialNarrowItalic12 = [
        "font-family=\"ArialNarrowItalic, 'Arial Narrow Italic', Arial\"",
        "font-size=\"12px\""
    ]
    
    public static let dejaVuSansMono12 = [
        "font-family=\"DejaVuSansMono, 'DejaVu Sans Mono', monospace\"",
        "font-size=\"12px\""
    ]
    
    public static let dejaVuSansMono12Pitch: CGFloat = 7.225 // measured (173.39 / 24) points
    
}

public extension String {
    
    /*
     
     /* A font family name and a generic family name */
     font-family: Gill Sans Extrabold, sans-serif;
     font-family: "Goudy Bookletter 1911", sans-serif;
     
     /* A generic family name only */
     font-family: serif;
     font-family: sans-serif;
     font-family: monospace;
     font-family: cursive;
     font-family: fantasy;
     font-family: system-ui;
     
     /* Global values */
     font-family: inherit;
     font-family: initial;
     font-family: unset;
     
     https://developer.mozilla.org/en-US/docs/Web/CSS/font-kerning
     
     https://developer.mozilla.org/en-US/docs/Web/CSS/font-size
     https://developer.mozilla.org/en-US/docs/Web/CSS/font-stretch
     
     // normal; italic; oblique;
     https://developer.mozilla.org/en-US/docs/Web/CSS/font-style
     
     //
     https://developer.mozilla.org/en-US/docs/Web/CSS/font-size-adjust
     
     // shorthand for the longhand properties font-variant-caps, font-variant-numeric, font-variant-alternates, font-variant-ligatures,
     https://developer.mozilla.org/en-US/docs/Web/CSS/font-variant
     https://developer.mozilla.org/en-US/docs/Web/CSS/font-variant-caps
     
     https://developer.mozilla.org/en-US/docs/Web/CSS/font-weight
     https://developer.mozilla.org/en-US/docs/Web/CSS/font-kerning
     
     https://developer.mozilla.org/en-US/docs/Web/CSS/line-height
     
     */
    
    
}
