pub struct Channel {
    pub subscribers: Vec<Box<dyn Subscribe>>,
}

impl Channel {
    pub fn bind<T>(&mut self, subscriber: T)
    where
        T: Subscribe + Clone + 'static,
    {
        self.subscribers.push(Box::new(subscriber.clone()));
    }

    pub fn notify(&mut self) {
        self.subscribers.iter_mut().for_each(|v| v.update());
    }
}

pub trait Subscribe {
    fn update(&mut self);
    fn state(&self) -> bool;
}

#[derive(Clone)]
pub struct Subscriber {
    state: bool,
}

impl Subscriber {
    pub fn new() -> Self {
        Self { state: false }
    }
}

impl Subscribe for Subscriber {
    fn update(&mut self) {
        self.state = true;
    }

    fn state(&self) -> bool {
        self.state
    }
}
