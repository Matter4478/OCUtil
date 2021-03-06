//
//  MainViewController.swift
//  OCUtil
//
//  Created by M. De Vries on 12/09/2020.
//  Copyright © 2020 M. De Vries. All rights reserved.
//

import Foundation
import Cocoa
import CoreData

var selected: OutlineFeed = OutlineFeed(name: "No Application Selected", adress: "", id: UUID(), headline: "", body: "", fileAdress: "", runAdress: "/Volume/MacOS/")

var data: [OutlineFeed] = []

var rootPath: String = ""

class MainViewController: NSViewController{
    
    static let notificationName = Notification.Name("Refresh")
    
    @objc func onNotification(notification: Notification){
        print("refresh ordered")
        Refresh(self)
        
    }
    
    var content: [String] = []
    
    
    @IBAction func GenSMBIOS(_ sender: Any) {
        self.performSegue(withIdentifier: "GenSMBIOS", sender: self)
    }
    @IBAction func mountRootEFI(_ sender: Any) {
        print("mount root efi")
//        var mountEFI = FileManager.default.homeDirectoryForCurrentUser
//        mountEFI.appendPathComponent("/Downloads/MountRootEFI.command")
        var mountEFI = Bundle.main.bundleURL
        mountEFI.appendPathComponent("/Contents/Resources/MountRootEFI.command")

        if #available(OSX 10.15, *) {
            let args = NSWorkspace.OpenConfiguration()
            args.arguments = [""]
            args.promptsUserIfNeeded = true
            args.addsToRecentItems = false
            args.allowsRunningApplicationSubstitution = false
            do {
                try NSWorkspace.shared.open(mountEFI, configuration: args, completionHandler: { (app, error) in
                    print(app)
                    print(error)
                })
            } catch {
                print(error)
            }
        } else {
            // Fallback on earlier versions
            print("fallback")
            NSWorkspace.shared.open(mountEFI)
        }

    }
    
    func checkFolder(root: String){
        do {
            content = try FileManager.default.contentsOfDirectory(atPath: root)
            print("App directory contains: \(content)")
        } catch {
            print(error)
        }
        
        content.forEach{item in
            print(item)
            let dirurl = URL(string: root)
            let url = dirurl!.appendingPathComponent(item)
            print(" file url: \(String(describing: url))")
            print("path url: \(String(describing: dirurl))")
            if (url.absoluteString.contains(".app")){
                print("\(url.absoluteString ) is an executable .app")
                let result = OutlineFeed(name: item, adress: "", id: UUID(), headline: "", body: "", fileAdress: dirurl!.absoluteString , runAdress: url.absoluteString )
                data.append(result)
                print(result)
            } else if (url.absoluteString.contains(".command")){
                print("\(url.absoluteString ) is an executable .command")
                let result = OutlineFeed(name: item, adress: "", id: UUID(), headline: "", body: "", fileAdress:   dirurl!.absoluteString , runAdress: url.absoluteString )
                data.append(result)
                print(result)
            } else if (url.absoluteString.contains(".sh")){
                let result = OutlineFeed(name: item, adress: "", id: UUID(), headline: "", body: "", fileAdress:   dirurl!.absoluteString , runAdress: url.absoluteString )
                data.append(result)
                print(result)
            } else {
                print("\(url.absoluteString ) was not an executable file")
                var dir: ObjCBool = false
                FileManager.default.fileExists(atPath: url.relativePath, isDirectory: &dir)
                print("\(url.absoluteString ) is directory: \(dir.boolValue)")
                if dir.boolValue == true {
                    checkFolder(root: url.absoluteString)
                }
            }
            
            
        }
    }
    
    

    
    
    var ManagedContext : NSManagedObjectContext?
    
    
    @IBOutlet weak var Outline: NSOutlineView!
    
    @IBAction func LaunchUtil(_ sender: Any) {
        print("Launching \(selected.name) ")
        let app = URL(fileURLWithPath: selected.runAdress, isDirectory: false)
        NSWorkspace.shared.open(app)
    }
    @IBAction func ManageUtil(_ sender: Any) {
        if selected.name != "No Application Selected"{
            print("Managing \(selected.name)")
            self.performSegue(withIdentifier: "ManagerSegue", sender: self)
        }
    }
    
    @IBOutlet weak var UtilName: NSTextField!
    
    @IBAction func Refresh(_ sender: Any) {
        data = []
        var root = FileManager.default.homeDirectoryForCurrentUser
        root.appendPathComponent("Downloads/OCUtil")
        if FileManager.default.fileExists(atPath: root.path) == false{
            print("creating OCUtil directory at: \(root.path)")
            do {
                try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true, attributes: [:])
            } catch {
                print(error)
            }
        }
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Tool")
        print(ManagedContext)
        do {
            let result = try ManagedContext?.fetch(fetch) as! [Tool]
            result.forEach { item in
                let outline = OutlineFeed.init(name: item.name, adress: item.adress, id: item.id, headline: item.headline, body: item.body, fileAdress: item.fileAdress, runAdress: item.runAdress)
                data.append(outline)
            }
        } catch {
            print(error)
        }
        rootPath = root.path
        print("root path: \(root)")
        checkFolder(root: root.path)
        Outline.reloadData()
    }
    
    @IBAction func Download(_ sender: Any) {
        self.performSegue(withIdentifier: "Download", sender: self)
    }
    @IBAction func Help(_ sender: Any) {
        print("README.md")
        NSWorkspace.shared.open(URL(string: "https://github.com/Matter4478/OCUtil/blob/master/README.md")!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainViewController: viewDidLoad()")
        
        //adding observer to check if another view wants mainviewcontroller to do a thing
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: NSNotification.Name(rawValue: "Refresh"), object: nil)
        
        //connecting managed object context
        let delegate = NSApplication.shared.delegate as! AppDelegate
        ManagedContext = delegate.persistentContainer.viewContext
        
        //fetching data
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Tool")
        print(ManagedContext)
        do {
            let result = try ManagedContext?.fetch(fetch) as! [Tool]
            result.forEach { item in
                let outline = OutlineFeed.init(name: item.name, adress: item.adress, id: item.id, headline: item.headline, body: item.body, fileAdress: item.fileAdress, runAdress: item.runAdress)
                data.append(outline)
            }
        } catch {
            print(error)
        }
        
        
        
        
        var root = FileManager.default.homeDirectoryForCurrentUser
        root.appendPathComponent("Downloads/OCUtil")
        if FileManager.default.fileExists(atPath: root.path) == false{
            print("creating OCUtil directory at: \(root.path)")
            do {
                try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true, attributes: [:])
            } catch {
                print(error)
            }
        }
        rootPath = root.path
        print("root path: \(root)")
        checkFolder(root: root.path)

        
        Outline.outlineTableColumn?.headerCell.stringValue = "Utilities"
        Outline.dataSource = self
        Outline.delegate = self
        
        
        //Outline.outlineTableColumn!.headerCell.stringValue = "Utilities"
        }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.Refresh(self)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.Refresh(self)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        //stop listening for notifications
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    override var representedObject: Any?{
        didSet{
            
        }
    }
}

extension MainViewController: NSOutlineViewDataSource{
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let data = item as? OutlineFeed{
            return data.name
        }
        return data[index]
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int{
        return data.count
    }
}

extension MainViewController: NSOutlineViewDelegate{
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any ) -> NSView? {
        var text = ""
        if let data = item as? OutlineFeed{
            text = data.name
        } else {
            text = item as! String
        }
        let tableCell = Outline.makeView(withIdentifier: NSUserInterfaceItemIdentifier("DataCell"), owner: self) as! NSTableCellView
        tableCell.textField!.stringValue = text
        return tableCell
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        var item = Outline.item(atRow: Outline.selectedRow) as! OutlineFeed
            selected = item
            UtilName.stringValue = selected.name
    }
}


