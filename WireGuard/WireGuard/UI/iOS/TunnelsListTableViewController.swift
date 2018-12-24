// SPDX-License-Identifier: MIT
// Copyright © 2018 WireGuard LLC. All Rights Reserved.

import UIKit
import MobileCoreServices
import UserNotifications

class TunnelsListTableViewController: UIViewController {

    var tunnelsManager: TunnelsManager?

    var busyIndicator: UIActivityIndicatorView?
    var centeredAddButton: BorderedTextButton?
    var tableView: UITableView?

    var myData: Data!
    
    //Details
    let interfaceFields: [TunnelViewModel.InterfaceField] = [
        .name, .publicKey, .addresses,
        .listenPort, .mtu, .dns
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        // Set up the navigation bar
        self.title = "WireGuard"
//        self.title = tunnelViewModel.interfaceData[.name]

        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(sender:)))
        self.navigationItem.rightBarButtonItem = addButtonItem
        let settingsButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButtonTapped(sender:)))
        self.navigationItem.leftBarButtonItem = settingsButtonItem

        // Set up the busy indicator
        let busyIndicator = UIActivityIndicatorView(style: .gray)
        busyIndicator.hidesWhenStopped = true

        // Add the busyIndicator, centered
        view.addSubview(busyIndicator)
        busyIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            busyIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            busyIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        busyIndicator.startAnimating()
        self.busyIndicator = busyIndicator

        // State restoration
        self.restorationIdentifier = "TunnelsListVC"
    }

    func setTunnelsManager(tunnelsManager: TunnelsManager) {
        if (self.tunnelsManager != nil) {
            // If a tunnels manager is already set, do nothing
            return
        }

        // Create the table view

        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(TunnelsListTableViewCell.self, forCellReuseIdentifier: TunnelsListTableViewCell.id)

        /*
        // tableview Footer
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 250))
        customView.backgroundColor = UIColor.red
//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
//        button.setTitle("Submit", for: .normal)
//        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//        customView.addSubview(button)
        tableView.tableFooterView = customView
        */

        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView = tableView

        // Add button at the center

        let centeredAddButton = BorderedTextButton()
        centeredAddButton.title = "Add a tunnel"
        centeredAddButton.isHidden = true
        self.view.addSubview(centeredAddButton)
        centeredAddButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centeredAddButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            centeredAddButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
        centeredAddButton.onTapped = { [weak self] in
            self?.addButtonTapped(sender: centeredAddButton)
        }
        centeredAddButton.isHidden = (tunnelsManager.numberOfTunnels() > 0)
        self.centeredAddButton = centeredAddButton

        // Hide the busy indicator

        self.busyIndicator?.stopAnimating()

        // Keep track of the tunnels manager

        self.tunnelsManager = tunnelsManager
        tunnelsManager.tunnelsListDelegate = self
    }

    override func viewWillAppear(_: Bool) {
        // Remove selection when getting back to the list view on iPhone
        if let tableView = self.tableView, let selectedRowIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRowIndexPath, animated: false)
        }
    }

    //click to connect vpn
    @objc func addButtonTapped(sender: AnyObject) {
        if (self.tunnelsManager == nil) { return } // Do nothing until we've loaded the tunnels
        /*
        let alert = UIAlertController(title: "", message: "Add a new WireGuard tunnel", preferredStyle: .actionSheet)
        let importFileAction = UIAlertAction(title: "Create from file or archive", style: .default) { [weak self] (_) in
            self?.presentViewControllerForFileImport()
        }
        alert.addAction(importFileAction)

        
        let scanQRCodeAction = UIAlertAction(title: "Create from QR code", style: .default) { [weak self] (_) in
            self?.presentViewControllerForScanningQRCode()
        }
        alert.addAction(scanQRCodeAction)

        let createFromScratchAction = UIAlertAction(title: "Create from scratch", style: .default) { [weak self] (_) in
            if let s = self, let tunnelsManager = s.tunnelsManager {
                s.presentViewControllerForTunnelCreation(tunnelsManager: tunnelsManager, tunnelConfiguration: nil)
            }
        }
        alert.addAction(createFromScratchAction)
         
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
 
        // popoverPresentationController will be nil on iPhone and non-nil on iPad
        if let sender = sender as? UIBarButtonItem {
            alert.popoverPresentationController?.barButtonItem = sender
        } else if let sender = sender as? UIView {
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
        }
        self.present(alert, animated: true, completion: nil)
        */
        
        
//        var filePath = Bundle.main.url(forResource: "BJ_VPN", withExtension: "conf")
//
//        print("filePath---->",filePath)
        
//        importFromFile(url: filePath)

        self.checkFile()
    }

    @objc func settingsButtonTapped(sender: UIBarButtonItem!) {
        if (self.tunnelsManager == nil) { return } // Do nothing until we've loaded the tunnels
        let settingsVC = SettingsTableViewController(tunnelsManager: tunnelsManager)
        let settingsNC = UINavigationController(rootViewController: settingsVC)
        settingsNC.modalPresentationStyle = .formSheet
        self.present(settingsNC, animated: true)
    }

    func presentViewControllerForTunnelCreation(tunnelsManager: TunnelsManager, tunnelConfiguration: TunnelConfiguration?) {
        let editVC = TunnelEditTableViewController(tunnelsManager: tunnelsManager, tunnelConfiguration: tunnelConfiguration)
        let editNC = UINavigationController(rootViewController: editVC)
        editNC.modalPresentationStyle = .formSheet
        self.present(editNC, animated: true)
    }

    func presentViewControllerForFileImport() {
        
        //BJ_VPN.conf
//        var filePath = Bundle.main.url(forResource: "BJ_VPN", withExtension: "conf")
//
        
        let documentTypes = ["com.wireguard.config.quick", String(kUTTypeText), String(kUTTypeZipArchive)]
        let filePicker = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)
        print("documentTypes---->",documentTypes)
        print("filePicker---->",filePicker)
