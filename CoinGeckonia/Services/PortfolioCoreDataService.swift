//
//  PortfolioCoreDataService.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/22/24.
//

import Foundation
import CoreData

class PortfolioCoreDataService {

    private let container: NSPersistentContainer
    private let containerName = "PortfolioDataModel"
    private let entityName = "PortfolioEntity"
    
    @Published var portfolioEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { [weak self] _, error in
            
            guard self != nil else { return }
            
            if let error = error {
                print("Error loading Core Data. \(error)")
            }
        }
    }
    
    func getPortfolios() {
        self.get()
    }
    
    func addPortfolio(coin: Coin, amount: Double) {
        add(coin: coin, amount: amount)
    }
    
    func deletePortfolio(coin: Coin) {
        
        if let entity = portfolioEntities.first(where: { $0.coinId == coin.id }) {
            delete(entity: entity)
        }
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        
        if let entity = portfolioEntities.first(where: { $0.coinId == coin.id }) {
            update(entity: entity, amount: amount)
        }
    }
    
    private func get() {
        
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do {
            
            portfolioEntities = try container.viewContext.fetch(request)
            
        } catch {
            print("Error fetching Portfolio Entity. \(error)")
        }
    }
    
    private func add(coin: Coin, amount: Double) {
        
        let entity = PortfolioEntity(context: container.viewContext)
        
        entity.coinId = coin.id
        entity.amount = amount
        
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {

        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        
        do {
            
            try container.viewContext.save()
            
        } catch {
            
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        get()
    }
}
