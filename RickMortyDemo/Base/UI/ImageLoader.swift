//
//  ImageLoader.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 20/10/24.
//

import Foundation
import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func loadImage(from url: URL, placeholder: UIImage? = nil, completion: @escaping (UIImage?) -> Void) {
        completion(placeholder)
        
        let key = NSString(string: url.absoluteString)
        
        if let cachedImage = cache.object(forKey: key) {
            return completion(cachedImage)
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                self?.cache.setObject(image, forKey: key)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(placeholder)
                }
            }
        }
        task.resume()
    }
}
