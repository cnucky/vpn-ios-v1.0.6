// SPDX-License-Identifier: MIT
// Copyright © 2018 WireGuard LLC. All Rights Reserved.

import Foundation
import AVFoundation
import CoreData
import UIKit


class OptionsVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblOptions: UITableView!
    
    var OptionsDictArray: [Dictionary<String, AnyObject>] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("page ---> OptionsVC")
        
        self.setupDict()
        
        tblOptions.reloadData()
    }
    
    func setupDict()  {
        var tmpDict = Dictionary<String, AnyObject>()
        tmpDict = ["icon" : "icon1", "optionsName" : "Settings"] as [String : AnyObject]
        OptionsDictArray.append(tmpDict)
        tmpDict = ["icon" : "icon2", "optionsName" : "Account"] as [String : AnyObject]
        OptionsDictArray.append(tmpDict)
        tmpDict = ["icon" : "icon3", "optionsName" : "Help & Support"] as [String : AnyObject]
        OptionsDictArray.append(tmpDict)
        tmpDict = ["icon" : "icon4", "optionsName" : "Setup Other Devices"] as [String : AnyObject]
        OptionsDictArray.append(tmpDict)
        tmpDict = ["icon" : "icon5", "optionsName" : "Get 30 Days Free"] as [String : AnyObject]
        OptionsDictArray.append(tmpDict)
    }
    
    func clearcach() {
        OptionsDictArray.removeAll()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: TableView
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        return 50
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return OptionsDictArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
//        let cell:OptionsCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! OptionsCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OptionsCell
        
//        var cell : EventTableViewCell?
//        cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! EventTableViewCell?
//        if cell == nil {
//            cell = EventTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "eventCell")
//        }
        
        
        
        (cell.lblOptionsName.viewWithTag(200000) as! UILabel).text = "\(OptionsDictArray[indexPath.row]["optionsName"]!)"
        
        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
//    {
//    }
    
    // Mark : - Button Functions
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    
}
