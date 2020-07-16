//
//  SelectStateViewController.swift
//  ChordListApp
//
//  Created by 渡邉天彰 on 2020/07/14.
//  Copyright © 2020 takaaki watanabe. All rights reserved.
//

import UIKit

class SelectStateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var settingTableView: UITableView!
    
    //遷移先で設定した値を格納する変数
    var pickUpKey:Int = -1
    var pickUpSignature:Int = 1
    var pickUpScale:Int = -1
    
    //メニューの要素を配列で準備
    var menuListArray:[[String]] = [["scaleIcon","スケール"],["keyIcon","Keyの選択"]]
    var menuListSelectedValue:[String] = ["",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        settingTableView.delegate = self
        settingTableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        settingTableView.reloadData()
        
    }
    //セクション内のCell数を決めるメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuListArray.count
    }
    
    //セルの中身を実装するメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        
        
        let image = UIImage(named: menuListArray[indexPath.row][0])
        cell.imageView?.image = image?.resize(size: CGSize(width: 30, height: 30))
        cell.textLabel?.text = menuListArray[indexPath.row][1]
        cell.detailTextLabel?.text = menuListSelectedValue[indexPath.row]
        
        return cell
    }
    
    
    //セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //switch文で遷移先を分岐。
        switch indexPath.row {
        case 0: // キー選択画面への遷移
            let nextView = storyboard!.instantiateViewController(withIdentifier: "ScaleSelectVC") as! ScaleSelectViewController
            
            if pickUpScale != -1{ //pickUpScaleが未選択（-1)ではない場合（つまり何かしらすでに選択されている）のであれば、それを遷移先に渡してあげる処理
                nextView.pickUpScaleNumber = pickUpScale
            }
            //遷移先を表示する
            navigationController?.pushViewController(nextView, animated: true)
            break
            
        case 1: // スケール選択画面への遷移
            let nextView = storyboard!.instantiateViewController(withIdentifier: "KeySelectVC") as! KeySelectViewController

            if pickUpKey != -1{ //pickUpkeyが未選択（-1)ではない場合（つまり何かしらすでに選択されている）のであれば、それを遷移先に渡してあげる処理
                nextView.pickUpKeyNumber = pickUpKey
            }

            //遷移先を表示する
            navigationController?.pushViewController(nextView, animated: true)
            break
            
        default: // 何かしらしっかり選択できていなかった時の処理
            let nextView = storyboard!.instantiateViewController(withIdentifier: "KeySelectVC") as! KeySelectViewController

            if pickUpKey != -1{ //pickUpkeyが未選択（-1)ではない場合（つまり何かしらすでに選択されている）のであれば、それを遷移先に渡してあげる処理
                nextView.pickUpKeyNumber = pickUpKey
            }
            
            //遷移先を表示する
            navigationController?.pushViewController(nextView, animated: true)
            break
        }
    }
    
    /*「リストを表示する」ボタンをタップして、一覧画面を表示するためのボタン
    pickUpKey,pickUpScaleを渡して、それを基準にリストを形成する*/
    @IBAction func resultViewButton(_ sender: Any) {
    
        
        if pickUpKey == -1 || pickUpScale == -1{
            //アラートを表示する予定
        
        }else{
            if pickUpScale <= 2{ //TriadTableViewを表示する
                let resultVC = self.storyboard?.instantiateViewController(identifier: "MajerMinerVC") as! MajerMinerListViewController
                
                resultVC.pickUpKey = pickUpKey
                resultVC.pickUpScale = pickUpScale
                resultVC.pickUpSignature = pickUpSignature
                print("pickUpSignature:\(pickUpSignature)")
                print("pickUpScale\(pickUpScale)")
                
                self.navigationController?.pushViewController(resultVC, animated: true)
                
            }else{ // HarmonicAndMelodicMinarTableViewを表示する
                let resultVC = self.storyboard?.instantiateViewController(identifier: "HarmoMeloVC") as! HarmoMelodicListViewController
                
                self.navigationController?.pushViewController(resultVC, animated: true)
            }
        }
        
        
    }
    
    
}

/*画像をリサイズするメソッド
 参照：　https://qiita.com/ryokosuge/items/d997389529faffab33ba
 drawについては記述を以下に変更
 drawInRect　から　draw(in:CGRect~~)
*/
extension UIImage {

    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let resizedSize = CGSize(width: (self.size.width * ratio), height: (self.size.height * ratio))
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 2)
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
