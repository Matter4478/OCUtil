//
//  ViewController.swift
//  OCUtil
//
//  Created by M. De Vries on 11/09/2020.
//  Copyright © 2020 M. De Vries. All rights reserved.
//

import Cocoa
import CoreData



class PlistViewController: NSViewController {
    
    @IBOutlet var Outline: NSOutlineView!
    
    
    
    var data: [OutlineFeed] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = [OutlineFeed(name: "Sorry", adress: "https://worldwideweberror.404", id: UUID(), headline: "I will not do this", body: "and I will also do not that.", fileAdress: "/Users/mdevries/Downloads/GenSMBIOS-master", runAdress: "/Volumes/sda/"), OutlineFeed.init(name: "", adress: "", id: UUID(), headline: "", body: "", fileAdress: "", runAdress: "")]
        
        //Do any additional setup after loading the view.
        
        Outline.dataSource = self
        Outline.delegate = self
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension PlistViewController: NSOutlineViewDataSource{
    

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let data = item as? OutlineFeed{
            return data.name
        }
        return data[index]
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let data = item as? OutlineFeed{
            return false
        }
        return false
    }

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int{
        return 1
    }
}

extension PlistViewController: NSOutlineViewDelegate{
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any ) -> NSView? {
        var text = ""
        if let data = item as? OutlineFeed{
            text = data.name
        } else {
            text = item as! String
        }
        let tableCell = Outline.makeView(withIdentifier: NSUserInterfaceItemIdentifier("UtilCell"), owner: self) as! NSTableCellView
        tableCell.textField!.stringValue = text
        return tableCell
    }
}
