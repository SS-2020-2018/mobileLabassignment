
import SwiftUI

struct FContentView: View {

    @EnvironmentObject var authViewModel: AuthViewModel

    @StateObject private var firestoreManager = FirestoreManager()

    @State private var showingAddNote = false
    @State private var selectedNote: Note?

    var body: some View {

        NavigationStack {

            List {

                ForEach(firestoreManager.notes) { note in

                    VStack(alignment: .leading, spacing: 6) {

                        Text(note.title)
                            .font(.headline)

                        Text(note.content)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedNote = note
                    }
                    .swipeActions {

                        Button(role: .destructive) {
                            firestoreManager.deleteNote(note: note)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                            selectedNote = note
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .navigationTitle("My Notes")
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddNote = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button("Sign Out") {
                        firestoreManager.stopListening()
                        authViewModel.signOut()
                    }
                }
            }
            .overlay {
                if !firestoreManager.errorMessage.isEmpty {
                    Text(firestoreManager.errorMessage)
                        .foregroundStyle(.red)
                }
            }
            .onAppear {
                firestoreManager.getNotes()
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteView(
                    firestoreManager: firestoreManager,
                    existingNote: nil
                )
            }
            .sheet(item: $selectedNote) { note in
                AddNoteView(
                    firestoreManager: firestoreManager,
                    existingNote: note
                )
            }
        }
    }
}
