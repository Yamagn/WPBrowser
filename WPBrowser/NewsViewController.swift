//
//  NewsViewController.swift
//  WPBrowser
//
//  Created by ymgn on 2018/11/15.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Interface Builderのファイルを読み込む
        let nib = UINib(nibName: "NewsCell", bundle: nil)
        
        // UITaableViewに登録する。NewsCellを使用するという宣言。
        tableView.register(nib, forCellReuseIdentifier: "NewsCell")

        // Do any additional setup after loading the view.
    }
    
    func reloadListDatas() {
        // セッション用のコンフィグを設定・今回はデフォルト
        let config = URLSessionConfiguration.default
        
        // NSURLSessionのインスタンスを生成
        let session = URLSession(configuration: config)
        
        // 接続するURLを指定（今回はWordPressデモサイトへ接続）
        let url = URL(string: "https://demo.wp-api.org/wp-json/wp/v2/posts/")
        
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
        }
        
        // タスクを実施
        task.resume()
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
