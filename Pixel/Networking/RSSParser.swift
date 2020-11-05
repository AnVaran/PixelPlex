//
//  RSSParser.swift
//  Pixel
//
//  Created by Admin on 03.11.2020.
//

import Foundation
import SwiftSoup

struct RSSItem {
    var imageURL: String
    var title: String
    var auther: String
    var pubDate: String
    var description: String
}

class Parser: NSObject, XMLParserDelegate {
    
    private var parserCompletionHandler: (([RSSItem]) -> Void)?
    
    init(data: Data, parserCompletionHandler: (([RSSItem]) -> Void)?) {
        super.init()
        self.parserCompletionHandler = parserCompletionHandler
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        
    }
    
    private var rssItems: [RSSItem] = []
    private var currentElement = ""
    private var sendText: String = "" {
        didSet {
            sendText = sendText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentImage: String = "" {
        didSet {
            currentImage = currentImage.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentAuther: String = ""{
        didSet {
            currentAuther = currentAuther.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate: String = ""{
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentImage = ""
            currentAuther = ""
            currentPubDate = ""
            currentTitle = ""
            currentDescription = ""
        }
        if currentElement == "enclosure" {
            if let imageUrl = attributeDict["url"] {
                currentImage = imageUrl
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "atom:name": currentAuther += string
        case "pubDate": currentPubDate += string
        case "title": currentTitle += string
        case "description": currentDescription += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            do {
                let doc: Document = try SwiftSoup.parse(currentDescription)
                
                let text: String = try doc.body()!.text()
                sendText = text
            } catch Exception.Error(type: _, Message: let messege) {
                print(messege)
            } catch {
                print("error")
            }
            let rssItem = RSSItem(imageURL: currentImage, title: currentTitle, auther: currentAuther, pubDate: currentPubDate, description: sendText)
            self.rssItems.append(rssItem)
        } 
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print(currentElement)
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
 
