//
//  SignUpViewController.swift
//  mileshareApp
//
//  Created by 森田宣広 on 2018/03/13.
//  Copyright © 2018年 森田宣広. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookLogin

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var topView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        topView.isUserInteractionEnabled = true
        topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:))))
        self.view.addSubview(topView)
        
        //facebookloginnbutton
        let loginButton = LoginButton(readPermissions: [ .email ])
        loginButton.delegate = UIApplication.shared.delegate as! AppDelegate
        loginButton.frame = CGRect(x: 80, y: 220, width: 215, height: 40)
        view.addSubview(loginButton)
    }
    
    // 画像がタップされたら呼ばれる
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "topView", sender: nil)
        } catch let error {
            assertionFailure("Error signing out: \(error)")
        }
        
    }
    
    //キーボード以外をタッチしたらキーボードが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func didTapSignUp(_ sender: UIButton) {
        let email = emailField.text
        let password = passwordField.text
        Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .invalidEmail:
                        self.showAlert("Enter a valid email.")
                    case .emailAlreadyInUse:
                        self.showAlert("Email already in use.")
                    default:
                        self.showAlert("Error: \(error.localizedDescription)")
                    }
                }
                return
            }
            self.signIn()
        })
    }

    @IBAction func didTapBackToLogin(_ sender: UIButton) {
          self.dismiss(animated: true, completion: {})
    }
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "To Do App", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //画面をタッチするとキーボード閉じる
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    func signIn() {
        performSegue(withIdentifier: "SignInFromSignUp", sender: nil)
    }
    
}
