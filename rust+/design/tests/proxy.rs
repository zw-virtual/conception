use design::proxy::Proxy;

#[test]
fn proxy_test() {
    assert_eq!("proxy:target", Proxy::new().run());
}
