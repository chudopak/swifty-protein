//
//  ImageDownloadingCacheConfigProvider.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class ImageCache {
    
    private let key = "ImageCache"
    private let refreshTokenKey = "refreshToken"
    private let filemanager = FileManager.default
    
    var imageCacheDir: URL {
        let documentDirectory = filemanager.urls(for: .documentDirectory,
                                                 in: .userDomainMask)[0].appendingPathComponent("imagesCache")
        if !filemanager.fileExists(atPath: documentDirectory.relativePath) {
            do {
                try filemanager.createDirectory(atPath: documentDirectory.relativePath,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                assertionFailure("Failed to create folder")
            }
        }
        return documentDirectory
    }
    
    func deleteCacheDirectory(url: URL) -> Bool {
        do {
            try filemanager.removeItem(at: url)
        } catch let error {
            print("Can not delete folder \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    func storeImage(imageId: String, image: UIImage) -> Bool {
        print("WE IN STORE IMAGE ID - \(imageId)")
        let url = imageCacheDir.appendingPathComponent(imageId)
        guard let data = image.jpegData(compressionQuality: 0.5)
        else {
            print("ImageCache, storeImage(imageId:image:) id(\(imageId))- Can't compress image to jpeg")
            return false
        }
        return filemanager.createFile(atPath: url.relativePath,
                                      contents: data,
                                      attributes: nil)
        //        else {
        //            return false
        //        }
        //        var dict = UserDefaults.standard.object(forKey: key) as? [String: String]
        //        if dict == nil {
        //            dict = [String: String]()
        //        }
        //        dict![imageId] = url.relativePath
        //        UserDefaults.standard.set(dict, forKey: key)
        //        return true
    }
    
    func getImageFromCache(id: String) -> UIImage? {
        //        if let dict = UserDefaults.standard.object(forKey: key) as? [String: String] {
        //            if let path = dict[id] {
        //                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
        //                    if let image = UIImage(data: data) {
        //                        return image
        //                    }
        //                }
        //            }
        //        }
        let url = imageCacheDir.appendingPathComponent(id)
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
}
