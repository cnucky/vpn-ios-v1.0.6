// SPDX-License-Identifier: MIT
// Copyright © 2018 WireGuard LLC. All Rights Reserved.

import Foundation
import UIKit


class vpnListVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblVpnList: UITableView!
    
    
    var VpnListDictArray: [Dictionary<String, AnyObject>] = []
    var subreturnDictArray: Dictionary<String, AnyObject> = [:]
    var sublistDictArray = [AnyObject]()

    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: initialize view
    func initView() {
        Notelist(token: appDelegate.Token, type: "1")

//        self.setupDict()
        
        tblVpnList.reloadData()
    }
    
    func setupDict()  {
        var tmpDict = Dictionary<String, AnyObject>()
        tmpDict = ["ip_level" : "icon1", "key" : "key", "name" : "Settings1"] as [String : AnyObject]
        VpnListDictArray.append(tmpDict)
        tmpDict = ["ip_level" : "icon2", "key" : "Account", "name" : "Settings2"] as [String : AnyObject]
        VpnListDictArray.append(tmpDict)
        tmpDict = ["ip_level" : "icon3", "key" : "Help & Support", "name" : "Settings3"] as [String : AnyObject]
        VpnListDictArray.append(tmpDict)
        tmpDict = ["ip_level" : "icon4", "key" : "Setup Other Devices", "name" : "Settings4"] as [String : AnyObject]
        VpnListDictArray.append(tmpDict)
        tmpDict = ["ip_level" : "icon5", "key" : "Get 30 Days Free", "name" : "Settings5"] as [String : AnyObject]
        VpnListDictArray.append(tmpDict)
    }
    
    func clearcach() {
        VpnListDictArray.removeAll()
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
        return VpnListDictArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! vpnListCell
        
        
        
        (cell.lblCountryName.viewWithTag(30000) as! UILabel).text = "\(VpnListDictArray[indexPath.row]["name"]!)"
        
        return cell
    }
    
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    //    {
    //    }
    
    
    
    // MARK: - alert option
    
    func AlertOption(msg: String, errcode : Int) {
        // Create the alert controller
        let alertController = UIAlertController(title: msg, message: "", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            if Int(errcode) ==  0
            {
                
//                self.gotoNextpage()
                
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        //        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    //alert view
    func showAlert(msg: String)
    {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    } 
    
    
    //MARK: button functions
    
    
    
    //MARK: API Functions
    //notelist
    func Notelist( token: String, type: String){
        
        let getwebServices:WebCommon = WebCommon()
        let getServices:webservices = webservices()

        getwebServices.NodelistRequest(UUIDValue: (UIDevice.current.identifierForVendor?.uuidString)!, URLType: URLType.NodeList.rawValue, token: token, type: type, completion: { serverResponse in
            
            print("serverResponse-->",serverResponse)
            
            
            if let dataerrcode = serverResponse["code"]{
                print("dataerrcode msg-->",dataerrcode as Any)
                
                if let errmsg = serverResponse["msg"]{
                    print("dataerrmsg msg-->",errmsg as Any)
                    
                    if let data  = serverResponse["data"]{
                        print("data msg-->",data as Any)
                        let datadict: NSDictionary  = (serverResponse["data"] as! NSDictionary)
                        
                        for (key, array)  in datadict
                        {
                            print("key -->",key)
                            
                            if (key as? String == "id")
                            {
                                let UserID:String = String(format: "%@", array as! CVarArg)
                                self.appDelegate.UserID = UserID
                            }
                            
                            if (key as? String == "token")
                            {
                                let token:String = String(format: "%@", array as! CVarArg)
                                self.appDelegate.Token = token
                                
                                print("appDelegate.Token -->",self.appDelegate.Token)
                                
                            }
                            
                            if (key as? String == "server_list")
                            {
                                let server_list:String = String(format: "%@", array as! CVarArg)
                                
                                print("server_list -->",server_list)
                                
                                let datatmpDict: AnyObject = array as AnyObject
//                                let datatmpDict: NSDictionary = getServices.convertToDictionary2(text: server_list)! as NSDictionary
                                
                                self.sublistDictArray = datatmpDict as! [AnyObject]
//                                let subdictionary: NSDictionary = self.subreturnDictArray as NSDictionary
//
//                                for (subkey, subarray)  in subdictionary {
//
//
//                                    print("subkey 1 : \(subkey)")
//                                    print("subarray 1 : \(subarray)")
//                                }
                                
                                print("server_list sublistDictArray -->",self.sublistDictArray)

                                for (index, element) in self.sublistDictArray.enumerated() {
                                    print(index, ":", element)
                                    
                                    
                                    var tmpDict = Dictionary<String, AnyObject>()
                                    //
                                    tmpDict = element as! Dictionary<String, AnyObject>
                                    
                                    self.VpnListDictArray.append(tmpDict)
                                    
                                    print("final VpnListDictArray 1 : \(self.VpnListDictArray)")
                                    
                                }
                                
                                
                                
                            }
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    DispatchQueue.global(qos: .background).async {
                        // Background Thread
                        
                        DispatchQueue.main.async {
                            // Run UI Updates or call completion block
                            
                            //                            self.AlertOption(msg: errmsg as! String, errcode: dataerrcode as! Int)
                            self.tblVpnList.reloadData()

                        }
                    }
                    
                }
            }
            
        })
        
        
    }
    
    //end
}
