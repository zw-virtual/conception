pub trait Target {
    fn name(&self) -> &str;
}

struct Adaptee {
    id: String,
}

impl Adaptee {
    fn id(&self) -> &str {
        &self.id
    }
}

pub struct Adapter {
    adaptee: Adaptee,
}

impl Adapter {
    pub fn new(id: &str) -> Self {
        Self {
            adaptee: Adaptee {
                id: format!("{}", id),
            },
        }
    }
}
impl Target for Adapter {
    fn name(&self) -> &str {
        self.adaptee.id()
    }
}
