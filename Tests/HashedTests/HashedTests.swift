import Testing
import Foundation
@testable import Hashed

@Suite("HashedTests")
struct HashedTests {
	enum NonHashableError: LocalizedError {
		case first(String)
		case second(String)

		var errorDescription: String? {
			switch self {
			case let .first(message): message
			case let .second(message): message
			}
		}
	}

	enum HashableError: LocalizedError, Hashable {
		static func == (lhs: Self, rhs: Self) -> Bool {
			switch (lhs, rhs) {
			case (.first, .first): true
			case (.second, .second): true
			default: false
			}
		}

		case first(String)
		case second(String)

		var errorDescription: String? {
			switch self {
			case let .first(message): message
			case let .second(message): message
			}
		}
	}

	struct NonHashable: Equatable {
		let value: Int

		init(_ value: Int = 0) {
			self.value = value
		}
	}


	@Test
	func basicInits() async throws {
		_ = Hashed(storedValue: Equated(NonHashable(), by: .dump), hasher: .property(\.value))
		_ = Hashed(wrappedValue: NonHashable(), by: .property(\.value))
		_ = Hashed(NonHashable(), by: .property(\.value))
	}

	@Test
	func equatableInits() async throws {
		_ = Hashed(wrappedValue: 0)
		_ = Hashed(0)
	}

	@Test
	func optionalInits() async throws {
		_ = Hashed<NonHashable?>(by: .dump)
		_ = Hashed<NonHashable?>()

		_ = Hashed<Int?>(by: .defaultHashable)
		_ = Hashed<Int?>()
	}

	@Test
	func propertyWrapperInits() async throws {
		@Hashed(storedValue: .init(()), hasher: .dump)
		var sut0: Void

		@Hashed(by: .dump)
		var sut1: Void = ()

		@Hashed(by: .defaultHashable)
		var sut2: Int = 0

		@Hashed(by: .detectHashable())
		var sut3: NonHashable = .init()

		@Hashed(wrappedValue: 0, by: .defaultHashable)
		var sut4: Int

		@Hashed(0, by: .defaultHashable)
		var sut5: Int

		@Equated
		var sut6: HashableError = .first("")

		@Equated(by: .property(\.?.errorDescription))
		var sut7: HashableError?
	}
}
