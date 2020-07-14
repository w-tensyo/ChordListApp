//
//  ViewController.swift
//  ChordListApp
//
//  Created by 渡邉天彰 on 2020/07/08.
//  Copyright © 2020 takaaki watanabe. All rights reserved.
//

import UIKit

class TopViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    //♭か#かを判定
    //0 = ♭、1 = #
    var signatureState: Int = 1
    
    /*選択した値を次画面へ渡すための変数
     scaleNumber = scaleDataSource[row]
     keyNumber =  keyDataSourceSharp[row] or keyDataSourceFlat[row]
     */
    var scaleNumber:Int = -1
    var keyNumber:Int = -1


    @IBOutlet weak var signatureSwitchView: UISwitch!
    @IBOutlet weak var scaleTextField: UITextField!
    @IBOutlet weak var keyTextField: UITextField!
    //ドラムロールの
    @IBOutlet weak var choiceScalePicker: UIPickerView!
    @IBOutlet weak var choiceKeyPicker: UIPickerView!
    //選択したコードを表示するためのダイアログを定義
    var comfilmSelectChord: UIAlertController!
    
    let pickerView = UIPickerView()
    // ドラムロールボタンの選択肢を配列にして格納
    let keyDataSourceSharp =  ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
    let keyDataSourceflat =  ["C","D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B"]
    let scaleDataSource = ["メジャースケール","マイナースケール","ハーモニックマイナースケール","メロディックマイナースケール"]
    
    override func viewDidLoad() {
        super.viewDidLoad()


        //ダークモードの無効化
        self.overrideUserInterfaceStyle = .light
        //画面幅の取得
        let screenWidth:CGFloat = UIScreen.main.bounds.width
        //画面高さの取得
        let screenHeight:CGFloat = self.view.bounds.height

        //pickerの表示位置をCGRect型で指定
        let pickerFrame:CGRect = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight / 3)

        // pickerViewの配置するx,yと幅と高さを設定.
        choiceKeyPicker.frame = pickerFrame
        choiceScalePicker.frame = pickerFrame
        
        // Delegateを自身に設定する
        choiceKeyPicker.delegate = self
        choiceScalePicker.delegate = self

        
        // 選択肢を自身に設定する
        choiceKeyPicker.dataSource = self
        choiceScalePicker.dataSource = self
        // pickerViewをViewに追加する
        let keyPickerView = UIView(frame: choiceKeyPicker.bounds)
        keyPickerView.backgroundColor = UIColor.white
        keyPickerView.addSubview(choiceKeyPicker)
        
        let scalePickerView = UIView(frame: choiceScalePicker.bounds)
        scalePickerView.backgroundColor = UIColor.white
        scalePickerView.addSubview(choiceScalePicker)

        scaleTextField.text = ""
        keyTextField.text = ""
        
        scaleTextField.inputView = scalePickerView
        keyTextField.inputView = keyPickerView

    }


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            if signatureState == 1{
                return keyDataSourceSharp[row]
            }else{
                return keyDataSourceflat[row]
            }
        }else{
            return scaleDataSource[row]
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        /*pickerViewのTagに付与した番号に合わせて表示するリソースを分岐
        pickerView.tag == 1 -> キーの選択
        pickerView.tag == 2 -> スケールの選択 */
        if pickerView.tag == 1{
            if signatureState == 1{ //調号に合わせて参照する数を分岐させるための処理。 signatureState = 1（つまり#）の場合はこっち
                return keyDataSourceSharp.count
            }else{ //調号に合わせて参照する数を分岐させるための処理。 signatureState != 1（つまり♭）の場合はこっち
                return keyDataSourceflat.count
            }
        }else{
            return scaleDataSource.count
        }
    }

    // ドラムロールで各選択肢が選ばれた時の操作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        /*pickerViewのTagに付与した番号に合わせて表示するリソースを分岐
        pickerView.tag == 1 -> キーの選択
        pickerView.tag == 2 -> スケールの選択 */
        if pickerView.tag == 1{
            if signatureState == 1{ //調号を管理するsignatureStateが1(#)だった場合
                keyTextField.text = keyDataSourceSharp[row]
                keyNumber = row
            }else{ //調号を管理するsignatureStateが2(♭)だった場合
                keyTextField.text = keyDataSourceflat[row]
                keyNumber = row
            }
        }else if pickerView.tag == 2{
            scaleTextField.text = scaleDataSource[row]
            scaleNumber = row
        }
        scaleTextField.endEditing(true)
        keyTextField.endEditing(true)
    }
    
    
    
    //決定ボタンをタップした時の処理
    @IBAction func ChordListVCActionButton(_ sender: Any) {
        /*スケール、Key選択どちらかが空白だったらダイアログを表示したい
          scaleNumber,keyNumberともに初期値を-1に設定しているため、いずれかが空白（-1）だった時にDialogを表示する*/
        if scaleNumber == -1 || keyNumber == -1 {
            attentionDialog(title: "値を入力してください" ,message: "入力に不足がないか確認してください")
        }else{ //両方とも-1以外の値が入っていたら次の画面へ遷移する
            
            //chordListVCとして、遷移先のChordListViewControllerを認識させる（そのための as! ChordListViewController）
            let chordListVC = self.storyboard?.instantiateViewController(identifier: "ChordListVC") as! ChordListViewController
            
            //ChordListViewControllerが持つプロパティに対して、当該画面の変数の値を入れる
            chordListVC.signatureState = signatureState
            chordListVC.startNote = keyNumber
            chordListVC.selectScale = scaleNumber
            
            self.navigationController?.pushViewController(chordListVC,animated: true)
        }
    }
    
    //調号切り替えのUISwitch　ON/OFF切り替えた時の処理
    @IBAction func signatureSwitch(_ sender: UISwitch) {
        if sender.isOn {
            //onの時の処理
            signatureState = 1
            keyTextField.text = ""
            keyNumber = -1
        }else{
            signatureState = 0
            keyTextField.text = ""
            keyNumber = -1
        }
    }
    //ダイアログを表示するメソッドを実装（今後の流用を加味して、titleとmessageに引数を渡せるように設定）
    func attentionDialog(title: String, message: String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //OKボタンの実装
        let alertOkButton:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{ (action:UIAlertAction!) -> Void in })
        
        //alertに選択肢を追加するメソッド
        alert.addAction(alertOkButton)
        //aleratを表示する実装
        present(alert, animated: true,completion: nil)
    }
}
