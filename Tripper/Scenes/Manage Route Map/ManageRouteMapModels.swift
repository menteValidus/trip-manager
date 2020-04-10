//
//  ManageRouteMapModels.swift
//  Tripper
//
//  Created by Denis Cherniy on 07.04.2020.
//  Copyright (c) 2020 Denis Cherniy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ManageRouteMap {
    
    struct ConcreteAnnotationInfo: AnnotationInfo {
        let id: String
        let latitude: Double
        let longitude: Double
    }
    
    // MARK: Use cases
    
    enum FetchNewAnnotationsInfo {
        struct Request {
        }
        struct Response {
            let annotationsInfo: [ConcreteAnnotationInfo]
        }
        struct ViewModel {
            let annotationsInfo: [ConcreteAnnotationInfo]
        }
    }
    
    enum CreateRoutePoint {
        struct Request {
            let latitude: Double
            let longitude: Double
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    enum SetRoutePoint {
        struct Request {
            let annotationsInfo: ConcreteAnnotationInfo
        }
        struct Response {
            let annotationInfo: ConcreteAnnotationInfo
        }
        struct ViewModel {
            let annotationInfo: ConcreteAnnotationInfo
        }
    }
    
    enum SelectAnnotation {
        struct Request {
            let identifier: String?
        }
        struct Response {
            let identifier: String?
        }
        struct ViewModel {
            let identifier: String?
        }
    }
    
    enum DeselectAnnotation {
        struct Request {
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    enum ShowDetail {
       struct Request {
       }
       struct Response {
       }
       struct ViewModel {
       }
   }
       
    
    enum EditRoutePoint {
        struct Request {
            let identifier: String?
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    enum DeleteRoutePoint {
        struct Request {
            let identifier: String?
        }
        struct Response {
            let identifier: String?
        }
        struct ViewModel {
            let identifier: String?
        }
    }
}
