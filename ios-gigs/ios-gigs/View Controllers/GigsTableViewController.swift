//
//  GigsTableViewController.swift
//  ios-gigs
//
//  Created by Joshua Sharp on 9/4/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    let authAPI = AuthAPI()
    let gigController = GigController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !authAPI.isSignedIn {
            performSegue(withIdentifier: "LoginSegue", sender: self)
        }
        if authAPI.isSignedIn {
            gigController.getAllGigs(bearer: authAPI.bearer!) { (error) in
                if let error = error {
                    NSLog("Error retreiving all gigs: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        let date = df.string(from: gigController.gigs[indexPath.row].dueDate)
        cell.detailTextLabel?.text = "Due: \(date)"
        return cell
    }
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        switch identifier {
        case "LoginSegue":
            let loginVC = segue.destination as? LoginViewController
            loginVC?.authAPI = authAPI
        case "ShowGigDetailSegue", "AddGigSegue":
            let VC = segue.destination as? GigDetailViewController
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            if identifier == "ShowGigDetailSegue" { VC?.gig = gigController.gigs[index] }
            VC?.authAPI = self.authAPI
            VC?.gigController = self.gigController
        default:
            break
        }
    }

}
