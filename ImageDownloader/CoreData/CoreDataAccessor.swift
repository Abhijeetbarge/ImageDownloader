//
//  CoreDataAccessor.swift
//  ImageDownloader
//
//  Created by Abhijeet on 23/05/18.
//

import UIKit
import CoreData

class CoreDataAccessor: NSObject {
    
    static let  moc = CoreDataManager().managedObjectContext
    
    //MARK: coredata functions
    static func saveImageDetails(imageURL : String, index : Int64) {
        
        
        var imageDetails = self.getImageInformationForID(ID: index)
        
        if imageDetails == nil {
            imageDetails = NSEntityDescription.insertNewObject(forEntityName: "ImageInformation", into: moc) as? ImageInformation
        }
        imageDetails?.imageURL = imageURL
        imageDetails?.id = index
        saveContext()
        
        /*
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         let registrationGUID = appDelegate.defaults.object(forKey: Constants.General.kRegistrationGUID) as? String
         var savedPCDetails =  self.getRegisteredDeviceForRegistartionId(registrationGUID!)
         if savedPCDetails == nil {
         savedPCDetails = NSEntityDescription.insertNewObject(forEntityName: "RegisteredDevice", into: moc) as? RegisteredDevice
         }
         if let windowsEdition = value["windowsEdition"] as? String {
         savedPCDetails?.windowsEdition = windowsEdition
         }
         if let processor = value["processor"] as? String {
         savedPCDetails?.processor = processor
         }
         if let memory = value["memory"] as? String {
         savedPCDetails?.memory = memory
         }
         if let graphicsDictionary = value["graphics"] {
         do {
         let jsonData = try JSONSerialization.data(withJSONObject: graphicsDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
         savedPCDetails?.display = jsonData as NSData
         } catch let error as NSError {
         print(error)
         }
         }
         if let storageDictionary = value["storage"] {
         do {
         let jsonData = try JSONSerialization.data(withJSONObject: storageDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
         savedPCDetails?.storage = jsonData as NSData
         } catch let error as NSError {
         print(error)
         }
         }
         if let computerName = value["computerName"] as? String {
         savedPCDetails?.computerName = computerName
         }
         if let productName = value["productName"] as? String {
         savedPCDetails?.productName = productName
         }
         if let productId = value["serialNumber"] as? String {
         savedPCDetails?.productId = productId
         savedPCDetails?.pcSerialNo = productId
         }
         if let isAccelerometerSupported = value["isAccelerometerSupported"] as? Bool {
         savedPCDetails?.isAccelerometerSupported = isAccelerometerSupported
         } else {
         savedPCDetails?.isAccelerometerSupported = false
         }
         if let chassisType = value["chassis"] as? String {
         log.debug("Chassis Type PC sent is :\(chassisType)")
         if chassisType == "laptop" || chassisType == "tablet" || chassisType == "desktop" {
         savedPCDetails?.chassis = chassisType
         }
         }
         
         savedPCDetails?.timeStamp = value["timestamp"] as? String
         savedPCDetails?.pcRegId = registrationGUID
         savedPCDetails?.color = "RED"
         savedPCDetails?.isActive = true
         
         do {
         if moc.hasChanges {
         try moc.save()
         }
         } catch  {
         fatalError("Failed to save pc deatils context")
         }
         if savedPCDetails?.settings == nil {
         saveDefaultSettings()
         }
         */
    }
    
    //MARK: get registered Device
    static  func getImageInformationForID(ID : Int64) -> ImageInformation? {
        
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageInformation")
        request.predicate = NSPredicate(format: "id == %d", ID)
        do {
            let result : [AnyObject] = try moc.fetch(request)
            if result is [ImageInformation] && result.count>0{
                return result[0] as? ImageInformation
            }
        }
        catch
        {
            print("Error \(String(describing: error))")
        }
        return nil
    }
    
    func updateImageInformation(imageURL: String, imageData: Data) {
        
    }
    
    //MARK: get registered Device
    static  func getImageDetails() -> [ImageInformation] {
        
         let resultArray : [AnyObject] = []
         
         let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageInformation")
         do {
         let result : [AnyObject] = try moc.fetch(request)
         if result is [ImageInformation]{
         return result as! [ImageInformation]
         }
         }
         catch
         {
         print("Error \(String(describing: error))")
         }
         return resultArray as! [ImageInformation]//return empty array
    }
    
    //MARK: deletePcDetails
    static func clearCache() -> Bool {
        var isDeleted : Bool = false
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageInformation") 
        do {
            let result : [AnyObject] = try moc.fetch(request)
            if result.count != 0 {
                //let entity = result[0] as! NSManagedObject
                for entity in result {
                    moc.delete(entity as! NSManagedObject)
                    do {
                        if moc.hasChanges {
                            try moc.save()
                        }
                        isDeleted = true
                    } catch  {
                        fatalError("Failed to update pc deatils context")
                    }
                }
            }
        }
        catch
        {
            print("Error pc details updation failed : \(String(describing: error))")
        }
        return isDeleted
    }
    
    static func saveContext (){
        do {
            if moc.hasChanges {
                try moc.save()
            }
        } catch  {
            fatalError("Failed to save events context")
        }
    }
}

