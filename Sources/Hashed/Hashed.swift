import Foundation
import Equated

public protocol _HashedProtocol<Value>: Hashable {
	associatedtype Value
	var storedValue: Equated<Value> { get set }
	var hasher: Hashed<Value>.Hasher { get set }
	var wrappedValue: Value { get set }
}

@propertyWrapper
public struct Hashed<Value>: _HashedProtocol {
	@inlinable
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.storedValue == rhs.storedValue
	}

	public var storedValue: Equated<Value>
	public var hasher: Hasher

	public var wrappedValue: Value {
		_read { yield storedValue.wrappedValue }
		_modify { yield &storedValue.wrappedValue }
	}

	public var projectedValue: Self {
		get { self }
		set { self = newValue }
	}

	@inlinable
	public init(
		storedValue: Equated<Value>,
		hasher: Hasher
	) {
		self.storedValue = storedValue
		self.hasher = hasher
	}

	@_disfavoredOverload
	@inlinable
	public init(
		_ wrappedValue: Value,
		by hasher: Hasher
	) {
		self.init(
			storedValue: .init(wrappedValue),
			hasher: hasher
		)
	}

	@_disfavoredOverload
	@inlinable
	public init(
		wrappedValue: Value,
		by hasher: Hasher = .uncheckedSendableDetectHashable()
	) {
		self.init(
			storedValue: .init(wrappedValue),
			hasher: hasher
		)
	}

	public func hash(into hasher: inout Swift.Hasher) {
		self.hasher.hash(wrappedValue, &hasher)
	}
}

extension Hashed: Sendable where Value: Sendable {}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Hashed: Identifiable where Value: Identifiable {
	@inlinable
	public var id: Value.ID { wrappedValue.id }
}

extension Hashed: Comparable where Value: Comparable {
	@inlinable
	public static func <(lhs: Self, rhs: Self) -> Bool {
		lhs.wrappedValue < rhs.wrappedValue
	}
}

extension Hashed: Error where Value: Error {
	@inlinable
	public var localizedDescription: String { wrappedValue.localizedDescription }
}

extension Hashed: LocalizedError where Value: LocalizedError {
	/// A localized message describing what error occurred.
	@inlinable
	public var errorDescription: String? { wrappedValue.errorDescription }

	/// A localized message describing the reason for the failure.
	@inlinable
	public var failureReason: String? { wrappedValue.failureReason }

	/// A localized message describing how one might recover from the failure.
	@inlinable
	public var recoverySuggestion: String? { wrappedValue.recoverySuggestion }

	/// A localized message providing "help" text if the user requests help.
	@inlinable
	public var helpAnchor: String? { wrappedValue.helpAnchor }
}
