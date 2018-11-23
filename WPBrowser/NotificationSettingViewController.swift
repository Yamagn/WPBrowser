//
//  NotificationSettingViewController.swift
//  WPBrowser
//
//  Created by ymgn on 2018/11/23.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationSettingViewController: UIViewController {
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notificationButton: UIButton!
    
    
    @IBAction func onNotificationSwitchValueChanged(_ sender: Any) {
    }
    
    @IBAction func onNotificationButtonTapped(_ sender: Any) {
        // 通知を管理するクラスのシングルトンを取得
        let center = UNUserNotificationCenter.current()
        
        // dataPickerで指定された時間を取得
        let date = datePicker.date
        
        // 通知を許可するリクエストを表示する（すでに許可するしないの画面が出ていれば表示されずに中の処理がすぐに処理される）
        center.requestAuthorization(options: [.alert, .sound], completionHandler: { granted, error in
            // エラーチェック
            if error != nil {
                let controller = UIAlertController(title: nil, message: "通知設定時にエラーが発生しました。", preferredStyle: UIAlertController.Style.alert)
                controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(controller, animated: true, completion: nil)
                return
            }
            
            // 許可する・しないの結果によって処理を変える
            if granted {
                // 予定されている全ての通知の設定を削除してから通知の設定を行う
                
                center.removeAllPendingNotificationRequests()
                
                // 通知の内容を設定 =====
                let content = UNMutableNotificationContent()
                // 通知のタイトル
                content.title = "最新の記事をチェックはしましたか？"
                
                // 通知のサブタイトル（iOS10から使用可能）
                content.subtitle = "今日はもう記事のチェックはしましたか？"
                
                // 通知の本文
                content.body = "最新のニュースがありますよ！"
                
                // 通知音の設定
                content.sound = UNNotificationSound.default
                // =====
                
                // カレンダーのインスタンスを生成
                let calendar = Calendar.current
                
                // 日付や時間を数値で取得できるDateComponentsを作成
                // 今回はdatePickerで設定した時間を基に時間、分のみを取得
                let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
                
                // どの時間で通知をするかを設定するか、繰り返し通知するかの設定
                // dateCompornentsで設定した時間で通知。今回は繰り返し通知を行うので、repeatsはtrue
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                // 通知の識別子を設定
                let identifier = "NewsNotification"
                
                // 通知の内容と時間を基にリクエストを作成
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                // 通知を設定する
                center.add(request, withCompletionHandler: nil)
                
                // 通知の設定が完了した旨の表示を行う
                let controller = UIAlertController(title: nil, message: "\(dateComponents.hour!)時\(dateComponents.minute!)分に通知する設定を行いました", preferredStyle: UIAlertController.Style.alert)
                controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(controller, animated: true)
            } else {
                // 通知が許可されていない場合はここでアラートを表示
                let controller = UIAlertController(title: nil, message: "通知の設定が許可されていません。設定アプリから通知の設定をご確認ください。", preferredStyle: UIAlertController.Style.alert)
                controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(controller, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func onCloseButtonTapped(_ sender: Any) {
        // 画面を閉じて、NewsViewControllerへ戻る処理
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
