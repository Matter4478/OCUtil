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
    class macSerials: NSObject, PythonConvertible{
        var pythonObject: PythonObject = []
        
        var MacType: String = ""
        var Serial: String = ""
        var BoardSerial: String = ""
        var SmUUID: String = ""
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
        let mactype = macTypeSelect.state.rawValue
        let macGen = macGenSelect.state.rawValue
        var smtype: String = ""
        if mactype == 0{
            smtype = "iMac"
        } else if mactype == 1{
            smtype = "MacBookPro"
        } else {
            smtype = "MacPro"
        }
        if macGen == 0{
            smtype.append("18,3")
        } else if macGen == 1{
            smtype.append("16,1")
        } else {
            smtype.append("16,1")
        }
        print(smtype)
        
        //handling the resulting output
        let result = String(decoding: outputPipe.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self)
        //print(result)
        
        //filtering for our selected mac model
        var genOutput: [String] = []
        for line in result.split(separator: "\n"){
            let newLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if line.starts(with: smtype){
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
        
        
        
//        let sys = Python.import("sys")

//        var targetString = targetURL.absoluteString
//        targetString.removeFirst(7)
//        sys.path.append(targetString)
//        print(sys.path)
//        let smbios = Python.import("GenSMBIOS")
//        print(smbios)
//        let Smbios = smbios.Smbios()
//        print(Smbios)
//        let macserial = Smbios._get_binary()
//        print(macserial)
//        let macType = macTypeSelect.state.rawValue
//        let macGen = macGenSelect.state.rawValue
//        var smtype: String = ""
//        if macType == 0{
//            smtype = "iMac"
//        } else if macType == 1{
//           smtype = "MacBookPro"
//        } else {
//            smtype = "MacPro"
//        }
//        if macGen == 0{
//            smtype.append("18,3")
//        } else if macGen == 1{
//            smtype.append("17,1")
//        } else {
//            smtype.append("16,1")
//        }
//        print(smtype)
//        let result = Smbios.s._get_smbios(Smbios, macserial, smtype)
//        print(result)
//
        
    }

    
    @IBOutlet weak var macType: NSTextField!
    @IBOutlet weak var Serial: NSTextField!
    @IBOutlet weak var BoardSerial: NSTextField!
    @IBOutlet weak var SmUUID: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var representedObject: Any?{
        didSet{
            
        }
    }
}
