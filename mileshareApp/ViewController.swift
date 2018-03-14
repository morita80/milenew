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

class ViewController: UIViewController,UITextFieldDelegate {
    
    //変数を宣言する
    //今日の日付を代入
    let nowDate = NSDate()
    let dateFormat = DateFormatter()
    let inputDatePicker = UIDatePicker()
    
    //カレンダーを出すtextField
    @IBOutlet weak var dateSelecter: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let _ = Auth.auth().currentUser {
            self.alreadysignIn()
        }
    
        
        
        //日付フィールドの設定
        dateFormat.dateFormat = "yyyy年MM月dd日"
        dateSelecter.text = dateFormat.string(from: nowDate as Date)
        self.dateSelecter.delegate = self as! UITextFieldDelegate
        
        
        // DatePickerの設定(日付用)
        inputDatePicker.datePickerMode = UIDatePickerMode.date
        dateSelecter.inputView = inputDatePicker
        
        func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
            return CGRect(x: x, y: y, width: width, height: height)
        }
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
    //キーボード以外をタッチしたらキーボードが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //乗る空港を入れるtextField
    @IBAction func depertuerSarchAction(_ sender: Any) {
    }
    //降りる空港を入れるtextField
    @IBAction func arrivalSarchAction(_ sender: Any) {
    }
    
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    @objc func toolBarBtnPush(sender: UIBarButtonItem){
        
        let pickerDate = inputDatePicker.date
        dateSelecter.text = dateFormat.string(from: pickerDate)
        
        self.view.endEditing(true)
   
   
}
    func alreadysignIn() {
        performSegue(withIdentifier: "alreadysignIn", sender: nil)
    }
}
