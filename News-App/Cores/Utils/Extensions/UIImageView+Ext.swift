//
//  UIImageView+Ext.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

import Foundation
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String?) {
        let urlFormatted = urlString?.replacingOccurrences(of: " ", with: "%20")
        var url: URL? = URL(string: urlFormatted ?? "")
        
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
        
        let modifier = AnyModifier { request in
            var customRequest = request
            
            guard let url = customRequest.url else {
                return request
            }
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                customRequest.setValue("mobile", forHTTPHeaderField: "issuer")
                customRequest.setValue("5", forHTTPHeaderField: "version-code")
                customRequest.setValue("1.0.0", forHTTPHeaderField: "version-name")
                customRequest.setValue("id", forHTTPHeaderField: "Accept-Language")
            }
            
            return customRequest
        }
        
        let options: KingfisherOptionsInfo = [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage,
            .requestModifier(modifier)
        ]
        
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
//            placeholder: UIImage.imgNoImage,
            options: options
        )
    }
}
