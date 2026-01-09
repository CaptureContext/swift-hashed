import Foundation

extension Hashed where Value: Hashable {
	@inlinable
	public init(wrappedValue: Value) {
		self.init(
			storedValue: .init(wrappedValue),
			hasher: .defaultHashable
		)
	}

	@inlinable
	public init(_ wrappedValue: Value) {
		self.init(
			storedValue: .init(wrappedValue),
			hasher: .defaultHashable
		)
	}
}
