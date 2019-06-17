//
//  StringHtmlExtension.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.11.
//

import Foundation

public extension String {
    
    
    public mutating func htmlWrapHead() {
    }
    
    public mutating func htmlWrapBody() {
    }
    
    public mutating func htmlWrapTag() {
    }
    
    public mutating func htmlWrapMinimal() {
        
        var encloseBefore = ""
        var encloseAfter = ""
        
        encloseBefore.append("<!DOCTYPE html> \n")
        encloseBefore.append("<html lang=en> \n")
        encloseBefore.append("<head> \n")
        encloseBefore.append("<meta charset=utf-8> \n")
        encloseBefore.append("<title>HTML Title</title> \n")
        // Internal/Embedded Style Sheet
        encloseBefore.append("<style> \n")
        encloseBefore.append("body { margin: 0; padding: 0; } \n")
        encloseBefore.append("</style> \n")
        encloseBefore.append("</head> \n")
        encloseBefore.append("<body> \n")
        
        encloseAfter.append("</body> \n")
        encloseAfter.append("</html> \n")
        
        self = encloseBefore + self + encloseAfter
    }
    
    public mutating func htmlWrap(bootstrap: Bool = true, highlight: Bool = true, math: Bool = true) {
        
        var encloseBefore = ""
        var encloseAfter = ""
        
        encloseBefore.append("<!DOCTYPE html> \n")
        encloseBefore.append("<html lang=en> \n")
        encloseBefore.append("<head> \n")
        encloseBefore.append("<meta charset=utf-8> \n")
        
        encloseBefore.append("<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"> \n")
        encloseBefore.append("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"> \n")
        encloseBefore.append("<!-- Bootstrap: above 3 meta tags *must* come first in the head --> \n")
        
        //encloseBefore.append("<link rel="icon" href=\"file:///opt/site/favicon.ico\"> \n")
        //encloseBefore.append("<link rel="apple-touch-icon" href=\"file:///opt/site/img/apple-touch-icon.png\"> \n")
        
        encloseBefore.append("<title>HTML Title</title> \n")
        
        if bootstrap {
            encloseBefore.append("<!-- Bootstrap --> \n")
            encloseBefore.append("<link href=\"file:///opt/site/css/bootstrap.min.css\" rel=\"stylesheet\"> \n")
            encloseBefore.append("<link href=\"file:///opt/site/css/style-common.css\" rel=\"stylesheet\" type=\"text/css\" media=\"all\"> \n")
            encloseBefore.append("<link href=\"file:///opt/site/css/style-reference.css\" rel=\"stylesheet\"> \n")
        }
        
        if highlight {
            encloseBefore.append("<!-- Highlight.js --> \n")
            encloseBefore.append("<link rel=\"stylesheet\" href=\"file:///opt/site/highlight/styles/mmmmmed.css\" > \n")
            encloseBefore.append("<!-- link rel=\"stylesheet\" href=\"file:///opt/site/highlight/styles/xcode.css\" --> \n")
        }
        
        
        if math {
            encloseBefore.append("<!-- MathJax --> \n")
            encloseBefore.append("<script type=\"text/javascript\" async src=\"file:///opt/site/mathjax/MathJax.js?config=TeX-AMS_SVG\"></script> \n")
        }
        
        //// Internal/Embedded Style Sheet
        //encloseBefore.append("<style> \n")
        //encloseBefore.append("body { margin: 0; padding: 0; } \n")
        //encloseBefore.append("</style> \n")
        
        encloseBefore.append("</head> \n")
        encloseBefore.append("<body> \n")
        encloseBefore.append("<!-- div class=\"container\" --> \n")
        encloseBefore.append("<!-- :COMMON: HEADER --> \n")
        
        encloseAfter.append("<!-- :COMMON: FOOTER --> \n")
        encloseAfter.append("<!-- /div --> <!-- /container --> \n")
        
        if bootstrap {
            encloseAfter.append("<!-- Bootstrap --> \n")
            encloseAfter.append("<!-- jQuery (necessary for Bootstrap's JavaScript plugins) --> \n")
            encloseAfter.append("<script src=\"file:///opt/site/js/jquery.min.js\"></script> \n")
            encloseAfter.append("<!-- Include all compiled plugins (below), or include individual files as needed --> \n")
            encloseAfter.append("<script src=\"file:///opt/site/js/bootstrap.min.js\"></script> \n")
        }
        
        if highlight {
            encloseAfter.append("<!-- Highlight.js --> \n")
            encloseAfter.append("<script src=\"file:///opt/site/highlight/highlight.pack.js\" ></script> \n")
            encloseAfter.append("<script>hljs.initHighlightingOnLoad();</script> \n")
        }
        
        encloseAfter.append("</body> \n")
        encloseAfter.append("</html> \n")
        
        self = encloseBefore + self + encloseAfter
    }
    
}

