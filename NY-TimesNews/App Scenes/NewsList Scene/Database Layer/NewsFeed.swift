//
//  NewsFeed.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import Foundation
struct NewsFeed: Codable {
    let status: String?
    let copyright: String?
    let results: [NewsFeedData]?
}
struct NewsFeedData: Codable {
    let title: String
    let publishedDate: String
    let identifier: Int
    let abstract: String
    let media: [NewsFeedMedia]?
    var standradThumbnailURL: String? {
        let standradThumbnail = getMediaInfo(format: "Standard Thumbnail")
        guard standradThumbnail != nil else {
            return nil
        }
        return standradThumbnail!.url
    }
    var largeImageURL: String? {
        let largeImage = getMediaInfo(format: "mediumThreeByTwo440")
        guard getMediaInfo(format: "mediumThreeByTwo440") != nil else {
            return nil
        }
        return largeImage!.url
    }
    func getMediaInfo (format: String) -> NewsFeedMediaInfo? {
        guard media != nil, media!.count > 0 else {
            return nil
        }
        let firstMediaInfo = media![0]
        let metadata = firstMediaInfo.metadata
        guard firstMediaInfo.type == "image", metadata != nil, metadata!.count > 0 else {
            return nil
        }
        return metadata?.filter { $0.format == format}.first
    }
    private enum CodingKeys: String, CodingKey {
        case  title, publishedDate = "published_date", identifier = "id", abstract, media
    }
}
struct NewsFeedMedia: Codable {
    let type: String
    let metadata: [NewsFeedMediaInfo]?
    private enum CodingKeys: String, CodingKey {
        case  type, metadata = "media-metadata"
    }
}
struct NewsFeedMediaInfo: Codable {
    let url: String?
    let format: String?
    let height: Int?
    let width: Int?
}
