use std::string::String;
use std::vec::Vec;

pub struct WorkStudio {
    pub name: String,
    pub people: Vec<String>,
    pub works: Vec<Box<dyn Software>>,
}

impl WorkStudio {
    pub fn new(name: &str) -> Self {
        Self {
            name: String::from(name),
            people: Vec::new(),
            works: Vec::new(),
        }
    }

    pub fn make<'a, T>(&mut self, work: &'a T)
    where
        'a: 'static,
        T: Software + Clone,
    {
        self.works.push(Box::new(work.clone()));
    }
}

pub trait Software {
    fn id(&self) -> &str;
    fn install(&self) {
        println!("{} installed.", self.id());
    }
    fn uninstall(&self) {
        println!("{} uninstalled.", self.id());
    }
    fn run(&self) {
        println!("{} runs.", self.id());
    }
    fn exit(&self) {
        println!("{} exited.", self.id());
    }
}

pub struct RimWorld {}
pub struct OxygenNotIncluded {}

impl Software for RimWorld {
    fn id(&self) -> &str {
        "rim world"
    }
}

impl Software for OxygenNotIncluded {
    fn id(&self) -> &str {
        "oxygen not included"
    }
}
