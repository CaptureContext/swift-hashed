import Foundation

extension Hashed where Value: ExpressibleByNilLiteral {
	@_disfavoredOverload
	@inlinable
	public init(by hasher: Hasher = .uncheckedSendableDetectHashable()) {
		self.init(
			storedValue: .init(nil),
			hasher: hasher
		)
	}
}

extension Hashed where Value: ExpressibleByNilLiteral & Sendable {
	@_disfavoredOverload
	@inlinable
	public init(by hasher: Hasher = .detectHashable()) {
		self.init(
			storedValue: .init(nil),
			hasher: hasher
		)
	}
}

extension Hashed where Value: ExpressibleByNilLiteral & Hashable {
	@inlinable
	public init() {
		self.init(nil)
	}
}

extension Hashed where Value: ExpressibleByNilLiteral & Hashable & Sendable {
	@inlinable
	public init() {
		self.init(nil)
	}
}

extension Hashed where Value: ExpressibleByNilLiteral & Error {
	@inlinable
	public init() {
		self.init(nil)
	}
}

extension Hashed where Value: ExpressibleByNilLiteral & Error & Hashable {
	@inlinable
	public init() {
		self.init(nil)
	}
}
