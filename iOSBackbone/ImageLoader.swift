//
//  UIImageView+Utils.swift
//  iOSBackbone
//
//  Created by Giorgy Gunawan on 8/10/20.
//  Copyright © 2020 joji. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

public protocol ImageLoaderDelegate: class {
    func setImage(image: UIImage)
}

public class ImageLoader {
    weak var delegate: ImageLoaderDelegate?
    private var currentDataTask: URLSessionDataTask?
    
    func loadImage(from url: URL, urlSession: URLSession = URLSession.shared, failedHandler: (() -> Void)? = nil, completitionHandler: (() -> Void)? = nil) {
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            DispatchQueue.main.async() { [weak self] in
                self?.delegate?.setImage(image: imageFromCache)
                completitionHandler?()
            }
            return
        }
        currentDataTask = urlSession.dataTask(with: url) { data, response2, error in
            guard let response = response2 as? HTTPURLResponse, response.statusCode == 200,
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    failedHandler?()
                    return
                }
            DispatchQueue.main.async() { [weak self] in
                imageCache.setObject(image, forKey: url.absoluteString as AnyObject)
                self?.delegate?.setImage(image: image)
                completitionHandler?()
            }
        }
        currentDataTask?.resume()
    }
    
    func stopLoadImage() {
        currentDataTask?.suspend()
    }
}
