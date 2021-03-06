//
//  MainViewController.swift
//  mileshareApp
//
//  Created by 森田宣広 on 2018/03/08.
//  Copyright © 2018年 森田宣広. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: UIViewController,UITextFieldDelegate {

    //変数を宣言する
    //今日の日付を代入
    let nowDate = NSDate()
    let dateFormat = DateFormatter()
    let inputDatePicker = UIDatePicker()
    
    //カレンダーを出すtextField
    @IBOutlet weak var dateSelecter: UITextField!
    //乗る空港を入れるtextField
    @IBOutlet weak var depertuerSarch: UITextField!
    //降りる空港を入れるtextField
    @IBOutlet weak var arrivalSarch: UITextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    //テキストの値を次の画面に渡す処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let SearchResultsViewController = segue.destination as! SearchResultsViewController
        SearchResultsViewController.datelabel1 = dateSelecter.text
        SearchResultsViewController.departureLabel1 = depertuerSarch.text
        SearchResultsViewController.arrivalLabel1 = arrivalSarch.text
        
    }
   
    
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    @objc func toolBarBtnPush(sender: UIBarButtonItem){
        
        let pickerDate = inputDatePicker.date
        dateSelecter.text = dateFormat.string(from: pickerDate)
        
        self.view.endEditing(true)
    }
    
    //キーボード以外をタッチしたらキーボードが閉じる
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func searchAction(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
//        if dateSelecter.text == "" || depertuerSarch.text == "" || arrivalSarch.text == ""{
//
//        } else {
            performSegue(withIdentifier: "nextSegue", sender: nil)
//        }
    
    }
    
}
