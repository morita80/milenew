//
//  MemberInfoSaveViewController.swift
//  mileshareApp
//
//  Created by 森田宣広 on 2018/03/24.
//  Copyright © 2018年 森田宣広. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MemberInfoSaveViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var firstNameText: UILabel!
    @IBOutlet weak var lastNameText: UILabel!
    @IBOutlet weak var firstNameKana: UILabel!
    @IBOutlet weak var lastNameKana: UILabel!
    @IBOutlet weak var birthText: UILabel!
    @IBOutlet weak var telText: UILabel!
    //文字列を保持するためのString型
    var firstNameText1 : String?
    var lastNameTextl1 : String?
    var firstNameKana1 : String?
    var lastNameKana1 : String?
    var birthText1 : String?
    var telText1 : String?
    
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
        
        //会員情報のデータを引き継ぎ表示
        firstNameText.text = firstNameText1!
        lastNameText.text = lastNameTextl1!
        firstNameKana.text = firstNameKana1!
        lastNameKana.text = lastNameKana1!
        birthText.text = birthText1!
        telText.text = telText1
        
        //インスタンスを作成
        DBRef = Database.database().reference()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //ログインしているユーザーに関する情報を必要とするアプリの各ビューに対して、FIRAuth オブジェクトにリスナーをアタッチ
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            // [START_EXCLUDE]
            
            // [END_EXCLUDE]
        }
        // [END auth_listener]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // [START remove_auth_listener]
        Auth.auth().removeStateDidChangeListener(handle!)
        // [END remove_auth_listener]
    }
    
    //会員情報firebase登録
    @IBAction func memberSaveButton(_ sender: UIButton) {
        // Add a new document with a generated ID
       //Vacancyinqiry
        if let uid = Auth.auth().currentUser?.uid{
            let ref = db.collection("users").document(uid)
            
            ref.updateData(["firstName": firstNameText.text!,
                            "lastName": lastNameText.text!,
                            "firstNameKana": firstNameKana.text!,
                            "lastNameKana": lastNameKana.text!,
                            "birth": birthText.text!,
                            "tel": telText.text!]){ err in
                                if let err  = err {
                                    print("Error update document: \(err)")
                                }else{
                                    print("Document successfully update")
                                }
            }
        }
    }
    
  
    
    //画面をタップしたらキーボード下がる
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        
        
    }
    
}
