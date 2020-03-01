use design::subscribe::{Channel, Subscriber};

#[test]
fn subscribe_test() {
    let mut channel = Channel {
        subscribers: vec![],
    };
    vec![1, 2, 3]
        .iter()
        .for_each(|_i| channel.bind(Subscriber::new()));
    channel.notify();
    assert_eq!(
        vec![true, true, true],
        channel
            .subscribers
            .iter()
            .map(|v| v.state())
            .collect::<Vec<bool>>()
    );
}
