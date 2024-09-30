//
//  ImageResponse.swift
//  ImageGallery
//
//  Created by Ajay Awasthi on 29/09/24.
//

import Foundation


struct Images:Equatable,Decodable {
    let data: [ImageResponse]
}
// MARK: - ImageResponse
struct ImageResponse: Equatable,Decodable {
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    let albumId: Int

    static func == (lhs: ImageResponse, rhs: ImageResponse) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.url == rhs.url &&
               lhs.thumbnailUrl == rhs.thumbnailUrl &&
               lhs.albumId == rhs.albumId
    }
}
