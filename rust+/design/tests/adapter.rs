use design::adapter::{Adapter, Target};
#[test]
fn adapter_works() {
    let target: Box<dyn Target> = Box::new(Adapter::new("AD102"));
    assert_eq!("AD102", target.name());
}
