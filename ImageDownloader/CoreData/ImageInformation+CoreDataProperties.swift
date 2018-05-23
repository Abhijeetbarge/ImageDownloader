//
//  ImageInformation+CoreDataProperties.swift
//  ImageDownloader
//
//  Created by Abhijeet on 23/05/18.
//
//

import Foundation
import CoreData


extension ImageInformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageInformation> {
        return NSFetchRequest<ImageInformation>(entityName: "ImageInformation")
    }

    @NSManaged public var imageURL: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var isDownloaded: Bool
    @NSManaged public var id: Int64

}
