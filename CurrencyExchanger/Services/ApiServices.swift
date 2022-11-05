//
//  ApiServices.swift
//  CurrencyExchanger
//
//  Created by Heorhi on 2022-11-05.
//

import Foundation

struct ApiServices {
    
 //   @Binding var aa: String
    
    enum CharacterServiceError: Error {
        case failed
        case failedToDecode
        case invalidStatusCode
        
    }
    


    
    let apiType = ApiType.getLatest(value: AllCurrencies.allCases)
    

    
    // MARK: Fetch data
    func fetchData(urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard
          let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200
        else {
            print("ssss")
            DownloadError.statusNotOk(urlRequest)
           
            return data
        //    throw DownloadError.statusNotOk(urlRequest)
        }
        return data
    }
    
    // MARK: Decode data
    func decodData<ModelType : Codable>(data: Data, modelType: ModelType.Type)async throws -> ModelType {
        
        guard let decodedResponse = try? JSONDecoder().decode(modelType.self, from: data)
        else {
            throw DownloadError.decoderError
        }
          let madeTypeObject = decodedResponse
          
        return madeTypeObject
    }
    
    
    // MARK: Create a group of requests, get data from it, and decode the data

    func getPostsFromGroup<ModelType : Codable> (URLRequestArray: [URLRequest], modelType: ModelType.Type) async throws -> [Codable]{
        
      // 1 Create a group of requests
        return try await withThrowingTaskGroup(
            of: Data.self,
          returning: [Codable].self
        ) { group in
          // 2 parse array of  URLRequestes
            for URLRequest in URLRequestArray  {
            // 3 add tasks in group
            group.addTask {
              // 4 submit requests for data
                return  try await  self.fetchData(urlRequest: URLRequest)
            }
          }
          // 5 decode the data
            return try await group.reduce(into: [Codable]()) { result, data in
                let post =  try  await self.decodData(data: data, modelType: modelType.self)
             
              result.append(post)
           
          }
        }
        
    }
    
    func getPosts() async throws-> [Codable] {
        do {
    let groupPosts  =   try await  getPostsFromGroup(URLRequestArray: apiType.requestesArray, modelType: CurrencyDataModel.self)
        //    print(groupPosts)
            return groupPosts
    
        } catch {
            print("ERROR")
            return [Codable]()
           
            
        }
    }
    
    
    
    func aaaa() {
        
     let a = apiType.requestesArray
        
        for i in a {
            
            print(i.url)
            
        }
                
        
        
    }
    
    
    
    
    
    
    /*
    func fetchCharacters() async throws -> [Character]{
        
        let url = URL(string:"https://rickandmortyapi.com/api/character")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
                  throw CharacterServiceError.invalidStatusCode
              }
        
        
        let decodedData = try JSONDecoder().decode(CharacterServiceResult.self, from: data)
        return decodedData.results
    }
    */
}


enum DownloadError: Error {
    case statusNotOk(URLRequest)
    
    case decoderError
  case invalidURL
    
    var errors: String {
        
        switch self {
        case .statusNotOk(let uRLRequest):
            print("1\(uRLRequest)")
        case .decoderError:
            print("2")
        case .invalidURL:
            print("3")
        }
        
        return ""
    }
    
}