//        print("filePath---->",filePath)

        filePicker.delegate = self
        self.present(filePicker, animated: true)
        
        
    }

    func presentViewControllerForScanningQRCode() {
        let scanQRCodeVC = QRScanViewController()
        scanQRCodeVC.delegate = self
        let scanQRCodeNC = UINavigationController(rootViewController: scanQRCodeVC)
        scanQRCodeNC.modalPresentationStyle = .fullScreen
        self.present(scanQRCodeNC, animated: true)
    }

    func checkFile() {
//        var filePath = Bundle.main.url(forResource: "BJ_VPN", withExtension: "conf")

        if let documentsDirectory = Bundle.main.url(forResource: "BJ_VPN", withExtension: "conf") {
//            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
//            let fileURL = documentsDirectory.appendingPathComponent("BJ_VPN.conf")
            do {
//                let fileExists = try fileURL.checkResourceIsReachable()
//                if fileExists {
//                    print("File exists")
//                } else {
//                    print("File does not exist, create it")
                    writeFile(fileURL: documentsDirectory)
//                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func writeFile(fileURL: URL) {
        do {
            try  importFromFile(url: fileURL)
            //myData.write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func importFromFile(url: URL) {
        guard let tunnelsManager = tunnelsManager else { return }
        
//        print("urls.forEach(importFromFile) --->1 ", url)
        if (url.pathExtension == "zip") {
            ZipImporter.importConfigFiles(from: url) { [weak self] result in
                if let error = result.error {
                    ErrorPresenter.showErrorAlert(error: error, from: self)
                    return
                }
                let configs: [TunnelConfiguration?] = result.value!
                tunnelsManager.addMultiple(tunnelConfigurations: configs.compactMap { $0 }) { [weak self] (numberSuccessful) in
                    if numberSuccessful == configs.count {
                        return
                    }
                    ErrorPresenter.showErrorAlert(title: "Created \(numberSuccessful) tunnels",
                        message: "Created \(numberSuccessful) of \(configs.count) tunnels from zip archive",
                        from: self)
                }
            }
        } else /* if (url.pathExtension == "conf") -- we assume everything else is a conf */ {
            let fileBaseName = url.deletingPathExtension().lastPathComponent.trimmingCharacters(in: .whitespacesAndNewlines)
            if let fileContents = try? String(contentsOf: url),
                let tunnelConfiguration = try? WgQuickConfigFileParser.parse(fileContents, name: fileBaseName) {
                tunnelsManager.add(tunnelConfiguration: tunnelConfiguration) { [weak self] result in
                    if let error = result.error {
                        ErrorPresenter.showErrorAlert(error: error, from: self)
                    }
                }
            } else {
                ErrorPresenter.showErrorAlert(title: "Unable to import tunnel",
                                              message: "An error occured when importing the tunnel configuration.",
                                              from: self)
            }
        }
    }
    
    
}

// MARK: UIDocumentPickerDelegate

extension TunnelsListTableViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        urls.forEach(importFromFile)
        print("urls.forEach(importFromFile) ---> ", urls.forEach(importFromFile))

    }
}

// MARK: QRScanViewControllerDelegate

