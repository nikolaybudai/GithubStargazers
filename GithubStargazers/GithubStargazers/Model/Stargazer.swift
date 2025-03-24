
import Foundation

/**
 A struct for a single stargazer.
 Holds information about a stargazer, including its login and avatarURL
 - Properties:
    - `login`:  username of the stargazer..
    - `avatarURL`: the URL to load the avatar..
*/
struct Stargazer: Decodable {
    let login: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
