# MCxPrint

Print Labels from SVG input.


**Options:**

* --test-alignment  #

```bash
mcxprint filename.json --

# filename.svg
# filename.pdf
# filename.html
```

Add HTML wrapper possible approaches:

* --html               #
* --output=html        #
* output_filename.html #

## Typography

**CGFont.h**

**CoreText CTFont** []()

<https://github.com/MaddTheSane/SwiftMacTypes/blob/master/CoreTextAdditions/CTFontAdditions.swift>

**Approaches:**

* <code>[CoreGraphics](https://developer.apple.com/documentation/coregraphics)</code> Quartz technology to perform lightweight 2D rendering.

    * <code>[CGFont](https://developer.apple.com/documentation/coregraphics/cgfont)</code> A set of character glyphs and layout information for drawing text. 

    * <code>[CGGlyph](https://developer.apple.com/documentation/coregraphics/cgglyph)</code>

* <code>[CoreText](https://developer.apple.com/documentation/coretext)</code> Create text layouts using high-quality typesetting, character-to-glyph conversion, and positioning of glyphs in lines and paragraphs
    * <code>[CTFont](https://developer.apple.com/documentation/coretext/ctfont-q6r)</code>
* Write utility to create catalog of font metrics.
    *  also creates SVG font test page.
        
    ```swift
    func size(withAttributes attrs: [NSAttributedString.Key : Any]? = nil) -> CGSize
    func size(withAttributes attrs: [NSAttributedString.Key : Any]? = nil) -> NSSize
    ```

    ```
    FontName
    aaaaaaaaaa
    AAAAAAAAAA
    bbbbbbbbbb
    BBBBBBBBBB
    ```
* Implement printing for macOS only.
* Use only fixed with fonts
* Search for font metrics/typography library.


* <https://developer.apple.com/documentation/appkit/nsfont>
* <https://developer.apple.com/documentation/foundation/nsstring/1531844-size>

## PrintSampler_macOS

```swift
let htmlStr = PrintTemplate.generateSvgTestAlignment
let htmlStr = PrintTemplate.generatedSvgTagBookAlignment
let htmlStr = PrintTemplate.generateTagBook
```

**See:**

* KnowtzStation.storyboard
    * JSON
        * JSON: Tag Book
        * JSON: Tag File (color set)
    * HTML
        * HTML: Letter Portrait Calibrate
        * HTML: Letter Portrait 2-Column
        * HTML: Letter Portrait 4-up
        * HTML: Tab Book Calibrate
        * HTML: Tab Book Template
        * HTML: Tag File Template
    * MD
        * MD: Part (duplex)
        * MD: Tag Book
        * MD: Tag File
    * SVG
        * SVG: Letter Portrait Calibration    
        
```swift

enum TestPattern {
    // Tag File
    //case jsonTagFileColorSet
    case htmlLetterPortCali
        let htmlStr = PrintTemplate.generateSvgGraphPaper
        let htmlStr = PrintTemplate.generateSvgTestAlignment
    case mdTagFile
        let mdStr = "Hello mdTagFile\n----\n"
        DataQueueManager.doAddItem(
            sourceType: DataItem.SourceType.mdStr,
        )

    // Tag Book
    case htmlTagBookCalibration
        let wxhLandscape = PrintUtil.PaperPointRect.ptouchLandscape
        let htmlStr = PrintTemplate.generatedSvgTagBookAlignment
    case htmlTagBookTemplate
        let htmlStr = PrintTemplate.generateTagBook()
    case mdTagBook
        DataQueueManager.doAddItem(
    
    // Card3x5
    case htmlCard3x5Port
        let wxh = PrintUtil.PaperPointRect.card3x5
        let htmlStr = PrintTemplate.generateSvgTestAlignment(
            type: DataItem.Genre.card
            sourceType: SourceType.htmlStr
        )
    case htmlCard3x5Land
        let htmlStr = PrintTemplate.generateSvgTestAlignment
    
    // Card4x6
    case htmlCard4x6Port
        let htmlStr = PrintTemplate.generateSvgTestAlignment
    case htmlCard4x6Land
        let htmlStr = PrintTemplate.generateSvgTestAlignment
    
    // HTML
    case htmlLetterPortHtmlJs
        let htmlStr = StringHtmlUtil.doHtmlAssembly()
    case htmlLetterLand
        htmlStr = PrintTemplate.generateSvgTestAlignment
    
}


testPattern = TestPattern.jsonTagBook
```

## Resources 

* [StackOverflow: Determine String bounding box in portable Swift? ⇗](https://stackoverflow.com/questions/56548870/determine-string-bounding-box-in-portable-swift)