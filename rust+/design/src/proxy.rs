struct Target {}

impl Target {
    fn run(&self) -> String {
        format!("target")
    }
}

pub struct Proxy {
    target: Target,
}

impl Proxy {
    pub fn new() -> Self {
        Self { target: Target {} }
    }
    pub fn run(&self) -> String {
        format!("proxy:{}", self.target.run())
    }
}
