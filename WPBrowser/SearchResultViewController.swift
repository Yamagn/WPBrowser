//
//  SeachResultViewController.swift
//  WPBrowser
//
//  Created by ymgn on 2018/11/17.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit
import SafariServices

class SearchResultViewController: UITableViewController, UISearchResultsUpdating {
    
    // 取得したデータを保持する配列を追加
    var dataList:[SampleModel] = []
    
    // MARK: - UISearchResultUpdating
    // UISearchBarの文字列に何かしら変化があったら呼ばれる
    func updateSearchResults(for searchController: UISearchController) {
        // UISearchControllerの検索窓に入力した文字列を取得
        if let text = searchController.searchBar.text {
            // データ取得関数を呼び出す
            self.reloadListDatas(text)
        }
    }
    
    func reloadListDatas(_ text: String) {
        // 文字列が空のときは処理を行わない
        if text.isEmpty {
            return
        }
        
        // セッション用のコンフィグを設定・今回はデフォルトの設定
        let config = URLSessionConfiguration.default
        
        // NSURLSessionのインスタンスを生成
        let session = URLSession(configuration: config)
        
        // 検索する文字列が日本語の場合もあるため、エンコードする
        let urlString = "https://liginc.co.jp/wp-json/wp/v2/posts/" + "?search=" + "text"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        
        // 通信処理タスクを設定
        let task = session.dataTask(with: url) {(data, response, error) in
            
            // エラーが発生したらアラートを表示して終了
            if error != nil {
                let controller: UIAlertController = UIAlertController(title: nil, message: "エラーが発生しました。", preferredStyle: UIAlertController.Style.alert)
                controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(controller, animated: true, completion: nil)
                return
            }
            
            // JSON形式にデータを変換
            guard let jsonData: Data = data else {
                let controller: UIAlertController = UIAlertController(title: nil, message: "エラーが発生しました。", preferredStyle: UIAlertController.Style.alert)
                controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(controller, animated: true, completion: nil)
                return
            }
            
            self.dataList = try! JSONDecoder().decode([SampleModel].self, from: jsonData)
            
            DispatchQueue.main.async {
                // 検索結果が0件だった場合はアラートを出す
                if self.dataList.isEmpty {
                    let controller : UIAlertController = UIAlertController(title: nil, message: "検索結果がありませんでした", preferredStyle: UIAlertController.Style.alert)
                    controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(controller, animated: true, completion: nil)
                    return
                }
                
                // 最新のデータに更新する
                self.tableView.reloadData()
            }
        }
        
        // タスクを実行
        task.resume()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // カスタムセルNewsCellを使用するため、UITableViewに登録
        let nib = UINib(nibName: "NewsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell

        // データを取り出し、日付とタイトルを入れる
        let data = dataList[indexPath.row]
        cell.dateLabel.text = data.dateString
        cell.titleLabel.text = data.title.rendered

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択したセルを非選択に戻す
        tableView.deselectRow(at: indexPath, animated: true)
        
        // データを取り出し、SFSafariViewControllerで表示させる
        let data = dataList[indexPath.row]
        if let url = URL(string: data.link) {
            let controller: SFSafariViewController = SFSafariViewController(url: url)
            self.present(controller, animated: true, completion: nil)
        }
    }

}
