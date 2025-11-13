//
//  LiveJournalService.swift
//  TripJournal
//
//  Created by Raneem Alomair on 13/11/2025.
//

import Combine
import Foundation

/// Live implementation of the JournalService that talks to the local API.
final class LiveJournalService: JournalService {

    // MARK: - Types

    private enum HTTPMethod: String {
        case get     = "GET"
        case post    = "POST"
        case put     = "PUT"
        case delete  = "DELETE"
    }

    private enum APIError: LocalizedError {
        case invalidURL
        case invalidResponse
        case httpStatus(Int)
        case unauthorized
        case decodingError(DecodingError)
        case underlying(Error)

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL."
            case .invalidResponse:
                return "Invalid server response."
            case let .httpStatus(code):
                return "Server returned status code \(code)."
            case .unauthorized:
                return "Unauthorized. Please log in again."
            case .decodingError:
                return "Failed to decode server response."
            case let .underlying(error):
                return error.localizedDescription
            }
        }
    }

    // MARK: - Stored properties

    /// Base URL from README: http://localhost:8000
    private let baseURL: URL
    private let urlSession: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    @Published private var token: Token?

    // MARK: - Init

    init(
        baseURL: URL = URL(string: "http://localhost:8000")!,
        urlSession: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        self.encoder = encoder
    }

    // MARK: - JournalService

    var isAuthenticated: AnyPublisher<Bool, Never> {
        $token
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }

    // MARK: - Auth

    @discardableResult
    func register(username: String, password: String) async throws -> Token {
        struct RegisterBody: Encodable {
            let username: String
            let password: String
        }

        let body = RegisterBody(username: username, password: password)

        // README: POST /register (JSON)
        let request = try makeRequest(
            path: "/register",
            method: .post,
            authorized: false,
            body: body
        )

        let token: Token = try await send(request)
        self.token = token
        return token
    }

    @discardableResult
    func logIn(username: String, password: String) async throws -> Token {
        // README: POST /token (x-www-form-urlencoded)
        guard let url = URL(string: "/token", relativeTo: baseURL) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyString = "grant_type=&username=\(percentEscape(username))&password=\(percentEscape(password))"
        request.httpBody = bodyString.data(using: .utf8)

        let token: Token = try await send(request)
        self.token = token
        return token
    }

    func logOut() {
        token = nil
    }

    // MARK: - Trips

    @discardableResult
    func createTrip(with request: TripCreate) async throws -> Trip {
        // README: POST /trips
        let urlRequest = try makeRequest(
            path: "/trips",
            method: .post,
            body: request
        )
        return try await send(urlRequest)
    }

    @discardableResult
    func getTrips() async throws -> [Trip] {
        // README: GET /trips
        let urlRequest = try makeRequest(
            path: "/trips",
            method: .get
        )
        return try await send(urlRequest)
    }

    @discardableResult
    func getTrip(withId tripId: Trip.ID) async throws -> Trip {
        // README: GET /trips/{tripId}
        let urlRequest = try makeRequest(
            path: "/trips/\(tripId)",
            method: .get
        )
        return try await send(urlRequest)
    }

    @discardableResult
    func updateTrip(withId tripId: Trip.ID, and request: TripUpdate) async throws -> Trip {
        // README: PUT /trips/{tripId}
        let urlRequest = try makeRequest(
            path: "/trips/\(tripId)",
            method: .put,
            body: request
        )
        return try await send(urlRequest)
    }

    func deleteTrip(withId tripId: Trip.ID) async throws {
        // README: DELETE /trips/{tripId}
        let urlRequest = try makeRequest(
            path: "/trips/\(tripId)",
            method: .delete
        )
        try await sendWithoutBody(urlRequest)
    }

    // MARK: - Events

    @discardableResult
    func createEvent(with request: EventCreate) async throws -> Event {
        // README: POST /events
        let urlRequest = try makeRequest(
            path: "/events",
            method: .post,
            body: request
        )
        return try await send(urlRequest)
    }

    @discardableResult
    func updateEvent(withId eventId: Event.ID, and request: EventUpdate) async throws -> Event {
        // README: PUT /events/{eventId}
        let urlRequest = try makeRequest(
            path: "/events/\(eventId)",
            method: .put,
            body: request
        )
        return try await send(urlRequest)
    }

    func deleteEvent(withId eventId: Event.ID) async throws {
        // README: DELETE /events/{eventId}
        let urlRequest = try makeRequest(
            path: "/events/\(eventId)",
            method: .delete
        )
        try await sendWithoutBody(urlRequest)
    }

    // MARK: - Media

    @discardableResult
    func createMedia(with request: MediaCreate) async throws -> Media {
        // README: POST /media
        let urlRequest = try makeRequest(
            path: "/media",
            method: .post,
            body: request
        )
        return try await send(urlRequest)
    }

    func deleteMedia(withId mediaId: Media.ID) async throws {
        // README: DELETE /media/{mediaId}
        let urlRequest = try makeRequest(
            path: "/media/\(mediaId)",
            method: .delete
        )
        try await sendWithoutBody(urlRequest)
    }

    // MARK: - URLRequest helpers

    private func makeRequest(
        path: String,
        method: HTTPMethod,
        authorized: Bool = true
    ) throws -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if authorized {
            guard let token = token else {
                throw APIError.unauthorized
            }

            let value = "\(token.tokenType) \(token.accessToken)".trimmingCharacters(in: .whitespaces)
            if !value.isEmpty {
                request.setValue(value, forHTTPHeaderField: "Authorization")
            }
        }

        return request
    }

    private func makeRequest<Body: Encodable>(
        path: String,
        method: HTTPMethod,
        authorized: Bool = true,
        body: Body
    ) throws -> URLRequest {
        var request = try makeRequest(
            path: path,
            method: method,
            authorized: authorized
        )

        request.httpBody = try encoder.encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    // MARK: - Networking helpers

    private func send<T: Decodable>(_ request: URLRequest) async throws -> T {
        let data = try await perform(request)
        do {
            return try decoder.decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            throw APIError.decodingError(decodingError)
        } catch {
            throw APIError.underlying(error)
        }
    }

    private func sendWithoutBody(_ request: URLRequest) async throws {
        _ = try await perform(request)
    }

    private func perform(_ request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                if httpResponse.statusCode == 401 {
                    token = nil
                    throw APIError.unauthorized
                }
                throw APIError.httpStatus(httpResponse.statusCode)
            }

            return data
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.underlying(error)
        }
    }

    // MARK: - Helpers

    private func percentEscape(_ string: String) -> String {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove("+")
        return string.addingPercentEncoding(withAllowedCharacters: allowed) ?? string
    }
}
