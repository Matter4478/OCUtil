//
//  InitiateDownload.swift
//  OCUtil
//
//  Created by M. De Vries on 15/09/2020.
//  Copyright © 2020 M. De Vries. All rights reserved.
//

import Foundation
import Cocoa
import Alamofire
import ZIPFoundation

class InitiateDownload: NSViewController{
    
    
    @IBOutlet weak var TextField: NSTextField!
    @IBOutlet weak var Indicator: NSProgressIndicator!
    @IBOutlet weak var Status: NSTextField!
    
    @IBAction func Start(_ sender: Any) {
        Indicator.isIndeterminate = true
        Status.stringValue = "Resolving URL..."
        
        let targeturl = URL(string: "file://\(rootPath)")
        var zipurl = targeturl
        zipurl?.appendPathComponent("\(UUID().uuidString).zip")
        var extracturl = targeturl
        extracturl?.appendPathComponent("\(UUID().uuidString)/")
        
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = URL(string: zipurl!.absoluteString)
            
            let fileURL = documentsURL!.appendingPathComponent("\(UUID().uuidString).zip")

                       return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
               }

        AF.download(TextField.stringValue, to: destination).response { response in
                   print(response)
            if response.error != nil{
                print(response.error)
                self.Indicator.isIndeterminate = false
                self.Status.stringValue = "Couldn't download package!"
            }
                    
                   if response.error == nil, let result = response.fileURL?.path {
                    print(response)
                    print("resulted path: \(result)")
                    self.Status.stringValue = "Unpacking..."
                    if result.contains(".zip"){
                        do {
                            try FileManager.default.createDirectory(at: extracturl!, withIntermediateDirectories: false, attributes: [:])
                            try FileManager.default.unzipItem(at: response.fileURL!, to: targeturl!)
                            try FileManager.default.removeItem(at: response.fileURL!)
                        } catch {
                            print(error)
                            self.Status.stringValue = "Failed to extract! \(error)"
                        }
                    }
                    
                    self.Indicator.isIndeterminate = false
                    self.Status.stringValue = "Succes!"
                    NotificationCenter.default.post(Notification(name: MainViewController.notificationName, object: nil, userInfo: ["Refresh" : true]))
                    self.dismiss(self)
                    
            }
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        Indicator.doubleValue = 0.0
        
    }
    
    override var representedObject: Any?{
        didSet{
            
        }
    }
}
