//
//  MockImageLoader.swift
//  ImageGalleryTests
//
//  Created by Ajay Awasthi on 30/09/24.
//


import XCTest
@testable import ImageGallery

class MockImageLoader: ImageLoaderProtocol {
    var shouldLoadImageSuccessfully = true
    var loadImageHandler: ((URL, @escaping (UIImage?) -> Void) -> Void)?

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let loadImageHandler = loadImageHandler {
            loadImageHandler(url, completion)
        } else {
            // Default behavior
            if shouldLoadImageSuccessfully {
                let mockImage = UIImage() // Create a mock image
                completion(mockImage) // Call the completion with the mock image
            } else {
                completion(nil) // Simulate failure
            }
        }
    }
}
