import Foundation

struct Document {
    let id: Int
    let title: String
    let content: String
    let metadata: [String: String]
}

protocol DocumentStorageSystem {
    func uploadDocument(document: Document)
    func downloadDocument(documentID: Int) -> Document?
    func editDocument(documentID: Int, newContent: String)
    func searchDocuments(query: String) -> [Document]
}

class RealDocumentStorageSystem: DocumentStorageSystem {
    private var documents: [Document] = []

    func uploadDocument(document: Document) {
        documents.append(document)
    }

    func downloadDocument(documentID: Int) -> Document? {
        return documents.first { $0.id == documentID }
    }

    func editDocument(documentID: Int, newContent: String) {
        if let index = documents.firstIndex(where: { $0.id == documentID }) {
            documents[index] = Document(id: documentID, title: documents[index].title, content: newContent, metadata: documents[index].metadata)
        }
    }

    func searchDocuments(query: String) -> [Document] {
        return documents.filter { $0.title.contains(query) || $0.content.contains(query) }
    }
}

class ProxyDocumentStorageSystem: DocumentStorageSystem {
    private let realDocumentStorageSystem: RealDocumentStorageSystem

    init(realDocumentStorageSystem: RealDocumentStorageSystem) {
        self.realDocumentStorageSystem = realDocumentStorageSystem
    }

    func uploadDocument(document: Document) {
        realDocumentStorageSystem.uploadDocument(document: document)
    }

    func downloadDocument(documentID: Int) -> Document? {
        return realDocumentStorageSystem.downloadDocument(documentID: documentID)
    }

    func editDocument(documentID: Int, newContent: String) {
        realDocumentStorageSystem.editDocument(documentID: documentID, newContent: newContent)
    }

    func searchDocuments(query: String) -> [Document] {
        return realDocumentStorageSystem.searchDocuments(query: query)
    }
}

let realDocumentStorageSystem = RealDocumentStorageSystem()
let proxyDocumentStorageSystem = ProxyDocumentStorageSystem(realDocumentStorageSystem: realDocumentStorageSystem)

let document = Document(id: 1, title: "Document 1", content: "This is the content of Document 1", metadata: ["author": "John Doe"])
proxyDocumentStorageSystem.uploadDocument(document: document)

if let downloadedDocument = proxyDocumentStorageSystem.downloadDocument(documentID: 1) {
    print("Downloaded Document: \(downloadedDocument)")
} else {
    print("Document not found.")
}

proxyDocumentStorageSystem.editDocument(documentID: 1, newContent: "This is the edited content of Document 1")

let query = "Document"
let searchResults = proxyDocumentStorageSystem.searchDocuments(query: query)
print("Search results for query '\(query)':")
searchResults.forEach { print($0) }

