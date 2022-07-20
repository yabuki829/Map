//
//  CashManager.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/07/12.
//

import Foundation

public enum ResultVideoCash<T> {
    case success(T)
    case failure(String)
}





class CacheManager {

    static let shared = CacheManager()

    private let fileManager = FileManager.default

    private lazy var mainDirectoryUrl: URL = {
        let documentsUrl = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()
    private let cashe = NSCache<AnyObject,NSData>()
   
    
    func getFileWith(stringUrl: String, completion: @escaping (ResultVideoCash<URL>) -> Void ) {
        let file = directoryFor(stringUrl: stringUrl)
        //ファイルが存在していたらそのファイルを返す
        guard !fileManager.fileExists(atPath: file.path)  else {
            print("キャッシュがあります")
                completion(ResultVideoCash.success(file))
                return
        }
         print("キャッシュがない")
        DispatchQueue.global().async {
            
            if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
                videoData.write(to: file, atomically: true)
                completion(ResultVideoCash.success(file))

            } else {
                completion(ResultVideoCash.failure("ダウンロードをできませんでした"))

            }
        }
        
        
        
    }

    private func directoryFor(stringUrl: String) -> URL {
        //URLの最後の項目名を取得
       
        let fileURL = URL(string: stringUrl)!.lastPathComponent
        //mainDirectoryUrlにfileURlを追加する
        let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)
        return file
    }
    
    
}


public enum ResultCash<T> {
    case success(T)
    case failure(String)
}

extension CacheManager {
    private func convertVideoData(urlString:String) -> Data {
        if let url = URL(string: urlString) {
            do {
                print("videoをデータ型に変更しました")
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                return data
            } catch {
                print(error)
            }
        }
        return Data()
    }
    func saveCashe(urlString:String){
        let fileURL = "video/" + URL(string: urlString)!.lastPathComponent
        let data = convertVideoData(urlString: urlString)
        //urlの作成
        guard let url = try? FileManager.default.url(for: .documentDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil, create: true).appendingPathComponent(fileURL) else { return }
        //保存する
        do {
            print("キャッシュを保存しました")
            try data.write(to: url)
        } catch let error {
            print(error)
        }
        
    }
    func readCashe(urlString:String,completion: @escaping (ResultCash<URL>) -> Void) {
        //casheがあればデータをすぐに返す
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("video" + urlString){
            print("キャッシュがありました!!!!")
            print(url)
            completion(ResultCash.success(url))
          
        }
        else {
            saveCashe(urlString: urlString)
            readCashe(urlString: urlString) { result in
                switch result {
                    case .success(let url):
                        completion(ResultCash.success(url))
                    case .failure(let error):
                        print("エラー")
                        completion(ResultCash.failure("読み込みに失敗しました"))
                }
            }
        }
        
        
        //なければ casheを保存する
      
    }
}
