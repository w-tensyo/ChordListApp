//
//  ChordListViewController.swift
//  ChordListApp
//
//  Created by 渡邉天彰 on 2020/07/10.
//  Copyright © 2020 takaaki watanabe. All rights reserved.
//

import UIKit

class ChordListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //前画面から取得する値等
    var signatureState:Int = -1
    var startNote:Int = -1
    var selectScale:Int = -1
    
    //# ♭それぞれのトーンを配列で用意
    let sharpToneList:Array<String> = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B","C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
    let flatToneList:Array<String> = ["C","D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B","C","D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B"]
    
    /*sharpToneList　か flatToneListのどちらかを格納するための配列
    どちらを格納するかはsignatureStateの値で判定（viewDidLoad内で処理）*/
    var selectedSignature:Array<String> = []
    
    let MAJER_SCALE:Array<Bool> = [true,false,false,false,true,false,false,true,false,false,false,false]
    //ListViewで表示するために、必要な12個のノートを抽出。その抽出をしたものを格納する配列
    var adjustToneList:Array<String> = []

    @IBOutlet weak var chordListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //前画面で選択した調号の状態によって使う配列を切り替える
        if signatureState == 1{
            //signatureState = 1 (#だった時)はsharpToneListの配列を格納する
            selectedSignature = sharpToneList

        }else{
            //signatureState = 2 (♭だった時)
            selectedSignature = flatToneList
        }


        
        //ListViewに表示するための配列を生成するメソッド
        adjustDisplayTone(tone: startNote)

        chordListTableView.delegate = self
        chordListTableView.dataSource = self

    }
    
    
    //TableViewの実装
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInCectionを呼びますた")
        return adjustToneList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)


        // cellにテキストを表示
        cell.textLabel?.text = "\(indexPath.row)番目の配列の中身は\(self.adjustToneList[indexPath.row])"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if MAJER_SCALE[indexPath.row] != true{
            return 0
        }else{
            return 40
        }
    }
    
    func adjustDisplayTone(tone:Int){
        var indexNum:Int = tone
        for _ in 0..<12{
            adjustToneList.append(selectedSignature[indexNum])
            indexNum += 1
        }
    }
}
