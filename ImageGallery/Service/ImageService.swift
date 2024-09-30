//
//  ImageService.swift
//  ImageGallery
//
//  Created by Ajay Awasthi on 29/09/24.
//

import Foundation

protocol ImageServiceProtocol {
    func getAllImages(start: Int, limit: Int) async throws -> [ImageResponse]
}

final class ImageService: ImageServiceProtocol {
    
    static let baseUrl = "https://jsonplaceholder.typicode.com"

    private enum EndPoint{
        case ImageList(start: Int, limit: Int)
        
        var path: String{
            switch self {
            case .ImageList(let start, let limit):
                return "/photos?_page=\(start)&_limit=\(limit)"
            }
        }
        
        var url: String {
            switch self {
            case .ImageList: return "\(baseUrl)\(path)"
            }
        }
    }
    
    func getAllImages(start: Int, limit: Int) async throws -> [ImageResponse] {
        guard Reachability.isConnectedToNetwork(),
              let url = URL(string: EndPoint.ImageList(start: start, limit: limit).url) else {
                  throw CustomError.noConnection
              }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            do {
                let imageList = try JSONDecoder().decode([ImageResponse].self, from: data)
                return imageList
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
}
