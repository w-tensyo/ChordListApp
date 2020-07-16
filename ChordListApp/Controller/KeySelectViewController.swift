//
//  KeySelectViewController.swift
//  ChordListApp
//
//  Created by 渡邉天彰 on 2020/07/15.
//  Copyright © 2020 takaaki watanabe. All rights reserved.
//

import UIKit

protocol getSelectedKeyProtocolDelegate {
    func getSelectedKey(keyString:String,keyInteger:Int)
}

class KeySelectViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var keySelectTableView: UITableView!
    @IBOutlet weak var selectKeyLabel: UILabel!
    
    
    var pickUpSignature:Int = 1
    
    //表示するキーの配列を定数で用意（変動しないため）
    var selectedKeySigunature:Array<String> = []
    //調号が#の配列
    let keyDataSourceSharp =  ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
    //調号が♭の配列
    let keyDataSourceflat =  ["C","D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B"]
    
    //遷移元画面に値を渡すための変数
    var pickUpKeyNumber:Int = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedKeySigunature = keyDataSourceSharp

        keySelectTableView.delegate = self
        keySelectTableView.dataSource = self
        
        selectKeyLabel.text = ""
        
    }
    
    //Cell数を返す処理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedKeySigunature.count
    }
    
    //Cellの中身を形成する処理
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = selectedKeySigunature[indexPath.row]
        
        return cell
    }
    
    //対象のCellをタップした時の挙動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectKeyLabel.text = selectedKeySigunature[indexPath.row]
        
        pickUpKeyNumber = indexPath.row
    }
    
    @IBAction func sigunatureSegment(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            selectedKeySigunature = keyDataSourceSharp
            pickUpSignature = 1
            break
        case 1:
            selectedKeySigunature = keyDataSourceflat
            pickUpSignature = 2
            break
        default:
            break
        }
        
        keySelectTableView.reloadData()
    }
    
    @IBAction func judgmentKeyButton(_ sender: Any) {
//        let storyboard:UIStoryboard = self.storyboard!
//        let vc = storyboard.instantiateViewController(identifier: "TopVC") as! SelectStateViewController
        
        let count = (self.navigationController?.viewControllers.count)! - 2
        let selectStateVC = self.navigationController?.viewControllers[count] as? SelectStateViewController
        //遷移元のSelectStateViewControllerが持つ、selectedNoteとmenuListSelectedValue に選択した値を入れる
        selectStateVC!.menuListSelectedValue[1] = self.selectedKeySigunature[pickUpKeyNumber]
        selectStateVC!.pickUpKey = self.pickUpKeyNumber
        selectStateVC!.pickUpSignature = self.pickUpSignature
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
