//
//  ConfirmationViewController.swift
//  mileshareApp
//
//  Created by 森田宣広 on 2018/03/20.
//  Copyright © 2018年 森田宣広. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import MessageUI
import FirebaseFirestore

class ConfirmationViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, MFMailComposeViewControllerDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var peopleCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var purposeLabel: UILabel!
    
    
     //文字列を保持するためのString型
    var datelabel1 : String?
    var departureLabel1 : String?
    var arrivalLabel1 : String?
    var peopleCountLabel1 : String?
    var timeLabel1 : String?
    var purposeLabel1 : String?
    
     var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        //mainViewの航路や日付を表示
        datelabel.text = "往路　　　　\(datelabel1!)"
        departureLabel.text = "ご出発　　　　\(departureLabel1!)"
        arrivalLabel.text = "ご到着　　　　\(arrivalLabel1!)"
        peopleCountLabel.text = "人数　　　　　\(peopleCountLabel1!) 人"
        timeLabel.text = "希望時間帯　　　　　　\(timeLabel1!)"
        purposeLabel.text = "ご利用の目的　　　　　\(purposeLabel1!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //メーラ起動　送信画面立ち上げ
    @IBAction func sendEmail(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["n.morita.test@gmail.com"]) // 宛先アドレス
            mail.setSubject("お問い合わせ") // 件名
            mail.setMessageBody("往路　　\(datelabel1!)\nご出発　　\(departureLabel1!)\nご到着　　\(arrivalLabel1!)\n搭乗人数　　　\(peopleCountLabel1!)\n希望時間　　\(timeLabel1!)\nご利用の目的　　\(purposeLabel1!)", isHTML: false)  // 本文,,,,,,,
                present(mail, animated: true, completion: nil)
        } else {
            print("送信できません")
        }
    }
    //イベント終了後処理
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("キャンセル")
        case .saved:
            print("下書き保存")
        case .sent:
            performSegue(withIdentifier: "sendEmail", sender: nil)
            // Add a new document with a generated ID
            if let uid = Auth.auth().currentUser?.uid{
              let ref = db.collection("VacancyInquiry").document(uid).setData([
                "date": datelabel1!,
                "departure": departureLabel1!,
                "arrival": arrivalLabel1!,
                "peopleCount": peopleCountLabel1!,
                "time": timeLabel1!,
                "purpose": purposeLabel1!
                
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(uid)")
                }
            }
        }
            print("送信成功")
        default:
            print("送信失敗")
        }
        dismiss(animated: true, completion: nil)
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
    
    //画面をタッチするとキーボード閉じる
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    

}
