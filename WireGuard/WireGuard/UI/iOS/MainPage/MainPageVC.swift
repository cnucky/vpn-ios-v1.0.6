// SPDX-License-Identifier: MIT
// Copyright © 2018 hswong. All Rights Reserved.

import Foundation
import AVFoundation
import CoreData
import UIKit

class MainPageVC: UIViewController {
    
    @IBOutlet weak var btnAddTunnel: UIButton!
    @IBOutlet weak var btnChooseLocation: UIButton!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    var tunnelsManager: TunnelsManager?
    var onTunnelsManagerReady: ((TunnelsManager) -> Void)?
    
//    var tunnelsListVC: TunnelsListTableViewController?
    
//    var tunnelsManager: TunnelsManager?
    var busyIndicator: UIActivityIndicatorView?
    var centeredAddButton: BorderedTextButton?
    
    var onSwitchToggled: ((Bool) -> Void)?
    var glob: GlobalVariable = GlobalVariable()

    
    init() {
//        let detailVC = UIViewController()
//        detailVC.view.backgroundColor = UIColor.white
//        let detailNC = UINavigationController(rootViewController: detailVC)
//
//        let masterVC = TunnelsListTableViewController()
//        let masterNC = UINavigationController(rootViewController: masterVC)
//
//        self.tunnelsListVC = masterVC
        
        super.init(nibName: nil, bundle: nil)
        
        //self.viewControllers = [ masterNC, detailNC ]
        
        // State restoration
//        self.restorationIdentifier = "MainVC"
//        masterNC.restorationIdentifier = "MasterNC"
//        detailNC.restorationIdentifier = "DetailNC"
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        NotificationCenter.default.addObserver(self, selector: #selector(doSomething), name: UIApplication.willEnterForegroundNotification, object: nil)

        let UserID = appDelegate.UserID
        let refresh_token = appDelegate.refresToken
        print("--->MainPageVC")
        print("MainPageVC --->UserID", UserID)
        print("MainPageVC --->refresh_token", refresh_token)

        
        //self.delegate = self
        
        // On iPad, always show both masterVC and detailVC, even in portrait mode, like the Settings app
        //self.preferredDisplayMode = .allVisible
        
        
        // Create the tunnels manager, and when it's ready, inform tunnelsListVC
        TunnelsManager.create { [weak self] result in
            if let error = result.error {
                ErrorPresenter.showErrorAlert(error: error, from: self)
                return
            }
            let tunnelsManager: TunnelsManager = result.value!
            print("result.value--->",result.value as Any)
            guard let s = self else { return }
            
            s.tunnelsManager = tunnelsManager
            self?.setTunnelsManager(tunnelsManager: tunnelsManager)
            
            tunnelsManager.activationDelegate = s
            
            s.onTunnelsManagerReady?(tunnelsManager)
            s.onTunnelsManagerReady = nil
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_: Bool) {
        
        if let tunnelsManager = tunnelsManager {
            
            print("tunnelsManager ---> ", tunnelsManager)
        
        }
        
        
    }
    
    func setTunnelsManager(tunnelsManager: TunnelsManager) {
        if (self.tunnelsManager != nil) {
            // If a tunnels manager is already set, do nothing
            return
        }
        
        
        
        // Add button at the center
        
//        let centeredAddButton = BorderedTextButton()
//        centeredAddButton.title = "Add a tunnel"
//        centeredAddButton.isHidden = true
//        self.view.addSubview(centeredAddButton)
//        centeredAddButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            centeredAddButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            centeredAddButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
//            ])
//        centeredAddButton.onTapped = { [weak self] in
//            self?.addButtonTapped(sender: centeredAddButton)
//        }
//        centeredAddButton.isHidden = (tunnelsManager.numberOfTunnels() > 0)
//        self.centeredAddButton = centeredAddButton
//
//        // Hide the busy indicator
//
//        self.busyIndicator?.stopAnimating()
        
        // Keep track of the tunnels manager
        
        self.tunnelsManager = tunnelsManager
//        tunnelsManager.tunnelsListDelegate = self
    }
    
    //click to connect vpn
    
    
    @objc func addButtonTapped(sender: AnyObject) {
        if (self.tunnelsManager == nil) { return } // Do nothing until we've loaded the tunnels
         
        
//        self.checkFile()
    }
     
    
    func importFromData()
    {
//        let url: URL = ""
//        let urlstring = "file:///Users/Me/Desktop/Doc.txt"
        let url = NSURL(string: "urlstring")
        
        guard let tunnelsManager = tunnelsManager else { return }
//        let fileBaseName = url!.deletingPathExtension!.lastPathComponent.trimmingCharacters(in: .whitespacesAndNewlines)

        
        let PrivateKey = "IBQRmUDMANH0f5gfWVvLa3GiU8YhKtwm5CwSu8l+RHs="
        let Address = "10.100.1.4/24"
        let DNS = "8.8.8.8"
        let PublicKey = "RAg5S1r3VGqq+emlo5OwhHSLv5Zz0YUoDh17AfenlXo="
        let Endpoint = "123.206.67.247:51820"
        let AllowedIPs = "0.0.0.0/0"

        let str = "[Interface]\nPrivateKey = " + PrivateKey +
        "\nAddress = " + Address +
        "\nDNS = " + DNS +
        "\n\n[Peer]\nPublicKey = " + PublicKey +
        "\nEndpoint = " + Endpoint +
        "\n AllowedIPs = " + AllowedIPs + "\n"
        
        

//        if let fileContents = try? String(contentsOf: url! as URL),
        if  let tunnelConfiguration = try? WgQuickConfigFileParser.parse(str, name: "fileBaseName") {
//            print("fileContents--->",fileContents)
            
            print("tunnelConfiguration--->",tunnelConfiguration)
            
            tunnelsManager.add(tunnelConfiguration: tunnelConfiguration) { [weak self] result in
                if let error = result.error {
                    //                        ErrorPresenter.showErrorAlert(error: error, from: self)
                    
                    if let tunnelsManager = self?.tunnelsManager {
                        
                        print("tunnelsManager ---> ", tunnelsManager)
                        let tunnel = tunnelsManager.tunnel(at: 0)
                        print("tunnel ---> ", tunnel)
                        
                        print("tunnel?.name 1--->",tunnel.name as Any)
                        print("tunnel?.status 1--->",tunnel.status as Any)
                        
                        let strswitchConnectStatus = tunnel.status.debugDescription
                        
                        
                        guard let s = self, let tunnelsManager = s.tunnelsManager else { return }
                        
                        if (strswitchConnectStatus == "inactive" ){
                            tunnelsManager.startActivation(of: tunnel) { [weak s] error in
                                if let error = error {
                                    ErrorPresenter.showErrorAlert(error: error, from: s, onPresented: {
                                        DispatchQueue.main.async {
                                            //                                            cell.statusSwitch.isOn = false
                                            print("tunnel ---> hello ")
                                            print("tunnel ---> ", tunnel)
                                            
                                            
                                        }
                                    })
                                }
                            }
                        }else{
                            tunnelsManager.startDeactivation(of: tunnel)
                        }
                        
                        
                        
                    }
                }
            }
        } else {
            ErrorPresenter.showErrorAlert(title: "Unable to import tunnel",
                                          message: "An error occured when importing the tunnel configuration.",
                                          from: self)
        }
        
    }
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
    @IBAction func btnAddTunnelTapped(_ sender: Any) {
        if (self.tunnelsManager == nil) { return } // Do nothing until we've loaded the tunnels
        
        
//        self.checkFile()
        importFromData()
//        connectVpn(token: appDelegate.Token)
//        disconnectVpn(token: appDelegate.Token)
    }
    
    @IBAction func ChooseLocationTapped(_ sender: Any) {
//        Notelist(token: appDelegate.Token, type: "2")
        gotoNextpage()
    }
    
    func gotoNextpage() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "vpnListVC") as! vpnListVC
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    //MARK: API Functions
    
    //disconnectVpn
    func disconnectVpn( token: String ){
        
        let getwebServices:WebCommon = WebCommon()
        
        getwebServices.VpnConnectRequest(UUIDValue: (UIDevice.current.identifierForVendor?.uuidString)!, URLType: URLType.VpnDisconnect.rawValue, token: token, completion: { serverResponse in
            
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
                                //                                self.appDelegate.Token = token
                                
                                print("server_list -->",server_list)
                                
                            }
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    DispatchQueue.global(qos: .background).async {
                        // Background Thread
                        
                        DispatchQueue.main.async {
                            // Run UI Updates or call completion block
                            
                            self.AlertOption(msg: errmsg as! String, errcode: dataerrcode as! Int)
                        }
                    }
                    
                }
            }
            
        })
        
        
    }
    
    //connectVpn
    func connectVpn( token: String ){
        
        let getwebServices:WebCommon = WebCommon()
        
        getwebServices.VpnConnectRequest(UUIDValue: (UIDevice.current.identifierForVendor?.uuidString)!, URLType: URLType.VpnConnect.rawValue, token: token, completion: { serverResponse in
            
            print("serverResponse-->",serverResponse)
            
            
            if let dataerrcode = serverResponse["code"]{
                print("dataerrcode msg-->",dataerrcode as Any)
                
                if let errmsg = serverResponse["msg"]{
                    print("dataerrmsg msg-->",errmsg as Any)
                    
                    if let data  = serverResponse["data"]{
                        print("data msg-->",data as Any)
//                        data msg--> {
//                            ip = "127.0.0.31";
//                            "ip_level" = 1;
//                            "private_key" = "private_key30";
//                            "public_key" = "public_key30";
//                        }
                        
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
                                //                                self.appDelegate.Token = token
                                
                                print("server_list -->",server_list)
                                
                                
                                
                            }
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    DispatchQueue.global(qos: .background).async {
                        // Background Thread
                        
                        DispatchQueue.main.async {
                            // Run UI Updates or call completion block
                            
                            self.AlertOption(msg: errmsg as! String, errcode: dataerrcode as! Int)
                        }
                    }
                    
                }
            }
            
        })
        
        
    }
    
    //notelist
    func Notelist( token: String, type: String){
        
        let getwebServices:WebCommon = WebCommon()
        
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
                                
                            }
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    DispatchQueue.global(qos: .background).async {
                        // Background Thread
                        
                        DispatchQueue.main.async {
                            // Run UI Updates or call completion block
                            
                            //                            self.AlertOption(msg: errmsg as! String, errcode: dataerrcode as! Int)
                        }
                    }
                    
                }
            }
            
        })
        
        
    }
    
    //Refresh_Token
    func Refresh_Token(  refresh_token: String){
        
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let getwebServices:WebCommon = WebCommon()
        
        //        let username = username
        let refresh_token = refresh_token
        
        
        getwebServices.Refresh_TokenRequest(UUIDValue: (UIDevice.current.identifierForVendor?.uuidString)!, URLType: URLType.RefreshToken.rawValue, refresh_token: refresh_token, completion: { serverResponse in
            
            print("serverResponse-->",serverResponse)
            
            
            if let dataerrcode = serverResponse["code"]{
                print("dataerrcode msg-->",dataerrcode as Any)
                
                if let errmsg = serverResponse["msg"]{
                    print("dataerrmsg msg-->",errmsg as Any)
                    
                    if let data  = serverResponse["data"]{
                        print("data msg-->",data as Any)
                        let datadict: NSDictionary  = (serverResponse["data"] as! NSDictionary)
                        //                            glob.UserID =
                        for (key, array)  in datadict
                        {
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
                            
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    DispatchQueue.global(qos: .background).async {
                        // Background Thread
                        
                        DispatchQueue.main.async {
                            // Run UI Updates or call completion block
                            
                            //                            self.AlertOption(msg: errmsg as! String, errcode: dataerrcode as! Int)
                        }
                    }
                    
                }
            }
            
        })
        
        
    }
    
    //end
}





extension MainPageVC: TunnelsManagerActivationDelegate {
    func tunnelActivationFailed(tunnel: TunnelContainer, error: TunnelsManagerError) {
        ErrorPresenter.showErrorAlert(error: error, from: self)
    }
}

extension MainPageVC {
    func refreshTunnelConnectionStatuses() {
        if let tunnelsManager = tunnelsManager {
            tunnelsManager.refreshStatuses()
        }
    }
    
    func showTunnelDetailForTunnel(named tunnelName: String, animated: Bool) {
        let showTunnelDetailBlock: (TunnelsManager) -> Void = { [weak self] (tunnelsManager) in
            if let tunnel = tunnelsManager.tunnel(named: tunnelName) {
                let tunnelDetailVC = TunnelDetailTableViewController(tunnelsManager: tunnelsManager, tunnel: tunnel)
                let tunnelDetailNC = UINavigationController(rootViewController: tunnelDetailVC)
                tunnelDetailNC.restorationIdentifier = "DetailNC"
                if let self = self {
                    if (animated) {
                        self.showDetailViewController(tunnelDetailNC, sender: self)
                    } else {
                        UIView.performWithoutAnimation {
                            self.showDetailViewController(tunnelDetailNC, sender: self)
                        }
                    }
                }
            }
        }
        if let tunnelsManager = tunnelsManager {
            showTunnelDetailBlock(tunnelsManager)
        } else {
            onTunnelsManagerReady = showTunnelDetailBlock
        }
    }
}

extension MainPageVC: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        // On iPhone, if the secondaryVC (detailVC) is just a UIViewController, it indicates that it's empty,
        // so just show the primaryVC (masterVC).
        let detailVC = (secondaryViewController as? UINavigationController)?.viewControllers.first
        let isDetailVCEmpty: Bool
        if let detailVC = detailVC {
            isDetailVCEmpty = (type(of: detailVC) == UIViewController.self)
        } else {
            isDetailVCEmpty = true
        }
        return isDetailVCEmpty
    }
    
    
    @objc private func doSomething() {
        // Do whatever you want, for example update your view.
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let refresh_token = appDelegate.refresToken
        
        Refresh_Token(refresh_token: appDelegate.Token)
    }
    
    
    
    
    
    
    
    
    
    
}
