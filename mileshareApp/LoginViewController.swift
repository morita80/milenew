//
//  LoginViewController.swift
//  mileshareApp
//
//  Created by 森田宣広 on 2018/03/13.
//  Copyright © 2018年 森田宣広. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//                if let _ = Auth.auth().currentUser {
//                    self.alreadysignIn()
//                }
    }
    
    
    //キーボード以外をタッチしたらキーボードが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //imageViewのロゴをボタンのように設定してホーム画面に戻す
    @IBOutlet weak var topView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.isUserInteractionEnabled = true
        topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:))))
        self.view.addSubview(topView)
        
        let loginButton:FBSDKLoginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
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
    // Do any additional setup after loading the view.


override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}
//ログインボタン
@IBAction func didTapSignIn(_ sender: UIButton) {
    let email = emailField.text
    let password = passwordField.text
    Auth.auth().signIn(withEmail: email!, password: password!, completion: { (user, error) in
        guard let _ = user else {
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .userNotFound:
                        self.showAlert("User account not found. Try registering")
                    case .wrongPassword:
                        self.showAlert("Incorrect username/password combination")
                    default:
                        self.showAlert("Error: \(error.localizedDescription)")
                    }
                }
                
                assertionFailure("user and error are nil")
            }
            return
        }
        self.signIn()
    })
}
//パスワード再発行
@IBAction func didRequestPasswordReset(_ sender: UIButton) {
    let prompt = UIAlertController(title: "To Do App", message: "Email:", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
        let userInput = prompt.textFields![0].text
        if (userInput!.isEmpty) {
            return
        }
        Auth.auth().sendPasswordReset(withEmail: userInput!, completion: { (error) in
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .userNotFound:
                        DispatchQueue.main.async {
                            self.showAlert("User account not found. Try registering")
                        }
                    default:
                        DispatchQueue.main.async {
                            self.showAlert("Error: \(error.localizedDescription)")
                        }
                    }
                }
                return
            } else {
                DispatchQueue.main.async {
                    self.showAlert("You'll receive an email shortly to reset your password.")
                }
            }
        })
    }
    prompt.addTextField(configurationHandler: nil)
    prompt.addAction(okAction)
    present(prompt, animated: true, completion: nil)
}
    //画面をタッチするとキーボード閉じる
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
func showAlert(_ message: String) {
    let alertController = UIAlertController(title: "To Do App", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
    self.present(alertController, animated: true, completion: nil)
}

    //ログインしたらSignInFromLoginに飛ぶ
func signIn() {
    performSegue(withIdentifier: "SignInFromLogin", sender: nil)
}
}




