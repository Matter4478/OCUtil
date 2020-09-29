//
//  GenSMBIOS.swift
//  OCUtil
//
//  Created by M. De Vries on 25/09/2020.
//  Copyright © 2020 M. De Vries. All rights reserved.
//

import Foundation
import Cocoa
import PythonKit
class GenSMBIOSViewController: NSViewController{
    @IBAction func OpenHelp(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://github.com/Matter4478/OCUtil/blob/master/README.md")!)
    }
    @IBAction func SelectedModel(_ sender: Any) {
        print("selectedModel")
        if macTypeSelect.titleOfSelectedItem == "iMac"{
            macGenSelect.removeAllItems()
            macGenSelect.addItems(withTitles: ["10,1","11,1","11,2","11,3","12,1","12,2","13,1","13,2","13,3","14,1","14,2","14,3","14,4","15,1","16,1","16,2","17,1","18,1","18,2","18,3","19,1","19,2"])
            
        } else if macTypeSelect.titleOfSelectedItem == "iMacPro" {
            macGenSelect.removeAllItems()
            macGenSelect.addItems(withTitles: ["1,1"])
        } else if macTypeSelect.titleOfSelectedItem == "Macmini" {
            macGenSelect.removeAllItems()
            macGenSelect.addItems(withTitles: ["1,1","2,1","3,1","4,1","5,1","5,2","5,3","6,1","6,2","7,1","8,1"])
        } else if macTypeSelect.titleOfSelectedItem == "MacBookPro"{
            macGenSelect.removeAllItems()
            macGenSelect.addItems(withTitles: ["1,1","1,2","2,1","3,1","4,1","5,1","5,2","5,3","5,4","5,5","6,1","6,2","7,1","8,1","8,2","8,3","9,1","9,2","10,1","10,2","11,1","11,2","11,3","11,4","11,5","12,1","13,1","13,2","13,3","14,1","14,2","14,3","15,1","15,2","15,3","15,4","16,1"])
        } else if macTypeSelect.titleOfSelectedItem == "MacPro"{
            macGenSelect.removeAllItems()
            macGenSelect.addItems(withTitles: ["1,1","2,1","3,1","4,1","5,1","6,1","7,1"])
        } else if macTypeSelect.titleOfSelectedItem == "MacBook"{
            macGenSelect.removeAllItems()
            macGenSelect.addItems(withTitles: ["1,1","2,1","3,1","4,1","5,1","5,2","6,1","7,1","8,1","9,1","10,1"])
        } else if macTypeSelect.titleOfSelectedItem == "MacBookAir" {
            macGenSelect.removeAllItems()
            macGenSelect.addItems(withTitles: ["1,1","2,1","3,1","3,2","4,1","4,2","5,1","5,2","6,1","6,2","7,1","7,2","8,1","8,2","9,1"])
        } else if macTypeSelect.titleOfSelectedItem == "Xserve"{
            macGenSelect.removeAllItems()
            macGenSelect.addItems(withTitles: ["1,1","2,1","3,1"])
        }
    }
    @IBOutlet var macTypeSelect: NSPopUpButton!
    @IBOutlet var macGenSelect: NSPopUpButton!
    @IBAction func Generate(_ sender: Any) {
        var targetURL = Bundle.main.bundleURL
        targetURL.appendPathComponent("Contents/Resources/ScriptsGenSMBIOS/macserial")
        
        //creating inter process communication pipes
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        //setting up macserial
        let serial = Process.init()
        serial.arguments = ["-a"]
        serial.executableURL = targetURL
        serial.standardOutput = outputPipe
        serial.standardError = errorPipe
        
        //executing mac serial
        do {
            try serial.run()
        } catch {
            print(error)
        }
        
        //getting the selected mac model as a string
        var mactype = macTypeSelect.titleOfSelectedItem ?? "iMac"
        mactype.append(macGenSelect.titleOfSelectedItem ?? "1,1")
        print(mactype)
        
        //handling the resulting output
        let result = String(decoding: outputPipe.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self)
        print(result)
        
        //filtering for our selected mac model
        var genOutput: [String] = []
        for line in result.split(separator: "\n"){
            let newLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if newLine.starts(with: mactype ){
                genOutput.append(newLine)
            }
        }
        print(genOutput)
        
        //converting to UI output
        for line in genOutput{
            
            let stripped = line.split(separator: "|")
            var res: [String] = []
            stripped.forEach { (sub) in
                res.append(sub.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            macType.stringValue = res[0]
            Serial.stringValue = res[1]
            BoardSerial.stringValue = res[2]
            SmUUID.stringValue = UUID().uuidString.uppercased()
        }
        
        
        //if there's somesort of error... Look here!
        let error = String(decoding: errorPipe.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self)
        print(error)
    }

    
    @IBOutlet weak var macType: NSTextField!
    @IBOutlet weak var Serial: NSTextField!
    @IBOutlet weak var BoardSerial: NSTextField!
    @IBOutlet weak var SmUUID: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        macGenSelect.addItems(withTitles: ["10,1","11,1","11,2","11,3","12,1","12,2","13,1","13,2","13,3","14,1","14,2","14,3","14,4","15,1","16,1","16,2","17,1","18,1","18,2","18,3","19,1","19,2"])
    }
    
    override var representedObject: Any?{
        didSet{
            
        }
    }
}
