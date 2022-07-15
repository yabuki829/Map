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
        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()

    
    
    func getFileWith(stringUrl: String, completion: @escaping (ResultVideoCash<URL>) -> Void ) {
        let file = directoryFor(stringUrl: stringUrl)

        //return file path if already exists in cache directory
        //ファイルが存在していたらそのファイルを返す
        guard !fileManager.fileExists(atPath: file.path)  else {
            completion(ResultVideoCash.success(file))
            return
        }

        DispatchQueue.global().async {
            if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
                videoData.write(to: file, atomically: true)

                DispatchQueue.main.async {
                    completion(ResultVideoCash.success(file))
                }
            } else {
                DispatchQueue.main.async {
                    completion(ResultVideoCash.failure("ダウンロードをできませんでした"))
                }
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