extension TunnelsListTableViewController: QRScanViewControllerDelegate {
    func addScannedQRCode(tunnelConfiguration: TunnelConfiguration, qrScanViewController: QRScanViewController,
                          completionHandler: (() -> Void)?) {
        tunnelsManager?.add(tunnelConfiguration: tunnelConfiguration) { result in
            if let error = result.error {
                ErrorPresenter.showErrorAlert(error: error, from: qrScanViewController, onDismissal: completionHandler)
            } else {
                completionHandler?()
            }
        }
    }
}

// MARK: UITableViewDataSource

extension TunnelsListTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tunnelsManager?.numberOfTunnels() ?? 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TunnelsListTableViewCell.id, for: indexPath) as! TunnelsListTableViewCell
        if let tunnelsManager = tunnelsManager {
            
            print("tunnelsManager ---> ", tunnelsManager)
            
            let tunnel = tunnelsManager.tunnel(at: indexPath.row)
            print("tunnel ---> ", tunnel)

            
            cell.tunnel = tunnel
            print("cell.tunnel ---> ", cell.tunnel as Any)

            
            cell.onSwitchToggled = { [weak self] isOn in
                guard let s = self, let tunnelsManager = s.tunnelsManager else { return }
                if (isOn) {
                    tunnelsManager.startActivation(of: tunnel) { [weak s] error in
                        if let error = error {
                            ErrorPresenter.showErrorAlert(error: error, from: s, onPresented: {
                                DispatchQueue.main.async {
                                    cell.statusSwitch.isOn = false
                                }
                            })
                        }
                    }
                } else {
                    tunnelsManager.startDeactivation(of: tunnel)
                }
            }
            
            print("cell.onSwitchToggled ---> ", cell.onSwitchToggled as Any)

        }
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension TunnelsListTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tunnelsManager = tunnelsManager else { return }
        let tunnel = tunnelsManager.tunnel(at: indexPath.row)
        let tunnelDetailVC = TunnelDetailTableViewController(tunnelsManager: tunnelsManager, tunnel: tunnel)
        let tunnelDetailNC = UINavigationController(rootViewController: tunnelDetailVC)
        tunnelDetailNC.restorationIdentifier = "DetailNC"
        print("tunnelDetailNC ---> ", tunnelDetailNC)
        print("click tunnelDetailNC ---> here ")

        /*
        // tableview Footer
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 250))
        customView.backgroundColor = UIColor.blue
        //        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        //        button.setTitle("Submit", for: .normal)
        //        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        //        customView.addSubview(button)
//        tableView.tableFooterView = customView
        
        var tunnelViewModel: TunnelViewModel
//        init(tunnelsManager tm: TunnelsManager, tunnel t: TunnelContainer) {
//            tunnelsManager = tm
//            tunnel = t
            tunnelViewModel = TunnelViewModel(tunnelConfiguration: tunnel.tunnelConfiguration())
//            super.init(style: .grouped)
//        }
//        self.title = tunnelViewModel.interfaceData[.name]
        
        print("click tunnelDetailNC ---> here ",tunnelViewModel.interfaceData[.name] )

        self.tableView?.tableFooterView = customView
        */
        /**/

//        showDetailViewController(tunnelDetailNC, sender: self) // Shall get propagated up to the split-vc
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] (_, _, completionHandler) in
            guard let tunnelsManager = self?.tunnelsManager else { return }
            let tunnel = tunnelsManager.tunnel(at: indexPath.row)
            tunnelsManager.remove(tunnel: tunnel, completionHandler: { (error) in
                if (error != nil) {
                    ErrorPresenter.showErrorAlert(error: error!, from: self)
                    completionHandler(false)
                } else {
                    completionHandler(true)
                }
            })
        })
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: TunnelsManagerDelegate

extension TunnelsListTableViewController: TunnelsManagerListDelegate {
    func tunnelAdded(at index: Int) {
        tableView?.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        centeredAddButton?.isHidden = (tunnelsManager?.numberOfTunnels() ?? 0 > 0)
    }

