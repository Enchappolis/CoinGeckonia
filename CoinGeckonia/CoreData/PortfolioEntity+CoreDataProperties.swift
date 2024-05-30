//
//  PortfolioEntity+CoreDataProperties.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 5/17/24.
//
//

import Foundation
import CoreData


extension PortfolioEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PortfolioEntity> {
        return NSFetchRequest<PortfolioEntity>(entityName: "PortfolioEntity")
    }

    @NSManaged public var amount: Double
    @NSManaged public var coinId: String?

}

extension PortfolioEntity : Identifiable {

}
