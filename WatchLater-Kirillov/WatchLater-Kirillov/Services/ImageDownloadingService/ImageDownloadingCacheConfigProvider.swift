//
//  ImageDownloadingCacheConfigProvider.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import Kingfisher

enum ImageDownloadingCacheConfigProvider {
    
    static let cacheName = "imageCache"
    
    static var cacheConfig: ImageCache {
        if config == nil {
            config = configureConfig()
        }
        return config!
    }
    
    private static var config: ImageCache?
    
    private static func configureConfig() -> ImageCache {
        let cache = ImageCache(name: cacheName)
        cache.memoryStorage.config.totalCostLimit = 300 * 1_024 * 1_024
        cache.diskStorage.config.sizeLimit = 500 * 1_024 * 1_024
        cache.memoryStorage.config.expiration = .seconds(120)
        cache.diskStorage.config.expiration = .never
        return cache
    }
}
