import XCTest
@testable import RickAndMorty

// MARK: - URL Building

final class RMRequestTests: XCTestCase {
    
    func test_baseURL_isCorrect() {
        let request = RMRequest(endpoint: .character)
        XCTAssertEqual(request.url?.absoluteString, "https://rickandmortyapi.com/api/character")
    }
    
    func test_multipleQueryParams_allAppendedToURL() {
        let request = RMRequest(
            endpoint: .character,
            queryParameters: [
                URLQueryItem(name: "name", value: "Rick"),
                URLQueryItem(name: "status", value: "alive")
            ]
        )
        
        let urlString = request.url?.absoluteString ?? ""
        
        XCTAssertTrue(urlString.contains("name=Rick"), "name param missing")
        XCTAssertTrue(urlString.contains("status=alive"), "status param missing")
        XCTAssertTrue(urlString.contains("?"), "query separator missing")
        XCTAssertTrue(urlString.contains("&"), "param separator missing")
    }
    
    func test_convenienceInit_parsesQueryParamsFromURL() {
        let url = URL(string: "https://rickandmortyapi.com/api/character?name=Rick&status=alive")!
        let request = RMRequest(url: url)
        
        XCTAssertNotNil(request, "Should parse valid API URL")
        XCTAssertEqual(request?.url?.absoluteString, url.absoluteString)
    }
    
    func test_convenienceInit_rejectsNonAPIURL() {
        let url = URL(string:  "https://evil.com/api/character")!
        XCTAssertNil(RMRequest(url: url))
    }
}

// MARK: - Search Logic

final class RMSearchInputViewModelTests: XCTestCase {
    
    func test_characterSearch_hasExactlyStatusAndGender() {
        let vm = RMSearchInputViewViewModel(type: .character)
        XCTAssertEqual(vm.options, [.status, .gender])
    }
    
    func test_episodeSearch_hasOptions() {
        let vm = RMSearchInputViewViewModel(type: .episode)
        XCTAssertTrue(vm.options.isEmpty)
        XCTAssertFalse(vm.hasDynamicOptions)
    }
    
    func test_dynamicOptions_queryArgumentsMatchAPISpec() {
        XCTAssertEqual(RMSearchInputViewViewModel.DynamicOption.status.queryArgument, "status")
        XCTAssertEqual(RMSearchInputViewViewModel.DynamicOption.gender.queryArgument, "gender")
        XCTAssertEqual(RMSearchInputViewViewModel.DynamicOption.locationType.queryArgument, "type")
    }
}

// MARK: - Character Status

final class RMCharacterStatusTests: XCTestCase {
    
    func test_unknownStatus_displayTextIsCapitalized() {
        XCTAssertEqual(RMCharacterStatus.unknown.rawValue, "unknown")
        XCTAssertEqual(RMCharacterStatus.unknown.text, "Unknown")
        XCTAssertNotEqual(RMCharacterStatus.unknown.text, RMCharacterStatus.unknown.rawValue)
    }
    
    func test_status_decodesFromJSONCorrectly() throws {
        let json = """
        { "status": "Alive" }
        """.data(using: .utf8)!
        
        struct Wrapper: Codable { let status: RMCharacterStatus }
        let result = try JSONDecoder().decode(Wrapper.self, from: json)
        XCTAssertEqual(result.status, .alive)
    }
}

// MARK: - Date Formatting

final class RMCharacterInfoViewModelTests: XCTestCase {
    
    func test_createdDate_isFormattedForDisplay() {
        let vm = RMCharacterInfoCollectionViewCellViewModel(
            type: .created,
            value: "2017-11-04T18:48:46.250Z"
        )
        
        XCTAssertNotEqual(vm.displayValue, "2017-11-04T18:48:46.250Z")
        XCTAssertTrue(vm.displayValue.contains("2017"), "Formatted date should contain year")
    }
    
    func test_emptyValue_showsNonePlaceholder() {
        let vm = RMCharacterInfoCollectionViewCellViewModel(
            type: .type,
            value: ""
        )
        
        XCTAssertEqual(vm.displayValue, "None")
    }
}
