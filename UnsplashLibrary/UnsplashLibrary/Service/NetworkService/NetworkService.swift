//
//  NetworkService.swift
//  UnsplashLibrary
//
//  Created by Konstantin Dmitrievskiy on 19.03.2022.
//

import Foundation

class NetworkService {
    func searchPhoto(searchTerm: String, completion: @escaping (PhotoData?, Error?) -> Void) {
        let parameters = createParameters(searchTerm: searchTerm)
        let url = url(params: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = crerateHeader()

        fetchData(with: request, completion: completion)
    }

    private func crerateHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID xlK9mrm01y7wZLOmCjHD3t0NheLK2Vd6sOCiAMVigBM"
        return headers
    }

    private func createParameters(searchTerm: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["page"] = String(1)
        parameters["per_page"] = String(30)
        return parameters
    }

    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
    }

    private func fetchData<T: Codable>(with request: URLRequest, completion: @escaping (T?, Error?) -> Void) {
//        guard let url = URL(string: urlString) else {
//            print("Can't load url")
//            return
//        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let err = error {
                print("Failed fatch data \(err)")
            }

            guard let safeData = data else {
                return
            }

            do {
                let res = try JSONDecoder().decode(T.self, from: safeData)
                completion(res, nil)
            } catch {
                completion(nil, error)
            }
        }
        .resume()
    }
}
