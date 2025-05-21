//
//  LogHelper.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import Foundation

struct LogHelper {
    
    private init() {}
    
    static func log(_ text: String? = nil, filePath: String = #filePath, function: String = #function, line: Int = #line) {
        
        var printText = "[BlindIDCase]"
        
        printText += "[" + Self.fileName(filePath: filePath) + "]"
        printText += "[" + function + "]"
        printText += "[" + String(line) + "]"
        printText += ": "
        
        if let text {
            printText += text
        }
        
        print(printText)
    }
    
    private static func fileName(filePath: String) -> String {
        let file = filePath.components(separatedBy: "/").last
        return file?.components(separatedBy: ".").first ?? ""
    }
}
