//
//  ImageDownloadingCacheConfigProvider.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

final class MoviesImageCache {
    
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
    
    func deleteCacheDirectory() -> Bool {
        return deleteItem(url: imageCacheDir)
    }
    
    func deletePoster(url: URL) -> Bool {
        return deleteItem(url: url)
    }
    
    func storeImage(imageId: String, image: UIImage) -> Bool {
        let url = imageCacheDir.appendingPathComponent(imageId)
        guard let data = image.jpegData(compressionQuality: 1)
        else {
            print("ImageCache, storeImage(imageId:image:) id(\(imageId))- Can't compress image to jpeg")
            return false
        }
        return filemanager.createFile(atPath: url.relativePath,
                                      contents: data,
                                      attributes: nil)
    }
    
    func getImageFromCache(id: String) -> UIImage? {
        let url = imageCacheDir.appendingPathComponent(id)
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
    
    private func deleteItem(url: URL) -> Bool {
        do {
            try filemanager.removeItem(at: url)
        } catch let error {
            print("Can not delete Item \(error.localizedDescription)")
            return false
        }
        return true
    }
}
