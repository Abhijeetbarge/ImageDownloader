//
//  DownloadOperation.swift
//  ImageDownloader
//
//  Created by Abhijeet on 23/05/18.
//

import UIKit

class DownloadOperation: Operation {

    //var imageURL:String!
    //var image : UIImage?
    var imageObj : ImageInformation?
    
     init( _ urlToDownload:String) {
        //super.init()
        //imageURL = urlToDownload
    }
    
//    init(imageModel :ImageDataModel) {
//        //super.init()
//        imageObj = imageModel
//    }
    init(imageModel :ImageInformation) {
        //super.init()
        imageObj = imageModel
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        do {
            let data = try Data(contentsOf: NSURL(string: (self.imageObj?.imageURL!)!)! as URL, options: [])
            self.imageObj?.imageData = data as NSData
            self.imageObj?.isDownloaded = true
            CoreDataAccessor.saveContext()
        }catch {
            print(error.localizedDescription)
        }
    }
}
