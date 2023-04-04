//
//  Interactor.swift
//  VIPER-Remind
//
//  Created by İbrahim Bayram on 4.04.2023.
//

import Foundation

enum NetworkError : String, Error {
    case NetworkFailed = "Network Failed"
    case ParsingFailed = "Parsing Failed"
}

// URL -> https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json
// Talks to -> Presenter
// Class, Protocol

protocol AnyInteractor {
    var presenter : AnyPresenter? {get set}
    
    func downloadCryptos()
}

class CryptoInteractor : AnyInteractor {
    var presenter: AnyPresenter?
    //API Request and transfer the result of request to presenter.
    func downloadCryptos() {
        guard let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json") else {return}
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                self?.presenter?.interactorDidDownloadCrypto(result: .failure(NetworkError.NetworkFailed))
                return}
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                self?.presenter?.interactorDidDownloadCrypto(result: .success(cryptos))
            }catch {
                self?.presenter?.interactorDidDownloadCrypto(result: .failure(NetworkError.ParsingFailed))
            }
        }
        task.resume()
    }
    
    
}
