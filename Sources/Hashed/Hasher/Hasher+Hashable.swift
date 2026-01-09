import Foundation

extension Hashed.Hasher where Value: Hashable {
	@inlinable
	public static var defaultHashable: Self {
		return .uncheckedSendable { value, hasher in
			value.hash(into: &hasher)
		}
	}
}

extension Hashed.Hasher {
	public static func uncheckedSendableDetectHashable(
		fallback: Self = .uncheckedSendableDump
	) -> Self {
		.uncheckedSendable { value, hasher in
			if let value = value as? (any Hashable) {
				value.hash(into: &hasher)
			} else {
				fallback.hash(value, &hasher)
			}
		}
	}

	public static func uncheckedSendable<T: Hashable>(
		_ other: T
	) -> Self {
		.uncheckedSendable { _, hasher in
			other.hash(into: &hasher)
		}
	}
}

extension Hashed.Hasher where Value: Sendable {
	public static func detectHashable(
		fallback: Self = .dump
	) -> Self {
		.custom { value, hasher in
			if let value = value as? (any Hashable) {
				value.hash(into: &hasher)
			} else {
				fallback.hash(value, &hasher)
			}
		}
	}

	public static func hashable<T: Hashable & Sendable>(
		_ other: T
	) -> Self {
		.custom { _, hasher in
			other.hash(into: &hasher)
		}
	}
}

