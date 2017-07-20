//
//  ExtensionForAlamofireImage.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/20/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

extension UIImageView {
    
    public func setImage(fromURL url:URL) {
        Alamofire.request(url).responseImage { response in
            debugPrint(response)
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                self.image = image
            }
        }
    }
}
