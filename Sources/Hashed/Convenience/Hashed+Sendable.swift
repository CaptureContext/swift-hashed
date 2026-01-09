import Foundation

extension Hashed where Value: Sendable {
	@_disfavoredOverload
	@inlinable
	public init(wrappedValue: Value) {
		self.init(
			storedValue: .init(wrappedValue),
			hasher: .detectHashable()
		)
	}
}
