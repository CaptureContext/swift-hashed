extension Hashed.Hasher {
	public static func typeID<T>() -> Self
	where Value == T.Type {
		.property(ObjectIdentifier.init)
	}
}
