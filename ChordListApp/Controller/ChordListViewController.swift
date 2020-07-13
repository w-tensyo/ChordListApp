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
    //スケールの選択の番号を前画面から拾ってくる
    var selectScale:Int = -1
    
    //
    var indexNum:Int = 0
    //
    var majarOrMiner:String = ""
    //# ♭それぞれのトーンを配列で用意
    let sharpToneList:Array<String> = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B","C","C#","D","D#","E","F","F#","G","G#","A","A#","B","C","C#","D","D#","E"]
    let flatToneList:Array<String> = ["C","D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B","C","D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B","C","D♭","D","E♭","E"]
    /*sharpToneList　か flatToneListのどちらかを格納するための配列
    どちらを格納するかはsignatureStateの値で判定（viewDidLoad内で処理）*/
    var selectedSignature:Array<String> = []
    
    //TriadTableViewCell.swiftに値を渡すため、Model内に用意した、TriadCode.swiftを用意する
    var triadCodeArray:Array<TriadCode> = []
    
    
    /*true,true = majer
      false,false = スケール外（リストに表示しない
      true,false = miner
      false,true = m♭5
    */
    let MAJER_SCALE:[[Bool]] = [[true,true],[false,false],[true,false],[false,false],[true,false],[true,true],[false,false],[true,true],[false,false],[true,false],[false,false],[false,true]]
    let MINER_SCALE:[[Bool]] = [[true,false],[false,false],[false,true],[true,true],[false,false],[true,false],[false,false],[true,false],[true,true],[false,false],[true,true],[false,false]]
    
    //スケールを格納する二次元配列を用意。↑のBool2次元配列を入れる
    var displayScareArray:[[Bool]] = []
    
    //ListViewで表示するために、必要な12個のノートを抽出。その抽出をしたものを格納する配列
    var adjustToneList:Array<String> = []
    
    //各スケール のルート、3rd、5thを二次元配列で格納
    let MAJERSCALE_CONSITUTION_ARRAY: [[Int]] = [[0,4,7],[1,5,8],[2,5,9],[3,6,10],[4,7,11],[5,9,12],[6,10,13],[7,11,14],[8,12,15],[9,12,16],[10,13,17],[11,14,17]]
    let MINERSCALE_CONSITUTION_ARRAY: [[Int]] = [[0,3,7],[1,4,8],[2,5,8],[3,7,10],[4,8,11],[5,8,12],[6,9,13],[7,10,14],[8,12,15],[9,14,16],[10,14,17],[11,15,18]]

    //↑で定義した定数の二次元配列を格納するための配列
    var consitutionArray:[[Int]] = []
    
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
        
        //前画面で選択したスケールによって使う2次元配列を切り替える
        switch selectScale {
        case 0:
            displayScareArray = MAJER_SCALE
            consitutionArray = MAJERSCALE_CONSITUTION_ARRAY
            break
        case 1:
            displayScareArray = MINER_SCALE
            consitutionArray = MINERSCALE_CONSITUTION_ARRAY
            break
        default:
            displayScareArray = MAJER_SCALE
            consitutionArray = MAJERSCALE_CONSITUTION_ARRAY
            break
        }

        //customCellを認識させるための処理。nibNameには登録させたいファイル名。forCellReuseIdentifierには CustomCellに設定したIdentifierを記述
        chordListTableView.register(UINib(nibName: "TriadTableViewCell",bundle: nil), forCellReuseIdentifier: "TriadCell")

        
        //ListViewに表示するための配列を生成するメソッド
        adjustDisplayTone(tone: startNote)

        chordListTableView.delegate = self
        chordListTableView.dataSource = self

    }
    
    
    //TableViewの実装
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInCectionを呼びますた")
        return 12
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //triadCodeArrayでも使えるように、セル番号が格納されているIndexPath.rowをindexPathNumberに格納
        let indexPathNumber = Int(indexPath.row)
        
        //定数cellに対して、as! TruadTableViewCellで参照するswiftファイルをキャストする。
        let cell = tableView.dequeueReusableCell(withIdentifier: "TriadCell",for: indexPath) as! TriadTableViewCell
        
        
        if displayScareArray[indexPath.row][0] == true && displayScareArray[indexPath.row][1] == true{
            majarOrMiner = " maj  "
        }else if displayScareArray[indexPath.row][0] == true && displayScareArray[indexPath.row][1] == false{
            majarOrMiner = "  m   "
        }else if displayScareArray[indexPath.row][0] == false && displayScareArray[indexPath.row][1] == true{
            majarOrMiner = " m(♭5)"
        }else{
            majarOrMiner = "  --  "
        }
        
        
        
        
        //triadCodeArrayを配列で宣言していたので、その末尾にTriadCode型の配列を追加
        triadCodeArray.append(TriadCode())
        
        //TriadTableViewCellで実装しているsetTriadCodeに以下のパラメータを入れていく
        
        triadCodeArray[indexPathNumber].rootNote = self.adjustToneList[consitutionArray[indexPath.row][0]]
        triadCodeArray[indexPathNumber].triadCode = majarOrMiner
        triadCodeArray[indexPathNumber].rootToneNumber = self.adjustToneList[consitutionArray[indexPath.row][0]]
        triadCodeArray[indexPathNumber].thirdToneNumber = self.adjustToneList[consitutionArray[indexPath.row][1]]
        triadCodeArray[indexPathNumber].fifthToneNumber = self.adjustToneList[consitutionArray[indexPath.row][2]]

        
        cell.setTriadCode(triadCode: triadCodeArray[indexPathNumber])

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if displayScareArray[indexPath.row][0] == true && displayScareArray[indexPath.row][1] == true{ //majerの場合
            return 48
        }else if displayScareArray[indexPath.row][0] == true && displayScareArray[indexPath.row][1] == false{ //minerの場合{
            return 48
        }else if displayScareArray[indexPath.row][0] == false && displayScareArray[indexPath.row][1] == true{ //miner♭5の場合
            return 48
        }else{ //ダイアトニックスケール外の場合
            return 0
        }
    }
    
    //スケールのルート音から12個の音をadjustToneListに格納する
    //tone = startNote
    func adjustDisplayTone(tone:Int){
            
        let arraySlice = selectedSignature.dropFirst(tone)
        adjustToneList = Array(arraySlice)
        print(adjustToneList)
        
    }
    
    //ダイアトニックスケールを生成する
    func adjustDiatonicScale(row:Int) -> Bool{
        var result:Bool
        if displayScareArray[row][0] == true && displayScareArray[row][1] == true{ //majerの場合
            result = true
        }else if displayScareArray[row][0] == true && displayScareArray[row][1] == false{ //minerの場合{
            result = true
        }else if displayScareArray[row][0] == false && displayScareArray[row][1] == true{ //miner♭5の場合
            result = true
        }else{ //ダイアトニックスケール外の場合
            result = false

        }
        //falseかtrueを返す
        return result
    }
}
