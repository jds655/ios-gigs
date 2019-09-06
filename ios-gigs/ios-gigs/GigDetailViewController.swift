//
//  GigDetailViewController.swift
//  ios-gigs
//
//  Created by Joshua Sharp on 9/5/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    var authAPI: AuthAPI?
    var gigController: GigController?
    var gig: Gig?
    
    @IBOutlet weak var bigLabel: UILabel!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        self.saveButton.isEnabled = true
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        self.saveButton.isEnabled = true
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let title = jobTitleTextField.text, !title.isEmpty ,
            let description = descriptionTextView.text, !description.isEmpty,
        let gigController = gigController  else {
                
                return
                
        }
        let date = datePicker.date
        let newGig = Gig(title: title, description: description, dueDate: date)
        gigController.createGig(bearer: (authAPI?.bearer!)!, gig: newGig, completion: { (error) in
            if let error = error {
                NSLog("Error adding gig: \(error)")
                return
            }
            let alert = UIAlertController(title: "Gigs", message: "Gig creation successful", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: {
                    self.saveButton.isEnabled = false
                    self.dismiss(animated: true, completion: nil)
                })
            }
        })
    }
    
    func updateViews() {
        guard let gig = gig else {
            bigLabel.text = "New Gig"
            return
        }
        bigLabel.text = gig.title
        jobTitleTextField.text = gig.title
        datePicker.date = gig.dueDate
        descriptionTextView.text = gig.description
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension GigDetailViewController:UITextViewDelegate {
    func textViewDidBeginEditing(_: UITextView) {
        self.saveButton.isEnabled = true
    }
}
