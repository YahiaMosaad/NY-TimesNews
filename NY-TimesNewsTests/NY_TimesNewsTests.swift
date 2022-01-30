//
//  NY_TimesNewsTests.swift
//  NY-TimesNewsTests
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import XCTest
import Combine

@testable import NY_TimesNews

class NY_TimesNewsTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        _ = cancellables.map{$0.cancel()}
    }

    func testGetRemoteRepositoryNewsListUseCase(){//from remote database with mocked store id and category id and user
        let expectation = self.expectation(description: "Get news querey is successfull")
        let remoteRepo = NewsListRepositoryImp(network: HTTPClient.defaultClient)  //to execute remote request to db
        
        let mockedUseCase: GetNewsUseCase = .instance(input: .init(newsListRepository: remoteRepo))
        
    
        mockedUseCase.execute(.week)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(_) = completion {
                }
            } receiveValue: { newsFeed in
                if let news = newsFeed, news.results?.count ?? 0 > 0 {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetRemoteRepositoryNewsListUseCase_noInternetConnection(){//from remote database with mocked apiKey and period
        let expectation = self.expectation(description: "Get news querey is successfull")
        let remoteRepo = MockedNoInternetRemoteRepository()//to execute remote request to db
        
        let mockedUseCase: GetNewsUseCase = .instance(input: .init(newsListRepository: remoteRepo))
        mockedUseCase.execute(.week)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    switch error{
                    case .noInternetConnection:
                        expectation.fulfill()
                    case .invalidAPIKey, .noDataFound:
                        break
                    }
                }
            } receiveValue: { newsFeed in
                if let news = newsFeed, news.results?.count ?? 0 > 0 {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetRemoteRepositoryNewsListUseCase_noDataFound(){//from remote database with mocked apiKey and period
        let expectation = self.expectation(description: "Get news querey is successfull")
        let remoteRepo = MockedNoDataFromRemoteRepository()//to execute remote request to db
        
        let mockedUseCase: GetNewsUseCase = .instance(input: .init(newsListRepository: remoteRepo))
        mockedUseCase.execute(.week)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    switch error{
                    case .noDataFound:
                        expectation.fulfill()
                    case .noInternetConnection, .invalidAPIKey:
                        break
                    }
                }
            } receiveValue: { newsFeed in
                if let news = newsFeed, news.results?.count ?? 0 > 0 {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetRemoteRepositoryNewsListUseCase_invalidAPIKey(){//from remote database with mocked apiKey and period
        let expectation = self.expectation(description: "Get news querey is successfull")
        let remoteRepo = MockedInvalidAPIKeyRemoteRepository()//to execute remote request to db
        
        let mockedUseCase: GetNewsUseCase = .instance(input: .init(newsListRepository: remoteRepo))
        mockedUseCase.execute(.week)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    switch error{
                    case .invalidAPIKey:
                        expectation.fulfill()
                    case .noInternetConnection, .noDataFound:
                        break
                    }
                }
            } receiveValue: { newsFeed in
                if let news = newsFeed, news.results?.count ?? 0 > 0 {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        waitForExpectations(timeout: 5, handler: nil)
    }

    struct MockedNoInternetRemoteRepository: NewsListRepository{
        func getNewsList(getNewsListQuery: GetNewsListQuery) -> UseCaseResult<NewsFeed?, GetNewsUseCase.GetNewsUseCaseError> {
            return Fail(error: .noInternetConnection).eraseToAnyPublisher()

        }

    }
    
    struct MockedNoDataFromRemoteRepository: NewsListRepository{
        func getNewsList(getNewsListQuery: GetNewsListQuery) -> UseCaseResult<NewsFeed?, GetNewsUseCase.GetNewsUseCaseError> {
            return Fail(error: .noDataFound).eraseToAnyPublisher()

        }
    }
    
    struct MockedInvalidAPIKeyRemoteRepository: NewsListRepository{
        func getNewsList(getNewsListQuery: GetNewsListQuery) -> UseCaseResult<NewsFeed?, GetNewsUseCase.GetNewsUseCaseError> {
            return Fail(error: .invalidAPIKey).eraseToAnyPublisher()
        }
    }
    
}
