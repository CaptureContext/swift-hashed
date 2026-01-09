import Foundation

extension Hashed.Hasher where Value: Sendable {
	@inlinable
	public static func property<Property: Hashable & Sendable>(
		_ scope: @escaping @Sendable (Value) -> Property
	) -> Self {
		return .custom { scope($0).hash(into: &$1) }
	}
}

extension Hashed.Hasher {
	@inlinable
	public static func uncheckedSendable<Property: Hashable>(
		_ scope: @escaping (Value) -> Property
	) -> Self {
		return .uncheckedSendable { scope($0).hash(into: &$1) }
	}
}
