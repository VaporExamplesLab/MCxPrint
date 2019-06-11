import MCxPrintLabelCore

let tool = MCxPrintLabel()

do {
    try tool.run()
} catch {
    print("MCxPrintLabel error: \(error)")
}

