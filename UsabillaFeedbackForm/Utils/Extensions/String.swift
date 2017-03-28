//
//  String.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

extension String {
    
    func divideInChunksOfSize(_ chuckSize: Int) -> [String] {
        var arrayToReturn: [String] = []
        let screenshotCharacterCount = self.characters.count
        let numberOfChunks = screenshotCharacterCount / chuckSize
        let lastChunk = screenshotCharacterCount % chuckSize
        
        if numberOfChunks > 0 {
            for chunk in 0...numberOfChunks - 1 {
                let start = chunk * chuckSize
                let range = NSRange(location: start, length: chuckSize)
                let section = (self as NSString).substring(with: range)
                arrayToReturn.append(section)
            }
        }
        if lastChunk > 0 {
            let lastRange = NSRange(location: numberOfChunks * chuckSize, length: lastChunk)
            let section = (self as NSString).substring(with: lastRange)
            arrayToReturn.append(section)
        }
        
        return arrayToReturn
    }
    
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            PLog(error.localizedDescription)
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    
}
