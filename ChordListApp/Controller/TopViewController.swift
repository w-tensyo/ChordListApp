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


        //画面幅の取得
        let screenWidth:CGFloat = UIScreen.main.bounds.width
        print(screenWidth)
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
        if pickerView.tag == 1{
            if signatureState == 1{
                return keyDataSourceSharp.count
            }else{
                return keyDataSourceflat.count
            }
        }else{
            return scaleDataSource.count
        }
    }

    // 各選択肢が選ばれた時の操作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            if signatureState == 1{
                keyTextField.text = keyDataSourceSharp[row]
                keyNumber = row
                print(Int(keyNumber))
            }else{
                keyTextField.text = keyDataSourceflat[row]
                keyNumber = row
                print(Int(keyNumber))
            }
        }else if pickerView.tag == 2{
            scaleTextField.text = scaleDataSource[row]
            scaleNumber = row
            print(Int(scaleNumber))
        }
        scaleTextField.endEditing(true)
        keyTextField.endEditing(true)
    }
    
    func datasourceSelecter(){
        
    }
    
    
    //決定ボタンをタップした時の処理
    @IBAction func ChordListVCActionButton(_ sender: Any) {
        //スケール、Key選択どちらかが空白だったらダイアログを表示したい
        if scaleTextField.text == "" || keyTextField.text == ""{
            attentionDialog()
        }else{ //両方とも値が入っていたら次の画面へ遷移する
            
            let chordListVC = self.storyboard?.instantiateViewController(identifier: "ChordListVC") as! ChordListViewController
            
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
        }else{
            signatureState = 0
        }
    }
    
    func attentionDialog(){
        let alert:UIAlertController = UIAlertController(title: "値を入力してください", message: "スケールと選択を選択してください", preferredStyle: .alert)
        
        let alertOkButton:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{ (action:UIAlertAction!) -> Void in
            print("OKボタンをタップしました")
        })
        
        alert.addAction(alertOkButton)
        
        present(alert, animated: true,completion: nil)
    }
}
