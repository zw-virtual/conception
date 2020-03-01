use design::strategy::{Context, ImplA, ImplB, Strategy};

#[test]
fn strategy_test() {
    let impl_a = ImplA {};
    let impl_b = ImplB {};
    let mut ctx = Context::new(impl_a);
    assert_eq!(44, ctx.get_result());
    ctx.reset(impl_b);
    assert_eq!(66, ctx.get_result());
}
