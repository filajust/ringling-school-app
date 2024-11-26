//
//  MapPinContainer.swift
//  Ringling School App
//
//  Created by JJ Fila on 5/31/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import Foundation
import UIKit
import GDataXML_HTML

struct MapPinContainer {
    var mapPins = [Int : MapPin]()
    static let xmlElementText = "MapContainer"
    
    func asXML() -> Data? {
        let mapContainerElement = GDataXMLNode.element(withName: MapPinContainer.xmlElementText)
        
        for (id, mapPin) in mapPins {
            let mapPinElement = GDataXMLNode.element(withName: MapPin.xmlElementText)
            
            let pinIdElement = GDataXMLNode.element(withName: MapPin.idXmlElementText, stringValue: String(id))
            let pinNameElement = GDataXMLNode.element(withName: MapPin.nameXmlElementText, stringValue: mapPin.name)
            let pinDescriptionElement = GDataXMLNode.element(withName: MapPin.descriptionXmlElementText, stringValue: mapPin.description)
            let pinImgurAlbumIdElement = GDataXMLNode.element(withName: MapPin.imgurAlbumIdXmlElementText, stringValue: mapPin.imgurAlbumId)
            let pinLocationElement = GDataXMLNode.element(withName: MapPin.locationXmlElementText, stringValue: NSStringFromCGPoint(mapPin.location))
            
            mapPinElement?.addChild(pinIdElement)
            mapPinElement?.addChild(pinNameElement)
            mapPinElement?.addChild(pinDescriptionElement)
            mapPinElement?.addChild(pinImgurAlbumIdElement)
            mapPinElement?.addChild(pinLocationElement)
            
            mapContainerElement?.addChild(mapPinElement)
        }
        
        let xmlDocument = GDataXMLDocument(rootElement: mapContainerElement)
        
        return xmlDocument?.xmlData()
    }
    
    static func importXml(fileUrl: URL) -> MapPinContainer? {
        var mapPinContainer : MapPinContainer? = nil
        var tempMapPinContainer = MapPinContainer()
        
        guard let data = try? Data(contentsOf: fileUrl) else {
            return mapPinContainer
        }
        
        guard let xmlDocument = try? GDataXMLDocument(data: data) else {
            return mapPinContainer
        }
        
        guard let mapPinArray = xmlDocument.rootElement().elements(forName: MapPin.xmlElementText) else {
            return mapPinContainer
        }
        
        for case let mapPinElement as GDataXMLElement in mapPinArray {
            let idArray = mapPinElement.elements(forName: MapPin.idXmlElementText)
            let locationArray = mapPinElement.elements(forName: MapPin.locationXmlElementText)
            let imgurAlbumIdArray = mapPinElement.elements(forName: MapPin.imgurAlbumIdXmlElementText)
            let descriptionArray = mapPinElement.elements(forName: MapPin.descriptionXmlElementText)
            let nameArray = mapPinElement.elements(forName: MapPin.nameXmlElementText)
            
            if let nameElement = nameArray?.first as? GDataXMLElement {
                if let descriptionElement = descriptionArray?.first as? GDataXMLElement {
                    if let imgurAlbumIdElement = imgurAlbumIdArray?.first as? GDataXMLElement {
                        if let locationElement = locationArray?.first as? GDataXMLElement {
                            if let idElement = idArray?.first as? GDataXMLElement {
                                if let id = Int(idElement.stringValue()) {
                                    let location = CGPointFromString(locationElement.stringValue())
                                    let mapPin = MapPin(name: nameElement.stringValue(), description: descriptionElement.stringValue(), imgurAlbumId: imgurAlbumIdElement.stringValue(), location: location, id: Int(idElement.stringValue())!)
                                    tempMapPinContainer.mapPins[id] = mapPin
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        
        if tempMapPinContainer.mapPins.count > 0 {
            mapPinContainer = tempMapPinContainer
        }
        return mapPinContainer
    }
}
