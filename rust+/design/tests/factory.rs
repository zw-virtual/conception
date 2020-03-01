use design::factory::{OxygenNotIncluded, RimWorld, Software, WorkStudio};

#[test]
fn factory_works() {
    let rim_world: Box<dyn Software> = Box::new(RimWorld {});
    let oxygen_not_included: Box<dyn Software> = Box::new(OxygenNotIncluded {});
    let mut work_studio = WorkStudio::new("Inc");
    work_studio.works.push(rim_world);
    work_studio.works.push(oxygen_not_included);
    vec!["rim world", "oxygen not included"]
        .iter()
        .zip(work_studio.works.iter())
        .for_each(|(x, software)| assert_eq!(x, &software.id()))
}
