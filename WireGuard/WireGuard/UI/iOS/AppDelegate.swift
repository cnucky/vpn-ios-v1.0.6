// SPDX-License-Identifier: MIT
// Copyright © 2018 WireGuard LLC. All Rights Reserved.

import UIKit
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainVC: MainViewController?
//    var mainVC: MainLoginVC?
    var UUIDValue = ""
    var UserID = ""
    var refresToken = ""
    var Token = ""


    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//        let window = UIWindow(frame: UIScreen.main.bounds)
//        window.backgroundColor = UIColor.white
//        self.window = window

//        let mainVC = MainViewController()
//        //let mainVC = MainLoginVC()
//        window.rootViewController = mainVC
//        window.makeKeyAndVisible()

//        self.mainVC = mainVC

        
//        UILabel.appearance().substituteFontName = "RobotoCondensed-Regular"
//        UIButton.appearance().substituteFontName = "RobotoCondensed-Regular"
//        UITextField.appearance().substituteFontName = "RobotoCondensed-Regular"
        
//        UILabel.appearance().substituteFontName = "IRANSans"; // USE YOUR FONT NAME INSTEAD
//        UITextView.appearance().substituteFontName = "IRANSans"; // USE YOUR FONT NAME INSTEAD
//        UITextField.appearance().substituteFontName = "IRANSans"; // USE YOUR FONT NAME INSTEAD
        UILabel.appearance().font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: "Arial"))
        UITextField.appearance().font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: "Roboto"))
        UITextView.appearance().font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: "Roboto"))

//        UIDevice.current.identifierForVendor?.uuidString
        UUIDValue = (UIDevice.current.identifierForVendor?.uuidString)!
        print("UUID: ",UUIDValue as Any)
        
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        mainVC?.tunnelsListVC?.importFromFile(url: url)
        _ = FileManager.deleteFile(at: url)
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        mainVC?.refreshTunnelConnectionStatuses()
    }
}

func appDelegatedeviceID () -> AppDelegate
{
    return UIApplication.shared.delegate as! AppDelegate
}

// MARK: State restoration

extension AppDelegate {
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication,
                     viewControllerWithRestorationIdentifierPath identifierComponents: [String],
                     coder: NSCoder) -> UIViewController? {
        guard let vcIdentifier = identifierComponents.last else { return nil }
        if (vcIdentifier.hasPrefix("TunnelDetailVC:")) {
            let tunnelName = String(vcIdentifier.suffix(vcIdentifier.count - "TunnelDetailVC:".count))
            if let tunnelsManager = mainVC?.tunnelsManager {
                if let tunnel = tunnelsManager.tunnel(named: tunnelName) {
                    return TunnelDetailTableViewController(tunnelsManager: tunnelsManager, tunnel: tunnel)
                }
            } else {
                // Show it when tunnelsManager is available
                mainVC?.showTunnelDetailForTunnel(named: tunnelName, animated: false)
            }
        }
        return nil
    }
    
}
