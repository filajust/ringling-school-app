//
//  MapPin.swift
//  MapPinConfigurer
//
//  Created by JJ Fila on 5/31/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import Foundation
import UIKit

struct MapPin {
    var id : Int!
    var name : String!
    var description : String!
    var imgurAlbumId : String!
    var location : CGPoint!
    
    static let xmlElementText = "MapPin"
    static let idXmlElementText = "PinId"
    static let nameXmlElementText = "PinName"
    static let descriptionXmlElementText = "PinDescription"
    static let imgurAlbumIdXmlElementText = "PinImgurAlbumId"
    static let locationXmlElementText = "PinLocation"
    
    init(name: String, description: String, imgurAlbumId: String, location: CGPoint, id: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.imgurAlbumId = imgurAlbumId
        self.location = location        
    }
}
