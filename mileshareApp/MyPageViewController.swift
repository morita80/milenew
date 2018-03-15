//
//  MyPageViewController.swift
//  mileshareApp
//
//  Created by 森田宣広 on 2018/03/14.
//  Copyright © 2018年 森田宣広. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MyPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //タイトル名をtitleArrayという定数の中に配列で入力
    let titleArray = ["現在受付中の予約","過去予約履歴","メール一覧","会員情報変更","問い合わせ","ログアウト"]
    //ナンバリングをする
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
        
    }
    //セルの数文セルが増えて行く
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //cellに上からナンバリングされて、ナンバリングごとの画面推移を指定
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
          performSegue(withIdentifier: "bookingConfirmation", sender: nil)
        }
        if indexPath.row == 1{
            performSegue(withIdentifier: "reservationHistory", sender: nil)
        }
        
        if indexPath.row == 2 {
            performSegue(withIdentifier: "emailList", sender: nil)
        }
        
        if indexPath.row == 3 {
            performSegue(withIdentifier: "memberInfChange", sender: nil)
        }
        
        if indexPath.row == 4 {
            performSegue(withIdentifier: "inquiry", sender: nil)
        }
        if indexPath.row == 5 {
            do {
                try Auth.auth().signOut()
                //重なっているviewを全て削除して、rootiewに戻る
                UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
            } catch let error {
                assertionFailure("Error signing out: \(error)")
            }

        }
    }
}
