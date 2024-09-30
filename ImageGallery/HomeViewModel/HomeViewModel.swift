//
//  HomeViewModel.swift
//  ImageGallery
//
//  Created by Ajay Awasthi on 29/09/24.
//

import Foundation

final class HomeViewModel {
    private var imageList: [ImageResponse] = []
    private let imageService: ImageServiceProtocol
    var start = 0
    let limit = 30
    var isLoading = false
    var hasMoreData = true
    
    init(imageService: ImageServiceProtocol = ImageService()) {
        self.imageService = imageService
    }
    
    func loadData(completion: @escaping (Result<[ImageResponse], Error>) -> Void) {
        Task {
            do {
                let images = try await imageService.getAllImages(start: start, limit: limit)
                if images.isEmpty {
                    hasMoreData = false
                } else {
                    self.imageList.append(contentsOf: images)
                    start += 30
                    isLoading = false
                    DispatchQueue.main.async {
                        completion(.success(images))
                    }
                }
                
            } catch {
                isLoading = false
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getImageCount() -> Int {
        return imageList.count
    }
    
    func getImage(at index: Int) -> ImageResponse {
        return imageList[index]
    }
    
    func getImages() -> [ImageResponse] {
        return imageList
    }
}
