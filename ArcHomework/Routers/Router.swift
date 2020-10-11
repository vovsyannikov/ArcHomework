//
//  Router.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import Foundation
import UIKit

protocol RouterInput {
    var output: RouterOutput! { get set }
    
    func present(_ vc: UIViewController)
}

protocol RouterOutput {
    func created(_ todo: ToDo)
}

class Router: RouterInput{
    var output: RouterOutput!
    
    func present(_ vc: UIViewController) {
        
    }
    
    
}
