//
//  NewsViewController.swift
//  WPBrowser
//
//  Created by ymgn on 2018/11/15.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit
import SafariServices

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var dataList:[SampleModel] = [] // データモデルを格納する配列を追加
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Interface Builderのファイルを読み込む
        let nib = UINib(nibName: "NewsCell", bundle: nil)
        
        // UITaableViewに登録する。NewsCellを使用するという宣言。
        tableView.register(nib, forCellReuseIdentifier: "NewsCell")

        // 画面表示時に行う通信処理を追加
        reloadListDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onNotificationSettingButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "MoveNotificationSettingView", sender: nil)
    }
    // MARK: -
    func reloadListDatas() {
        // セッション用のコンフィグを設定・今回はデフォルト
        let config = URLSessionConfiguration.default
        
        // NSURLSessionのインスタンスを生成
        let session = URLSession(configuration: config)
        
        // 接続するURLを指定
        let url = URL(string: "https://liginc.co.jp/wp-json/wp/v2/posts/")
        
        // 通信処理タスクを設定
        let task = session.dataTask(with: url!) {(data, response, error) in
            // エラーが発生した場合にのみ処理
            if error != nil {
                // ここでエラーが発生したことをアラートで表示
                let controller : UIAlertController = UIAlertController(title: nil, message: "エラーが発生しました", preferredStyle: UIAlertController.Style.alert)
                controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(controller, animated: true, completion: nil)
                
                return;
            }
            
            // エラーがなければ、JSON形式にデータを変換して格納
            guard let jsonData: Data = data else {
                // ここでエラーが発生したことをアラートで表示
                let controller : UIAlertController = UIAlertController(title: nil, message: "エラーが発生しました", preferredStyle: UIAlertController.Style.alert)
                controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(controller, animated: true, completion: nil)
                
                // 表示後は終了
                return
            }
            
            self.dataList = try! JSONDecoder().decode([SampleModel].self, from: jsonData)
            
            // メインスレッドに処理を戻す
            DispatchQueue.main.async {
                // 最新のデータに更新する
                self.tableView.reloadData()
            }
        }
        // タスクを実施
        task.resume()
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        // セクションは一つ
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 取得したデータの数だけセルを表示
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 作成した「NewsCell」のインスタンスを作成
        let cell: NewsCell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        
        // 取得したデータを取り出す
        let data = dataList[indexPath.row]
        
        // 日付のデータと記事のタイトルを取得
        cell.dateLabel.text = data.dateString
        cell.titleLabel.text = data.title.rendered
        
        // セルのインスタンスを返す
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        // データを取り出す
        let data = dataList[indexPath.row]
        
        // 記事のURLを取得する
        if let url = URL(string: data.link) {
            // SFSafariViewControllerのインスタンスを作成
            let controller: SFSafariViewController = SFSafariViewController(url: url)
            
            // 次の画面へ遷移して、表示する
            self.present(controller, animated: true, completion: nil)
        }
    }

}
