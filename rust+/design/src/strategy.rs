pub struct Context {
    env: Box<dyn Strategy>,
}

impl Context {
    pub fn new<T>(env: T) -> Self
    where
        T: Strategy + Clone + 'static,
    {
        Self { env: Box::new(env) }
    }

    pub fn reset<T>(&mut self, env: T)
    where
        T: Strategy + Clone + 'static,
    {
        self.env = Box::new(env)
    }

    pub fn get_result(&self) -> u32 {
        self.env.arithmetic()
    }
}

pub trait Strategy {
    fn arithmetic(&self) -> u32;
}

#[derive(Clone)]
pub struct ImplA {}

impl Strategy for ImplA {
    fn arithmetic(&self) -> u32 {
        44
    }
}

#[derive(Clone)]
pub struct ImplB {}

impl Strategy for ImplB {
    fn arithmetic(&self) -> u32 {
        66
    }
}
