import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        Resolver.register { Data() }
        .scope(.cached)
    }
}
