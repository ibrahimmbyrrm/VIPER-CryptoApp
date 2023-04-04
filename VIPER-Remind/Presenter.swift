//
//  Presenter.swift
//  VIPER-Remind
//
//  Created by İbrahim Bayram on 4.04.2023.
//

import Foundation

// Class , Protocol
// Talks to -> Interactor, View, Router

protocol AnyPresenter {
    var router : AnyRouter? {get set}
    var interactor : AnyInteractor? {get set}
    var view : AnyView? {get set}
    
    func interactorDidDownloadCrypto(result : Result<[Crypto], NetworkError>)
}

class CryptoPresenter : AnyPresenter {
    var router: AnyRouter?
    //If initialization of interactor succesfull, interactor starts to downloaad datas from API.
    var interactor: AnyInteractor? {
        didSet {
            interactor?.downloadCryptos()
        }
    }
    var view: AnyView?
    //When API Request done, the result of request is sent to view.update function as a parameter
    func interactorDidDownloadCrypto(result: Result<[Crypto], NetworkError>) {
        switch result {
        case .success(let items):
            view?.update(with: items)
            print("success")
        case .failure(let error):
            view?.update(with: error.rawValue)
        }
    }
    
}
