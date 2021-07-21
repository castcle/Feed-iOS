//
//  ContentPayload.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 21/7/2564 BE.
//

import Core
import SwiftyJSON

// MARK: - ContentPayload
public enum ContentPayloadKey: String, Codable {
    case header
    case content
    case photo
    case link
    
    // Blog
    case contents
    case cover
    case url
}

public class ContentPayload: NSObject {
    let header: String
    let content: String
    let cover: String
    let photo: [Photo]
    let link: [Link]
    
    init(json: JSON) {
        self.header = json[ContentPayloadKey.header.rawValue].stringValue
        self.content = json[ContentPayloadKey.content.rawValue].stringValue
        
        // MARK: - Photo
        let photoJson = JSON(json[ContentPayloadKey.photo.rawValue].dictionaryValue)
        let photoPayloadJson = photoJson[ContentPayloadKey.contents.rawValue].arrayValue
        var photoArr: [Photo] = []
        photoPayloadJson.forEach { item in
            photoArr.append(Photo(json: item))
        }
        self.photo = photoArr
        
        // MARK: - Cover
        let photoCoverJson = JSON(photoJson[ContentPayloadKey.cover.rawValue].dictionaryValue)
        self.cover = photoCoverJson[ContentPayloadKey.url.rawValue].stringValue
        
        // MARK: - Link
        let linkJson = json[ContentPayloadKey.link.rawValue].arrayValue
        var linkArr: [Link] = []
        linkJson.forEach { item in
            linkArr.append(Link(json: item))
        }
        self.link = linkArr
    }
}
