//
//  ViewController.swift
//  ImageDownloader
//
//  Created by Abhijeet on 23/05/18.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var imageTable: UITableView!
    @IBAction func startDownload(_ sender: Any) {
        if let path = Bundle.main.path(forResource: "data", ofType: "plist") {
            //If your plist contain root as Array
            if let array = NSArray(contentsOfFile: path) {
                var index  = 1
                for urlStr in array {
                    let imageModel  = ImageDataModel(imageURL: urlStr as! String)
                    self.imageArr.append(imageModel)
                    CoreDataAccessor.saveImageDetails(imageURL: urlStr as! String ,index: Int64(index))
                    index = index + 1
                }
            }
        }
        imageInformationArr = CoreDataAccessor.getImageDetails()
        imageTable.reloadData()
    }
    @IBAction func clearCache(_ sender: Any) {
        let isClearedCache =  CoreDataAccessor.clearCache()
        print("Cache cleared Succefully : \(isClearedCache)")
        imageInformationArr = CoreDataAccessor.getImageDetails()
        imageTable.reloadData()
    }
    var imageArr = Array<ImageDataModel>()
    var imageInformationArr = Array<ImageInformation>()
    
    let downloadQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.name = "download_queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.imageInformationArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        cell.cellImage.image = nil
        cell.activityIndicator.startAnimating()
        //let imageModel = self.imageArr[indexPath.row]
          let imageModel = imageInformationArr[indexPath.row]
        if !imageModel.isDownloaded {
            print("Downloading image for indexpath : \(indexPath.row)")
            let downloader = DownloadOperation(imageModel: imageModel)
            cell.activityIndicator.startAnimating()
            downloadQueue.addOperation(downloader)
            downloader.completionBlock = {
                print("Downlaoded image for indexpath : \(indexPath.row)")
                DispatchQueue.main.async {
                    cell.cellImage.image =  UIImage(data: (downloader.imageObj?.imageData)! as Data)
                    cell.activityIndicator.stopAnimating()
                }
            }
        }else {
            print("Image Using from cache for indexpath : \(indexPath.row)")
            cell.cellImage.image = UIImage(data: imageModel.imageData! as Data)
            cell.activityIndicator.stopAnimating()
        }
        return cell
    }
}
