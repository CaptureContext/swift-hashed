import Foundation

extension Hashed where Value: Error {
	@inlinable
	public init(_ wrappedValue: Value) {
		self.init(wrappedValue: wrappedValue)
	}

	@inlinable
	public init(wrappedValue: Value) {
		self.init(
			storedValue: .init(wrappedValue),
			hasher: .localizedDescription
		)
	}
}

extension Hashed where Value: Error & Equatable {
	@inlinable
	public init(_ wrappedValue: Value) {
		self.init(wrappedValue: wrappedValue)
	}

	@inlinable
	public init(wrappedValue: Value) {
		self.init(
			storedValue: .init(wrappedValue),
			hasher: .localizedDescription
		)
	}
}


extension Hashed where Value: Error & Hashable {
	@inlinable
	public init(_ wrappedValue: Value) {
		self.init(wrappedValue: wrappedValue)
	}

	@inlinable
	public init(wrappedValue: Value) {
		self.init(
			storedValue: .init(wrappedValue),
			hasher: .defaultHashable
		)
	}
}
