import Testing
import Foundation
@_spi(Internals) @testable import Hashed

@Suite("HasherTests")
struct HasherTests {
	public struct NotHashable: Equatable {
		var value: Int

		init(value: Int = 0) {
			self.value = value
		}
	}

	@Test
	func empty() {
		do {
			let sut: Hashed<NotHashable>.Hasher = .empty
			#expect(sut.hashValue(for: NotHashable()) == Swift.Hasher().finalize())
		}

		do {
			let sut: Hashed<Int>.Hasher = .empty
			#expect(sut.hashValue(for: 0) == Swift.Hasher().finalize())
		}
	}

	@Test
	func defaultHashable() {
		struct HashableMock: Hashable {}

		do {
			let sut: Hashed<HashableMock>.Hasher = .defaultHashable
			#expect(sut.hashValue(for: HashableMock()) == HashableMock().hashValue)
		}

		do {
			let sut: Hashed<Int>.Hasher = .defaultHashable
			#expect(sut.hashValue(for: 0) == 0.hashValue)
		}
	}

	@Test
	func detectHashable() {
		do {
			let sut: Hashed<NotHashable>.Hasher = .detectHashable(
				fallback: .hashable("fallback")
			)

			#expect(sut.hashValue(for: NotHashable()) == "fallback".hashValue)
		}

		do {
			let sut: Hashed<Int>.Hasher = .detectHashable()
			#expect(sut.hashValue(for: 0) == 0.hashValue)
		}
	}

	@Test
	func hashedBy() async throws {
		do {
			let sut: Hashed<NotHashable>.Hasher = .hashable("fallback")
			#expect(sut.hashValue(for: NotHashable()) == "fallback".hashValue)
		}

		do {
			let sut: Hashed<Int>.Hasher = .hashable("fallback")
			#expect(sut.hashValue(for: 0) == "fallback".hashValue)
		}
	}

	@Test
	func property() async throws {
		struct HashableMock: Hashable {
			var value: Int
			var mixin: Int?
		}

		do {
			let sut: Hashed<HashableMock>.Hasher = .property(\.value)

			#expect(HashableMock(value: 0).hashValue != 0.hashValue)
			#expect(sut.hashValue(for: HashableMock(value: 0)) == 0.hashValue)
		}
	}

	@Test
	func dump() async throws {
		func getDump<T>(_ value: T) -> String {
			var output = ""
			Swift.dump(value, to: &output)
			return output
		}

		do {
			let sut: Hashed<NotHashable>.Hasher = .dump
			let value = NotHashable()
			#expect(sut.hashValue(for: value) == getDump(value).hashValue)
		}

		do {
			let sut: Hashed<Int>.Hasher = .dump
			#expect(sut.hashValue(for: 0) == getDump(0).hashValue)
		}
	}

	@Test
	func localizedDescription() async throws {
		struct MockError: LocalizedError, Equatable, @unchecked Sendable {
			let message: String

			init(_ message: String) {
				self.message = message
			}

			var errorDescription: String? {
				message
			}
		}

		let sut: Hashed<MockError>.Hasher = .localizedDescription

		do { // equal localized descriptions
			let value: MockError = .init("")
			#expect(sut.hashValue(for: value) == value.localizedDescription.hashValue)
		}

		do { // not equal localized descriptions
			let value: MockError = .init("1")
			#expect(sut.hashValue(for: value) == value.localizedDescription.hashValue)
		}
	}
}
