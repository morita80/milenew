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
    
    
    let titleArray = ["現在受付中の予約","過去予約履歴","メール一覧","会員情報変更","問い合わせ","ログアウト"]
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArray.count
        
    }
    
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
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            performSegue(withIdentifier: "bookingConfirmation", sender: (Any).self)
        }
        if indexPath.row == 1{
            performSegue(withIdentifier: "reservationHistory", sender: (Any).self)
        }
        
        if indexPath.row == 2 {
            performSegue(withIdentifier: "emailList", sender: (Any).self)
        }
        
        if indexPath.row == 3 {
            performSegue(withIdentifier: "memberInfChange", sender: (Any).self)
        }
        
        if indexPath.row == 4 {
            performSegue(withIdentifier: "inquiry", sender: (Any).self)
        }
        if indexPath.row == 5 {
            do {
                try Auth.auth().signOut()
                performSegue(withIdentifier: "signOut", sender: nil)
            } catch let error {
                assertionFailure("Error signing out: \(error)")
            }

        }
    }
}
