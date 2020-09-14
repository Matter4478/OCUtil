//
//  MainViewController.swift
//  OCUtil
//
//  Created by M. De Vries on 12/09/2020.
//  Copyright © 2020 M. De Vries. All rights reserved.
//

import Foundation
import Cocoa

var selected: OutlineFeed = OutlineFeed(name: "", adress: "", id: UUID(), headline: "", body: "", fileAdress: "", runAdress: "/Volume/MacOS/")

var data: [OutlineFeed] = []

class MainViewController: NSViewController{
    
    var content: [String] = []
    
    func checkFolder(root: String){
        do {
            content = try FileManager.default.contentsOfDirectory(atPath: root)
            print("App directory contains: \(content)")
        } catch {
            print(error)
        }
        
        content.forEach{item in
            let dirurl = URL(string: root)
            let url = dirurl?.appendingPathComponent(item)
            
            if (url?.absoluteString.contains(".app"))!{
                print("\(url?.absoluteString ?? "") is an executable .app")
                let result = OutlineFeed(name: item, adress: "", id: UUID(), headline: "", body: "", fileAdress: dirurl?.absoluteString ?? "", runAdress: url?.absoluteString ?? "")
                data.append(result)
                print(result)
            } else if (url?.absoluteString.contains(".command"))!{
                print("\(url?.absoluteString ?? "") is an executable .command")
                let result = OutlineFeed(name: item, adress: "", id: UUID(), headline: "", body: "", fileAdress: dirurl?.absoluteString ?? "", runAdress: url?.absoluteString ?? "")
                data.append(result)
                print(result)
            } else {
                print("\(url?.absoluteString ?? "") was not an executable file")
                var dir: ObjCBool = false
                print("\(url?.absoluteString ?? "") is directory: \(dir.boolValue)")
                FileManager.default.fileExists(atPath: url!.absoluteString, isDirectory: &dir)
                if dir.boolValue == true {
                    checkFolder(root: url!.absoluteString)
                }
            }
            
            
        }
    }
    
    

    
    
    @IBOutlet var ManagedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var Outline: NSOutlineView!
    
    @IBAction func LaunchUtil(_ sender: Any) {
        print("Launching \(selected.name) ")
        let app = URL(fileURLWithPath: selected.runAdress, isDirectory: false)
        NSWorkspace.shared.open(app)
    }
    @IBAction func ManageUtil(_ sender: Any) {
        print("Managing \(selected.name)")
        self.performSegue(withIdentifier: "ManagerSegue", sender: self)
    }
    
    @IBOutlet weak var UtilName: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainViewController: viewDidLoad()")
        
        
        let root = FileManager.default.currentDirectoryPath
        checkFolder(root: root)

        
        Outline.outlineTableColumn?.headerCell.stringValue = "Utilities"
        Outline.dataSource = self
        Outline.delegate = self
        
        
        //Outline.outlineTableColumn!.headerCell.stringValue = "Utilities"
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
        if let item = Outline.item(atRow: Outline.selectedRow) as? OutlineFeed{
            selected = item
            UtilName.stringValue = selected.name
        }
    }

}


