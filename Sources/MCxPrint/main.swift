import MCxPrintCore

let tool = MCxPrint()

do {
    try tool.run()
} catch {
    print("MCxPrint error: \(error)")
}

