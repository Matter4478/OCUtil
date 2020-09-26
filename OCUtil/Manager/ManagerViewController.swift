//
//  ManagerViewController.swift
//  OCUtil
//
//  Created by M. De Vries on 12/09/2020.
//  Copyright © 2020 M. De Vries. All rights reserved.
//

import Foundation
import Cocoa


class ManagerViewController: NSViewController{
    var ManagedContext: NSManagedObjectContext?
    var items: [Tool] = []
    
    @IBAction func Launch(_ sender: Any) {
        let app = URL(fileURLWithPath: selected.runAdress, isDirectory: false)
        NSWorkspace.shared.open(app)
//        do {
//            try Process.run(app, arguments: []) { (process) in
//            print(process)
//            }
//        } catch {
//            print(error)
//        }
    }

    @IBAction func LocalFiles(_ sender: Any) {
        let url = URL(fileURLWithPath: selected.fileAdress, isDirectory: true)
        NSWorkspace.shared.open(url)
    }
    @IBAction func Remove(_ sender: Any) {
            do{
                try FileManager.default.removeItem(at: URL(fileURLWithPath: selected.fileAdress))
                items.forEach{ item in
                    if item.fileAdress == selected.fileAdress{
                        do{
                            ManagedContext?.delete(item)
                            try ManagedContext?.save()
                            self.dismiss(self)
                        } catch {
                            print(error)
                        }
                    }
                }
                
                
                NotificationCenter.default.post(Notification(name: MainViewController.notificationName, object: nil, userInfo: ["Refresh" : true]))
                selected = OutlineFeed.init(name: "No Application Selected", adress: "", id: UUID(), headline: "", body: "", fileAdress: "", runAdress: "")
                self.dismiss(self)
            } catch {
                print(error)
            }
    }
    @IBOutlet weak var Name: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        Name.stringValue = selected.name
        
        //connecting managed object context
        let delegate = NSApplication.shared.delegate as! AppDelegate
        ManagedContext = delegate.persistentContainer.viewContext
        
        //fetching data
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Tool")
        print(ManagedContext)
        do {
            items = try ManagedContext?.fetch(fetch) as! [Tool]
        } catch {
            print(error)
        }
    }
    
    
    override var representedObject: Any?{
        didSet{
            
        }
    }
}
