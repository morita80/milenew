//
//  SearchResultsViewController.swift
//  mileshareApp
//
//  Created by 森田宣広 on 2018/03/18.
//  Copyright © 2018年 森田宣広. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SearchResultsViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //各記入欄を繋げる
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var peopleCount: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var purpose: UITextField!
    
    //pickerViewを変数化にして配列にする
    var pickerView: UIPickerView = UIPickerView()
    var pickerView1: UIPickerView = UIPickerView()
    var pickerView2: UIPickerView = UIPickerView()
    let count = ["1", "2", "3", "4", "5", "6", "7", "8"]
    let timeCount = ["午前", "午後"]
    let purposeCount = ["ビジネス", "旅行", "その他"]
    
    //文字列を保持するためのString型
    var datelabel1 : String?
    var departureLabel1 : String?
    var arrivalLabel1 : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mainViewの航路や日付を表示
        dateLabel.text = "往路     \(datelabel1!)"
        departureLabel.text = "ご出発     \(departureLabel1!)"
        arrivalLabel.text = "ご到着      \(arrivalLabel1!)"
        
        //人数を確定するための設定
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        pickerView.tag = 1
        
        pickerView1.delegate = self
        pickerView1.dataSource = self
        pickerView1.showsSelectionIndicator = true
        pickerView1.tag = 2
        
        pickerView2.delegate = self
        pickerView2.dataSource = self
        pickerView2.showsSelectionIndicator = true
        pickerView2.tag = 3

        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SearchResultsViewController.done))

        toolbar.setItems([doneItem], animated: true)
        
        self.peopleCount.inputView = pickerView
        self.peopleCount.inputAccessoryView = toolbar
        self.peopleCount.text = count[0]
        
        self.time.inputView = pickerView1
        self.time.inputAccessoryView = toolbar
        self.time.text = timeCount[0]

        self.purpose.inputView = pickerView2
        self.purpose.inputAccessoryView = toolbar
        self.purpose.text = purposeCount[0]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func numberOfComponents1(in pickerView1: UIPickerView) -> Int {
        return 1
    }
    
    func numberOfComponents2(in pickerView2: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {     // <<<<<<<<<<　変更
            return count.count
        } else if pickerView.tag == 2 {
            return timeCount.count
        } else {
            return purposeCount.count
        }
    }
    
//    func pickerView1(_ pickerView1: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return timechange.count
//
//    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {    // <<<<<<<<<<　変更
            return count[row]
        } else if pickerView.tag == 2{
            return timeCount[row]
        } else {
            return purposeCount[row]
        }

    }
//
//    func pickerView1(_ pickerView1: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return timechange[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {      // <<<<<<<<<<　変更
            peopleCount.text = count[row]
        } else if pickerView.tag == 2 {
            time.text = timeCount[row]
        } else {
            purpose.text = purposeCount[row]
        }
    }
    
//    func pickerView1(_ pickerView1: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        self.time.text = timechange[row]
//    }
    
    
    @objc func done() {
        self.peopleCount.endEditing(true)
        self.time.endEditing(true)
        self.purpose.endEditing(true)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    //ナビゲーションバーを出す
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)

    }
    //次の画面推移時にデータを移す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ConfirmationViewController = segue.destination as! ConfirmationViewController
        ConfirmationViewController.datelabel1 = dateLabel.text
        ConfirmationViewController.departureLabel1 = departureLabel.text
        ConfirmationViewController.arrivalLabel1 = arrivalLabel.text
        ConfirmationViewController.peopleCountLabel1 = peopleCount.text
        ConfirmationViewController.timeLabel1 = time.text
        ConfirmationViewController.purposeLabel1 = purpose.text
   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func confirmationAction(_ sender: Any) {
         performSegue(withIdentifier: "confirmationAction", sender: nil)
    }
    
    //画面をタッチするとキーボード閉じる
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
