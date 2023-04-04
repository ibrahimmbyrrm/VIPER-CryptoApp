//
//  Router.swift
//  VIPER-Remind
//
//  Created by İbrahim Bayram on 4.04.2023.
//

import Foundation
import UIKit

// Class, Protocol
// Entry Point

typealias EntryPoint = AnyView & UIViewController

protocol AnyRouter {
    var entry : EntryPoint? {get}
    static func startExecution() -> AnyRouter
}

class CryptoRouter : AnyRouter {
    var entry: EntryPoint?
    
    static func startExecution() -> AnyRouter {
        let router = CryptoRouter()
       
        var view : AnyView = CryptoViewController()
        var presenter : AnyPresenter = CryptoPresenter()
        var interactor : AnyInteractor = CryptoInteractor()
        //Delegations
        view.presenter = presenter
       
        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router
        
        interactor.presenter = presenter
        //Entry Point Definition
        router.entry = view as? EntryPoint
        
        return router
    }
    
}
