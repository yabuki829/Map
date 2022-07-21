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
    
        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        print(documentsUrl)
        return documentsUrl.first!
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

    func directoryFor(stringUrl: String) -> URL {
        let fileURL = URL(string: stringUrl)!.lastPathComponent //9Fn2FupthW.mov
        //mainDirectoryUrlにfileURlを追加する
       
        let file = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(fileURL)
        print("fileurl1",fileURL)
        print("file2",file)
        return file
    }
    
    
}
