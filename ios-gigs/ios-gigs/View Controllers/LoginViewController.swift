//
//  LoginViewController.swift
//  ios-gigs
//
//  Created by Joshua Sharp on 9/4/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

enum AuthAction: String {
    case signin = "Signin"
    case signup = "Signup"
}

class LoginViewController: UIViewController {
    var authAPI: AuthAPI?
    var authAction: AuthAction = .signin
    @IBOutlet weak var segmentedView: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentedChanged(_ sender: Any) {
        switch segmentedView.selectedSegmentIndex {
        case 0:
            authAction = .signin
            goButton.setTitle(authAction.rawValue, for: .normal)
        case 1:
            authAction = .signup
            goButton.setTitle(authAction.rawValue, for: .normal)
        default:
            break
        }
    }
    
    @IBAction func goTapped(_ sender: Any) {
        if let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty {
            let authUser = AuthUser(username: username, password: password)
            switch authAction {
            case .signin:
                authAPI?.signin(with: authUser, completion: { (networkError) in
                    if let error = networkError {
                        let alert = UIAlertController(title: "Error", message: "\(error.rawValue)", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okAction)
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: {
                                self.usernameTextField.text = ""
                                self.passwordTextField.text = ""
                                self.usernameTextField.becomeFirstResponder()
                            })
                        }
                        NSLog("\(error.rawValue)")
                    } else {
                        DispatchQueue.main.async {
                            self.usernameTextField.text = ""
                            self.passwordTextField.text = ""
                            self.usernameTextField.becomeFirstResponder()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                })
            case .signup:
                authAPI?.signup(with: authUser, completion: { (networkError) in
                    
                    if let error = networkError {
                        let alert = UIAlertController(title: "Error", message: "\(error.rawValue)", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okAction)
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: {
                                self.usernameTextField.text = ""
                                self.passwordTextField.text = ""
                                self.usernameTextField.becomeFirstResponder()
                            })
                        }
                        NSLog("Error occurred during sign up: \(error)")
                    } else {
                        
                        let alert = UIAlertController(title: "Sign Up Successful", message: "Now please sign in", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okAction)
                        
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: {
                                self.authAction = .signin
                                self.segmentedView.selectedSegmentIndex = 0
                                self.goButton.setTitle("Sign In", for: .normal)
                            })
                        }
                    }
                })
            }
            
        }
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
