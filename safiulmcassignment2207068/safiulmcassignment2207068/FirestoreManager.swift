import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
@MainActor
class FirestoreManager: ObservableObject {

    private let db = Firestore.firestore()

    @Published var notes: [Note] = []
    @Published var errorMessage = ""

    private var listener: ListenerRegistration?

    private var userID: String? {
        Auth.auth().currentUser?.uid
    }

    // READ NOTES
    func getNotes() {

        guard let userID else { return }

        listener?.remove()

        listener = db.collection("notes")
            .whereField("userId", isEqualTo: userID)
            .addSnapshotListener { [weak self] snapshot, error in

                Task { @MainActor in

                    if let error {
                        self?.errorMessage = error.localizedDescription
                        return
                    }

                    guard let documents = snapshot?.documents else {
                        self?.notes = []
                        return
                    }

                    self?.notes = documents.compactMap { document in
                        try? document.data(as: Note.self)
                    }
                }
            }
    }    // ADD NOTE
    func addNote(title: String, content: String) {

        guard let userID else { return }

        do {
            _ = try db.collection("notes").addDocument(data: [
                "title": title,
                "content": content,
                "userId": userID
            ])
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // UPDATE NOTE
    func updateNote(note: Note) {

        guard let id = note.id,
              let userID else { return }

        db.collection("notes").document(id).updateData([
            "title": note.title,
            "content": note.content,
            "userId": userID
        ]) { [weak self] error in

            if let error {
                Task { @MainActor in
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // DELETE NOTE
    func deleteNote(note: Note) {

        guard let id = note.id else { return }

        db.collection("notes")
            .document(id)
            .delete { [weak self] error in

                if let error {
                    Task { @MainActor in
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
    }

    func stopListening() {
        listener?.remove()
        listener = nil
        notes = []
    }
}
