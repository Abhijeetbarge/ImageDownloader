//
//  ImageDataModel.swift
//  ImageDownloader
//
//  Created by Abhijeet on 23/05/18.
//

import UIKit

class ImageDataModel: NSObject {

    var imageURL : String?
    var image : UIImage?
    var isDownloaded = false
    
    init(imageURL : String) {
        self.imageURL = imageURL
    }
}
