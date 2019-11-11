//
//  DataRetriever.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/7/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import Foundation

protocol DataRetrieverProtocol: class {
    func parseJSON(_ data: Data)
    var urlString: String { get }
}



class DataRetriever: NSObject, URLSessionDataDelegate {
    
    weak var delegate: DataRetrieverProtocol!
    
    func downloadItems() {
        var data = Data()
        let urlPath: String = delegate.urlString
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                self.delegate.parseJSON(data!)
            }
        }
        
        task.resume()
    }
    
    
}
