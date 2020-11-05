//
//  FeedLoad.swift
//  Pixel
//
//  Created by Admin on 11/5/20.
//

import UIKit

class FeedLoad: NSObject, XMLParserDelegate {
    
    private var parserCompletionHandler: (([RSSItem]) -> Void)?
    
    func loadFeed(url: String, comletionHandler: (([RSSItem]) -> Void)?) {
        
        let file = "file.txt"
        
        self.parserCompletionHandler = comletionHandler
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {

                if let error = error {
                    print(error.localizedDescription)
                }

                return
            }
            
            let fileData = String(decoding: data, as: UTF8.self)
            // parse data
            _ = Parser(data: data, parserCompletionHandler: self.parserCompletionHandler)
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

                let fileURL = dir.appendingPathComponent(file)
                //writing
                do {
                    try fileData.write(to: fileURL, atomically: false, encoding: .utf8)
                }
                catch (let error){
                    print("Error: ------- \(error)")
                }
            }
        }
        task.resume()
    }
}
