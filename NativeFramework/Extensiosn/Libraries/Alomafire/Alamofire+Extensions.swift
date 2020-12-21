//
//  Alamofire+Extensions.swift
//  NativeFramework
//
//  Created by Artem Syritsa on 09.06.2020.
//  Copyright © 2020 Artem Syritsa. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest {
    
    func customValidate() -> Self {
        return self.validate { request, response, data -> Request.ValidationResult in
            
            print("🛰 Request url type \(request?.method?.rawValue ?? "nil"): \(request?.url?.absoluteString ?? "nil")")
            print("🛰 Request header: \(request?.allHTTPHeaderFields ?? ["keyNil": "valueNil"])")
            print("🛰 Request body: \( (request?.httpBody != nil) ? NSString(data:(request?.httpBody)!, encoding:String.Encoding.utf8.rawValue) ?? "nil" : "nil")")
            print("🛰 Response: \(NSString(data:data ?? Data(), encoding:String.Encoding.utf8.rawValue) ?? "bodyResponseNil")")
            
            guard let `data` = data else { return .failure(BaseResponse()) }
            
            guard let apiResponse: BaseResponse = try? JSONDecoder().decode(BaseResponse.self, from: data) else {
                DispatchQueue.main.async {
                    Material.showMaterialAlert(title: self.apiErrorMessage(response.statusCode), message: "message")
                }
                return .failure(BaseResponse())
            }
            
            let apiStatusCode: Int = apiResponse.statusCode ?? response.statusCode
            
            if (200...399) ~= response.statusCode && (200...399) ~= apiStatusCode {
                return .success(())
            }
            
            if apiResponse.code == BaseResponse.refreshTokenErrorCode {
                AppConfig.shared.signOut()
            }
            
            let message = "\(apiResponse.message ?? "No error description") | \(apiResponse.statusCode ?? response.statusCode)"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                Material.showMaterialAlert(title: self.apiErrorMessage(apiResponse.statusCode ?? 404), message: message)
            })
            
            return .failure(apiResponse)
        }
    }
    
    func apiErrorMessage(_ code: Int) -> String {
        let message = "api_response.error".localized()
        switch code {
        default:
            return "\(message) \("api_response.\(code)".localized())"
        }
    }

}

extension AFDataResponse {
    
    func convertToClass<T>(_ classType: T.Type) -> T? where T: Codable {
        if let data = self.data {
            return try? JSONDecoder().decode(T.self, from: data)
        } else {
            return nil
        }
    }
    
}
