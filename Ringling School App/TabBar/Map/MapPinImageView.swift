//
//  MapPinImageView.swift
//  Ringling School App
//
//  Created by JJ Fila on 6/1/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import UIKit

class MapPinImageView: UIImageView {
    var id : Int = -1
    
    init(frame: CGRect, id: Int) {
        self.id = id
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
