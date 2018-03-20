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
import MessageUI

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //mainViewの航路や日付を表示
        datelabel.text = "     \(datelabel1!)"
        departureLabel.text = "     \(departureLabel1!)"
        arrivalLabel.text = "     \(arrivalLabel1!)"
        peopleCountLabel.text = "人数　　　　　\(peopleCountLabel1!) 人"
        timeLabel.text = "希望時間帯　　　　　\(timeLabel1!)"
        purposeLabel.text = "ご利用の目的　　　　　\(purposeLabel1!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendEmail(_ sender: UIButton) {
        performSegue(withIdentifier: "sendEmail", sender: nil)

    }
    
    //画面をタッチするとキーボード閉じる
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    

}
