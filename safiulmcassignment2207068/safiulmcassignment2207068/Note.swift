import Foundation
import FirebaseFirestore

struct Note: Identifiable, Codable {

    @DocumentID
    var id: String?

    var title: String
    var content: String
    var userId: String
}
