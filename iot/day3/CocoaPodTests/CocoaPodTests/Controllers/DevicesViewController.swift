//
//  DevicesViewController.swift
//  CocoaPodTests
//
//  Created by Douglas Frari on 11/05/18.
//  Copyright © 2018 CESAR School. All rights reserved.
//

import UIKit
import SocketIO // <<-- new library here

class DevicesViewController: UIViewController {

    
    // MARK: IBOutlets Variables
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Segue Variables
    var selectedGatewayUUID: String?
    
    // MARK: Variables
    private var datasource: [BaseThingDevice]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Things"
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        // 1
        
        let socketIO = KnotSocketIO()
        
        socketIO.getDevices { (data, error) in
            guard error == nil else {
                print("error: \(error!.localizedDescription)")
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            self.datasource = data
            self.tableView.reloadData()
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // TODO para repassar valor para a proxima tela
    }
    

} // end class


extension DevicesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let datasource = datasource {
            return datasource.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let row = indexPath.row
        
        cell!.textLabel?.text = (datasource![row]).name
        cell!.detailTextLabel?.text = (datasource![row]).uuid
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let datasource = datasource {
            let index = indexPath.row
            let device = datasource[index]
            
            if let uuid = device.uuid {
                performSegue(withIdentifier: "toSensors", sender: uuid)
            }
        }
    }
}