    func tunnelModified(at index: Int) {
        tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    func tunnelMoved(at oldIndex: Int, to newIndex: Int) {
        tableView?.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
    }

    func tunnelRemoved(at index: Int) {
        tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        centeredAddButton?.isHidden = (tunnelsManager?.numberOfTunnels() ?? 0 > 0)
    }
}

class TunnelsListTableViewCell: UITableViewCell {
    static let id: String = "TunnelsListTableViewCell"
    var tunnel: TunnelContainer? {
        didSet(value) {
            // Bind to the tunnel's name
            nameLabel.text = tunnel?.name ?? ""
            nameObservervationToken = tunnel?.observe(\.name) { [weak self] (tunnel, _) in
                self?.nameLabel.text = tunnel.name
            }
            // Bind to the tunnel's status --deactivating inactive
            print("tunnel?.status 1--->",tunnel?.status as Any)
            update(from: tunnel?.status)
            statusObservervationToken = tunnel?.observe(\.status) { [weak self] (tunnel, _) in
                print("in tunnel?.status--->",tunnel.status)

                self?.update(from: tunnel.status)
            }
            
            /*
            // Bind to the tunnel's publicKey
            lblpublicKey.text = tunnel?.publicKey ?? ""
            nameObservervationToken = tunnel?.observe(\.publicKey) { [weak self] (tunnel, _) in
                self?.lblpublicKey.text = tunnel.publicKey
            }*/
            
            /*
            let interfaceFields: [TunnelViewModel.InterfaceField] = [
                .name, .publicKey, .addresses,
                .listenPort, .mtu, .dns
            ]*/
        }
    }
    var onSwitchToggled: ((Bool) -> Void)?

    let nameLabel: UILabel
    let busyIndicator: UIActivityIndicatorView
    let statusSwitch: UISwitch
    
    let lblpublicKey: UILabel
//    let lbladdresses: UILabel
//    let lbldns: UILabel


    private var statusObservervationToken: AnyObject?
    private var nameObservervationToken: AnyObject?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        nameLabel = UILabel()
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        nameLabel.adjustsFontForContentSizeCategory = true
        
        /**/
        lblpublicKey = UILabel()
        lblpublicKey.font = UIFont.preferredFont(forTextStyle: .body)
        lblpublicKey.adjustsFontForContentSizeCategory = true
        /**/
        
        busyIndicator = UIActivityIndicatorView(style: .gray)
        busyIndicator.hidesWhenStopped = true
        statusSwitch = UISwitch()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(statusSwitch)
        statusSwitch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.rightAnchor.constraint(equalTo: statusSwitch.rightAnchor)
            ])
        contentView.addSubview(busyIndicator)
        busyIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            busyIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusSwitch.leftAnchor.constraint(equalToSystemSpacingAfter: busyIndicator.rightAnchor, multiplier: 1)
            ])
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        let bottomAnchorConstraint = contentView.layoutMarginsGuide.bottomAnchor.constraint(
            equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1)
        bottomAnchorConstraint.priority = .defaultLow // Allow this constraint to be broken when animating a cell away during deletion
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.layoutMarginsGuide.topAnchor, multiplier: 1),
            nameLabel.leftAnchor.constraint(equalToSystemSpacingAfter: contentView.layoutMarginsGuide.leftAnchor, multiplier: 1),
            busyIndicator.leftAnchor.constraint(equalToSystemSpacingAfter: nameLabel.rightAnchor, multiplier: 1),
            bottomAnchorConstraint
            ])

        self.accessoryType = .disclosureIndicator

        statusSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        
        
        
        // Move to a background thread to do some long running work
//        DispatchQueue.global(qos: .userInitiated).async {
//             // Bounce back to the main thread to update the UI
//            DispatchQueue.main.async {
//                 self.switchToggled()
//
//            }
//        }
        
    }
    
    

    @objc func switchToggled() {
        onSwitchToggled?(statusSwitch.isOn)
    }

    private func update(from status: TunnelStatus?) {
        guard let status = status else {
            reset()
            return
        }
        DispatchQueue.main.async { [weak statusSwitch, weak busyIndicator] in
            guard let statusSwitch = statusSwitch, let busyIndicator = busyIndicator else { return }
            statusSwitch.isOn = !(status == .deactivating || status == .inactive)
            statusSwitch.isUserInteractionEnabled = (status == .inactive || status == .active)
            if (status == .inactive || status == .active) {
                busyIndicator.stopAnimating()
            } else {
                busyIndicator.startAnimating()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func reset() {
        statusSwitch.isOn = false
        statusSwitch.isUserInteractionEnabled = false
        busyIndicator.stopAnimating()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
}

class BorderedTextButton: UIView {
    let button: UIButton

    override var intrinsicContentSize: CGSize {
        let buttonSize = button.intrinsicContentSize
        return CGSize(width: buttonSize.width + 32, height: buttonSize.height + 16)
    }

    var title: String {
        get { return button.title(for: .normal) ?? "" }
        set(value) { button.setTitle(value, for: .normal) }
    }

    var onTapped: (() -> Void)?

    init() {
        button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        super.init(frame: CGRect.zero)
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.borderColor = button.tintColor.cgColor
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc func buttonTapped() {
        onTapped?()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
