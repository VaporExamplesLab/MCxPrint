import MCxPrintCore

let tool = MCxPrintCore()

do {
    try tool.run()
} catch {
    print("MCxPrintCore error: \(error)")
}

