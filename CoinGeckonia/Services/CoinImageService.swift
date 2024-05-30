//
//  CoinImageService.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/10/24.
//

import Foundation
import UIKit
import Combine

class CoinImageService {
    
    @Published var image: UIImage?
    
    private var imageSubscription: AnyCancellable?
    private let localFileManger = LocalFileManager.shared
    private let coin: Coin
    private let folderName = "coin_image"
    private let imageName: String
    
    private var networkingManager: NetworkingServiceProvider
    
    init(coin: Coin,
         networkingManager: NetworkingServiceProvider = NetworkingManager.shared) {
        
        self.networkingManager = networkingManager
        self.coin = coin
        self.imageName = coin.id
        self.getCoinImage()
    }
    
    private func getCoinImage() {
        
        if let image = localFileManger.getImage(imageName: imageName, folderName: folderName) {
            self.image = image
        } else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage() {
        
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = networkingManager.download(url: url)
            .map({ data -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkingManager.handleCompletion, receiveValue: { [weak self] image in
                
                guard let self = self, let image = image else { return }
                
                self.image = image
                
                self.imageSubscription?.cancel()
                
                self.localFileManger.saveImage(image: image, imageName: self.imageName, folderName: folderName)
            })
    }
}
