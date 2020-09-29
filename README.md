# OCUtil
OCUtil is a simple application to help you organise apps and commands that won't end up in your Application folder on macOS

# Installation
Download release.zip, extract and drag OCUtil.app to Applications.

# Usage
- Add a new utility:
  Press + and select:
  Download: download a tool from github or somewhere else* by pasting the download link or dragging an extracted folder to /Downloads/OCUtil
  Local: add an already existing folder or application by dragging it to Tool Directory and by filling in its name.
  
- Use a utility:
  select a tool from the toolbar and press launch
  
- Manage a utility:
  select a tool from the toolbar and press manage; now you can launch the utility, remove the utility or browse the local files of the utility.
  
- Generate a SMBIOS:
  Press the button with the terminal icon. Then select the Mac model for which the SMBIOS must be generated and press generate. Now you should end up with an proper smbios. Before using this to activate iServices on openCore or Clover, please read [this](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html#generate-a-new-serial).
  
- Mount the root volumes EFI:
  Press the button with the drive icon. A terminal window should now pop up and ask for root permission. Fill in your password and voilá. This currently does only work when you've installed OCUtil in Applications on your mac.
  
  *must be a .zip
  
# Contributing
  You're welcome to help!
  If you spot a mistake, find a bug or just have a brilliant idea, please open an issue or propose a contribution.
 
# License
  This package is licensed under the MIT license. 
  Dependencies are licensed off their original licenses:
 - Alamofire: MIT License - [Link](https://github.com/Alamofire/Alamofire/blob/master/LICENSE)
 - ZIPFoundation: MIT License - [Link](https://github.com/weichsel/ZIPFoundation/blob/master/LICENSE)
 - macserial: BSD 3-Clause "New" or "Revised" License - [Link](https://github.com/acidanthera/OpenCorePkg/blob/master/LICENSE.txt)
 - MountEFI: [Link](https://github.com/corpnewt/MountEFI)
 




