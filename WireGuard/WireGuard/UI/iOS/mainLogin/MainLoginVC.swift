// SPDX-License-Identifier: MIT
// Copyright © 2018 hswong. All Rights Reserved.

import Foundation
import AVFoundation
import CoreData
import UIKit
import CommonCrypto
import CryptoSwift



//extension Data {
//    var hexString: String {
//        return map { String(format: "%02hhx", $0) }.joined()
//    }
//}
enum AESError: Error {
    case KeyError((String, Int))
    case IVError((String, Int))
    case CryptorError((String, Int))
}


class MainLoginVC: UIViewController {

    @IBOutlet var btnonoff: UIView!
    @IBOutlet weak var lblmsg: UILabel!
    
    
    @IBOutlet weak var SigninView: UIView!
    @IBOutlet weak var btnSignin: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var txtRUserName: UITextField!
    @IBOutlet weak var txtRPassword: UITextField!
    @IBOutlet weak var txtRRePassword: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var glob: GlobalVariable = GlobalVariable()
    
//    var getreachability:Reachability = Reachability()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("tunnel ---> MainLoginVC")

//        let txtmsg: String? = "hello"
        
//        self.btnonoff.isHidden = false
//        self.lblmsg.isHidden = false
        
//        self.lblmsg.text = txtmsg
        
        
        
        initView()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
  
    
    //MARK: initialize view
    func initView() {
        
        SigninView.isHidden = false
        
//        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard")))

//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("dismissKeyboardFromView:"))))
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainLoginVC.handleTap(gestureRecognizer:)))
        self.view.addGestureRecognizer(gestureRecognizer)
    }

    @objc func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    func gotoNextpage() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainPageVC") as! MainPageVC
        self.present(vc, animated: true, completion: nil)
        
        
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

                self.gotoNextpage()

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
    
//    func dismissKeyboardFromView(sender: UITapGestureRecognizer?) {
//        let view = sender?.view
//        view?.endEditing(true)
//    }
    
    //MARK: button functions
    //Signin view
    @IBAction func SignViewTapped(_ sender: Any) {
        SigninView.isHidden = false
        registerView.isHidden = true
    }
    
    @IBAction func LoginTapped(_ sender: Any) {
        print("LoginTapped")
        
//        if Reachability.isConnectedToNetwork() == true
//        {
//        }
        guard let UserName = txtUserName.text, !txtUserName.text!.isEmpty else
        {
            // email is empty
            
            showAlert(msg: "Please fill in Username")
            
            return
        }
        
        guard let pwd = txtPassword.text, !txtPassword.text!.isEmpty else
        {
            // email is empty
            
            showAlert(msg: "Please keyin Password")
            
            return
        }
        
        Login(username: UserName, password: pwd)
    }
    
    //Register view
    
    @IBAction func CreateAccountViewTapped(_ sender: Any) {
        SigninView.isHidden = true
        registerView.isHidden = false
        
    }
    
    @IBAction func SubmitTapped(_ sender: Any) {
        print("LoginTapped")

        guard let UserName = txtRUserName.text, !txtRUserName.text!.isEmpty else
        {
            // email is empty
            
            showAlert(msg: "Please keyin Username")
            
            return
        }
        
        guard let RPassword = txtRPassword.text, !txtRPassword.text!.isEmpty else
        {
            // email is empty
            
            showAlert(msg: "Please keyin password")
            
            return
        }
        
        guard let RRePassword = txtRRePassword.text, !txtRRePassword.text!.isEmpty else
        {
            // email is empty
            
            showAlert(msg: "Please re-type password")
            
            return
        }
        
        
        RegisterUser(username: UserName, password: RPassword, repassword: RRePassword)
        
    }
    

    
    
    //MARK: API Functions
    //Signin
    func Login(username: String, password: String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let getwebServices:WebCommon = WebCommon()
        
        let username = username
        let password = password
        

            getwebServices.LogindataRequest(UUIDValue: (UIDevice.current.identifierForVendor?.uuidString)!, URLType: URLType.Login.rawValue, username: username, password: password, completion: { serverResponse in
                
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
                                if (key as? String == "uid")
                                {
                                    let UserID:String = String(format: "%@", array as! CVarArg)
                                    appDelegate.UserID = UserID
                                 }
                                
                                if (key as? String == "token")
                                {
                                    let token:String = String(format: "%@", array as! CVarArg)
                                    appDelegate.Token = token
                                }
                                
                                if (key as? String == "refresh_token")
                                {
                                    let refresh_token:String = String(format: "%@", array as! CVarArg)
                                    appDelegate.refresToken = refresh_token
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
    
    //Register
    func RegisterUser(username: String, password: String, repassword: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let getwebServices:WebCommon = WebCommon()
        
        let username = username
        let password = password
        let repassword = repassword

        
//        print(" RegisterUser 1---> ", getwebServices.RegisterdataRequest(UUIDValue: (UIDevice.current.identifierForVendor?.uuidString)!, URLType: URLType.Register.rawValue, username: username, password: password, repassword: repassword, completion: { serverResponse in
//
//            let datatmpDict = serverResponse["data"]
//            print("RegisterUser datatmpDict msg-->",datatmpDict as Any)
//
//        }))
        
        getwebServices.RegisterdataRequest(UUIDValue: (UIDevice.current.identifierForVendor?.uuidString)!, URLType: URLType.Register.rawValue, username: username, password: password, repassword: repassword, completion: { serverResponse in
            
            let datatmpDict = serverResponse["data"]
            print("RegisterUser datatmpDict msg-->",datatmpDict as Any)
            
            
            if let dataerrcode = serverResponse["code"]{
                print("dataerrcode msg-->",dataerrcode as Any)
                
                if let errmsg = serverResponse["msg"]{
                    print("dataerrmsg msg-->",errmsg as Any)
                    
                    if let data  = serverResponse["data"]{
                        print("data msg-->",data as Any)
                        let datadict: NSDictionary  = (serverResponse["data"] as! NSDictionary)
 
                        for (key, array)  in datadict
                        {
                            if (key as? String == "uid")
                            {
                                let UserID:String = String(format: "%@", array as! CVarArg)
                                appDelegate.UserID = UserID
                            }
                            
                            if (key as? String == "token")
                            {
                                let token:String = String(format: "%@", array as! CVarArg)
                                appDelegate.Token = token
                            }
                            
                            if (key as? String == "refresh_token")
                            {
                                let refresh_token:String = String(format: "%@", array as! CVarArg)
                                appDelegate.refresToken = refresh_token
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
    
 
    
    
    
    //end
}



