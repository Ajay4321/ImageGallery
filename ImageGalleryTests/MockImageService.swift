//
//  MockImageService.swift
//  ImageGalleryTests
//
//  Created by Ajay Awasthi on 30/09/24.
//

import XCTest
@testable import ImageGallery

class MockImageService: ImageServiceProtocol {
    var imagesToReturn: [ImageResponse] = []
    var shouldFail: Bool = false
    var errorToThrow: Error?
    
    func getAllImages(start: Int, limit: Int) async throws -> [ImageResponse] {
        if let error = errorToThrow {
                  throw error  // Throw the simulated error
              }
        return imagesToReturn
    }
}

