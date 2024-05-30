//
//  CoinGeckoniaTests.swift
//  CoinGeckoniaTests
//
//  Created by Enchappolis on 5/24/24.
//

import XCTest
import Combine
@testable import CoinGeckonia

final class CoinGeckoniaTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    private var mockNetworkingManager: MockNetworkingManager!
    private var coinDataService: CoinDataService!
    private var homeViewModel: HomeViewModel!
    
    override func setUpWithError() throws {
        cancellables = Set<AnyCancellable>()
        mockNetworkingManager = MockNetworkingManager()
        coinDataService = CoinDataService(networkingManager: mockNetworkingManager)
        homeViewModel = HomeViewModel(coinDataService: coinDataService)
    }

    override func tearDownWithError() throws {
        cancellables = nil
        mockNetworkingManager = nil
        coinDataService = nil
        homeViewModel = nil
    }

    func test_homeViewModel_getData_APISucceesful() throws {

        let expectation = expectation(description: "fetching coins is successful")
        
        homeViewModel.getData()
        
        homeViewModel.$liveCoins
            .dropFirst()
            .combineLatest(homeViewModel.$errorFetchingCoins)
            .sink { completion in
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail()
                }
            } receiveValue: { (coins, error) in
                
                if coins.count == 1 && (error == nil) {
                    
                    XCTAssertEqual(coins[0].name, "Bitcoin")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_homeViewModel_getData_APIFails() throws {
        
        let expectation = expectation(description: "fetching coins returns NetworkingError.unknown")
        
        mockNetworkingManager.testforSuccessfulData = false
        homeViewModel.getData()
        
        homeViewModel.$liveCoins
            .dropFirst()
            .combineLatest(homeViewModel.$errorFetchingCoins)
            .sink { completion in
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail()
                }
            } receiveValue: { (coins, error) in
                
                if (error != nil) {
                    
                    XCTAssertEqual(error, .unknown)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
}
