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
    @IBAction func Update(_ sender: Any) {
        //NSWorkspace.shared.open(<#T##url: URL##URL#>)
    }
    @IBAction func LocalFiles(_ sender: Any) {
        let url = URL(fileURLWithPath: selected.fileAdress, isDirectory: true)
        NSWorkspace.shared.open(url)
    }
    @IBAction func Remove(_ sender: Any) {
            do{
                try FileManager.default.removeItem(atPath: selected.fileAdress)
            } catch {
                print(error)
            }
        dismiss(self)
    }
    @IBOutlet weak var Name: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        Name.stringValue = selected.name
    }
    
    override var representedObject: Any?{
        didSet{
            
        }
    }
}
