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
    
    
    @IBOutlet weak var LocalTextField: NSTextField!
    @IBOutlet weak var TextField: NSTextField!
    @IBOutlet weak var Indicator: NSProgressIndicator!
    @IBOutlet weak var Status: NSTextField!
    @IBOutlet weak var LocalName: NSTextField!
    var ManagedContext: NSManagedObjectContext?
    
    @IBAction func AddLocal(_ sender: Any) {
        print("saving local")
        if LocalTextField != nil, LocalName != nil, ManagedContext != nil{
            let file = Tool(context: ManagedContext!)
            file.fileAdress = LocalTextField.stringValue
            file.name = LocalName!.stringValue
            file.adress = ""
            file.body = ""
            file.headline = ""
            file.id = UUID()
            print(file)
            do{
                try ManagedContext!.save()
            } catch {
                print(error)
            }
            self.dismiss(self)
        }
    }
    
    @IBAction func Start(_ sender: Any) {
        Indicator.isIndeterminate = true
        Indicator.startAnimation(self)
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
            self.Indicator.stopAnimation(self)
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        Indicator.doubleValue = 0.0
        
        //connecting managed object context
        let delegate = NSApplication.shared.delegate as! AppDelegate
        ManagedContext = delegate.persistentContainer.viewContext
    }
    
    override var representedObject: Any?{
        didSet{
            
        }
    }
}
