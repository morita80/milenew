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
import FirebaseFirestore

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var UsernameField: UITextField!
    
    @IBOutlet weak var topView: UIImageView!
    
    
    var ref: DocumentReference? = nil
    var db: Firestore!
    // インスタンス変数
    var DBRef:DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        //インスタンスを作成
        DBRef = Database.database().reference()
        
        topView.isUserInteractionEnabled = true
        topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:))))
        self.view.addSubview(topView)
        
        //facebookloginnbutton
        let loginButton = LoginButton(readPermissions: [ .email ])
        loginButton.delegate = UIApplication.shared.delegate as! AppDelegate
        loginButton.frame = CGRect(x: 80, y: 220, width: 215, height: 40)
        view.addSubview(loginButton)
    }
    
    //ログインしているユーザーに関する情報を必要とするアプリの各ビューに対して、FIRAuth オブジェクトにリスナーをアタッチ
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureObserver()
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // [START_EXCLUDE]
            
            // [END_EXCLUDE]
        }
        // [END auth_listener]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.removeObserver() // Notificationを画面が消えるときに削除
        // [START remove_auth_listener]
        Auth.auth().removeStateDidChangeListener(handle!)
        // [END remove_auth_listener]
    }
    
    // Notificationを設定
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Notificationを削除
    func removeObserver() {
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    // キーボードが現れた時に、画面全体をずらす。
    @objc func keyboardWillShow(notification: Notification?) {
        
        let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
            self.view.transform = transform
            
        })
    }
    
    // キーボードが消えたときに、画面を戻す
    @objc func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder() // Returnキーを押したときにキーボードを下げる
        return true
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
        
            self.SignInFromSignUp(); self.signIn(email:email!,psssword:password!)
        })
    }
    
    func signIn(email:String,psssword:String) {
        let username = UsernameField.text
        Auth.auth().signIn(withEmail: email, password: psssword, completion: { (user, error) in

            print("書き込み開始")
             self.db.collection("users").document((user?.uid)!).setData([
                "UserName": self.UsernameField.text!,
                "MyUID": user?.uid,
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
            }

         
            print("終了")
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
    
    
    func SignInFromSignUp() {
        performSegue(withIdentifier: "SignInFromSignUp", sender: nil)
    }
    
}
