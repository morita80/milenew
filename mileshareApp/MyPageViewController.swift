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
import FirebaseFirestore
import FirebaseStorage
import SDWebImage


class MyPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var myName: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var db: Firestore!
    //イメージ画像設定
    @IBAction func myPicture(_ sender: Any) {
//        func didTapProfile() {
            print("くりっく")
//            if UIImagePickerController.isSourceTypeAvailable(
//                UIImagePickerControllerSourceType.photoLibrary) {
//
//                let controller = UIImagePickerController()
//                controller.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
//                controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
//                self.present(controller, animated: true, completion: nil)
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    let picker = UIImagePickerController()
                    picker.sourceType = .photoLibrary
                    picker.delegate = self
                    picker.allowsEditing = true
                    present(picker, animated: true, completion: nil)
                }else{
                    print("エラー")
                }
//            }
        }
    
    var images : UIImage!
    let storage = Storage.storage()
    //画像が選択し終わった時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        images = info[UIImagePickerControllerEditedImage] as! UIImage
        //ストレージ接続
        let ref = storage.reference()
        
        //時間を取得
        let date = NSDate()
        //時間を文字列に整形
        let format = DateFormatter()
        format.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        //整形した文字列を画像のpathに整形
        let datePath = format.string(from: date as Date)
        //画像をjpgのデータ形式に変換
        let data: Data = UIImageJPEGRepresentation(images, 0.1)!
        //ストレージの保存先のpathを指定
        let imagePath = ref.child("image").child("\(datePath).jpg")
        //ストレージにデータ形式で画像を保存
        let uploadTask = imagePath.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL
            print("downloadURL\(downloadURL)")
            self.db = Firestore.firestore()
            if let uid = Auth.auth().currentUser?.uid{
                print("uid:\(uid)")
                self.db.collection("users").document(uid).updateData([
                "profPath" : "\(datePath).jpg"
            ])
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    //タイトル名をtitleArrayという定数の中に配列で入力
    var titleArray = ["現在受付中の予約","過去予約履歴","メール一覧","会員情報変更","問い合わせ","ログアウト"]
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
        //画像設定
        let ud = UserDefaults.standard
        ud.set(0, forKey: "count")
       
        
//        //ユーザーネーム表示
//        if let uid = Auth.auth().currentUser?.uid{
//            print(uid)
//            db = Firestore.firestore()
//            if let ref: DocumentReference = db.collection("users").document(uid){
//                ref.getDocument(completion: { (snap, error) in
//                    if let error = error{
//                        print(error.localizedDescription)
//                    }else{
//                        let data = snap?.data()
//                        print(data)
////                        if let name = data!["UserName"] as? String{
////                            self.myName.text = name
////                        }
//                    }
//                })
//            }
//
//
//        }
    }
    var handle: AuthStateDidChangeListenerHandle?
    var getmainArray = [StorageReference]()
    var getArray: String!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ストレージ接続
        let storage = Storage.storage().reference()
        self.db = Firestore.firestore()
        
        if let uid = Auth.auth().currentUser?.uid{
            let myPictureRef = self.db.collection("users").document(uid)
            myPictureRef.getDocument(completion: { (document, err) in
                let data = document?.data()
                let path = data!["profPath"]
                print(path)
               self.db = Firestore.firestore()
                //StorageReference型に変換
                 let ref = storage.child("image/\(path!)")
                print(ref)
                ref.downloadURL { url, error in
                    if let error = error {
                        // Handle any errors
                    } else {
                        //imageViewに描画、SDWebImageライブラリを使用して描画
                        self.imageView.sd_setImage(with: url!, completed: nil)
                    }
                }
                
             
            })
           
        }
        
    
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // [START remove_auth_listener]
       
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
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
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
