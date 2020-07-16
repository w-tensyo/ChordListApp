//
//  ScaleSelectViewController.swift
//  ChordListApp
//
//  Created by 渡邉天彰 on 2020/07/16.
//  Copyright © 2020 takaaki watanabe. All rights reserved.
//

import UIKit

class ScaleSelectViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var scaleSelectTableView: UITableView!
    
    var pickUpScaleNumber:Int = -1
    
    let scaleDataSource = ["メジャースケール","マイナースケール","ハーモニックマイナースケール","メロディックマイナースケール"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scaleSelectTableView.dataSource = self
        scaleSelectTableView.delegate = self
    }
    
    //表示するCellの数を定義
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scaleDataSource.count
    }
    //Cellの形成を定義
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = scaleDataSource[indexPath.row]
        
        return cell
    }
    
    //Cellをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pickUpScaleNumber = indexPath.row
        
        
    }
    @IBAction func judgementScaleButton(_ sender: UIButton) {
        //遷移元のViewControllerを取得
        let count = (self.navigationController?.viewControllers.count)! - 2
        let selectStateVC = self.navigationController?.viewControllers[count] as! SelectStateViewController
        
        
        selectStateVC.menuListSelectedValue[0] = scaleDataSource[pickUpScaleNumber]
        selectStateVC.pickUpScale = pickUpScaleNumber
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
