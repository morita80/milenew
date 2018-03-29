//
//  ViewController.swift
//  mileshareApp
//
//  Created by 森田宣広 on 2018/03/03.
//  Copyright © 2018年 森田宣広. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ViewController: UIViewController,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    //変数を宣言する
    //今日の日付を代入
    let nowDate = NSDate()
    let dateFormat = DateFormatter()
    let inputDatePicker = UIDatePicker()
    var pickerView: UIPickerView = UIPickerView()
    var pickerView1: UIPickerView = UIPickerView()
    let departure = ["新千歳", "羽田空港", "成田", "大阪", "伊丹", "6", "7", "8"]
    let arrival = ["福岡", "那覇"]
    
    
    //カレンダーを出すtextField
    @IBOutlet weak var dateSelecter: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //ピッカー設定
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.showsSelectionIndicator = true
        self.pickerView.tag = 1
        
        pickerView1.delegate = self
        pickerView1.dataSource = self
        pickerView1.showsSelectionIndicator = true
        pickerView1.tag = 2
        
        func done() {
            self.depertuerSarchAction.endEditing(true)
            self.arrivalSarchAction.endEditing(true)
            
        }
        
        func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
            return CGRect(x: x, y: y, width: width, height: height)
        }
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SearchResultsViewController.done))
        
        toolbar.setItems([doneItem], animated: true)
        
        self.depertuerSarchAction.inputView = pickerView1
        self.depertuerSarchAction.inputAccessoryView = toolbar
        self.depertuerSarchAction.text = departure[0]
        
        self.arrivalSarchAction.inputView = pickerView1
        self.arrivalSarchAction.inputAccessoryView = toolbar
        self.arrivalSarchAction.text = arrival[0]

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView.tag == 1 {     // <<<<<<<<<<　変更
                return departure.count
            } else  {
                return self.arrival.count
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView.tag == 1 {    // <<<<<<<<<<　変更
                return departure[row]
            } else {
                return arrival[row]
            }
            
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if pickerView.tag == 1 {      // <<<<<<<<<<　変更
                depertuerSarchAction.text = departure[row]
            } else {
                arrivalSarchAction.text = arrival[row]
            }
        }
        
      
        
        
        
        //日付フィールドの設定
        dateFormat.dateFormat = "yyyy年MM月dd日"
        dateSelecter.text = dateFormat.string(from: nowDate as Date)
        self.dateSelecter.delegate = self as! UITextFieldDelegate
        
       
        
        
        // DatePickerの設定(日付用)
        inputDatePicker.datePickerMode = UIDatePickerMode.date
        dateSelecter.inputView = inputDatePicker
        
       
        // キーボードに表示するツールバーの表示
        let pickerToolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        pickerToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar.barStyle = .blackTranslucent
        pickerToolBar.tintColor = UIColor.white
        pickerToolBar.backgroundColor = UIColor.black
        
        //ボタンの設定
        //右寄せのためのスペース設定
        let spaceBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,target: self,action: "")
        
        //完了ボタンを設定
         let toolBarBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.toolBarBtnPush(sender:)))
        
        //ツールバーにボタンを表示
        pickerToolBar.items = [spaceBarBtn,toolBarBtn]
        dateSelecter.inputAccessoryView = pickerToolBar
        
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //ナビゲーションバーを隠す
        navigationController?.setNavigationBarHidden(true, animated: false)

        if let _ = Auth.auth().currentUser {
            self.alreadysignIn()
        }

    }
     //ログインしているユーザーに関する情報を必要とするアプリの各ビューに対して、FIRAuth オブジェクトにリスナーをアタッチ
    var handle: AuthStateDidChangeListenerHandle?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // [START auth_listener]
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
    
    //乗る空港を入れるtextField
   
    @IBOutlet weak var depertuerSarchAction: UITextField!
    //降りる空港を入れるtextField
   
    @IBOutlet weak var arrivalSarchAction: UITextField!
    
    @IBOutlet weak var button: UIButton!
    @IBAction func buttonTapp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        if depertuerSarchAction.text == "" || arrivalSarchAction.text == ""{
            
        } else {
           performSegue(withIdentifier: "loginView", sender: nil)
        }
    }
        
    
    
   
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    @objc func toolBarBtnPush(sender: UIBarButtonItem){
        
        let pickerDate = inputDatePicker.date
        dateSelecter.text = dateFormat.string(from: pickerDate)
        
        self.view.endEditing(true)
   
}
    //画面をタッチするとキーボード閉じる
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    func alreadysignIn() {
        performSegue(withIdentifier: "alreadysignIn", sender: nil)
    }
  
}
