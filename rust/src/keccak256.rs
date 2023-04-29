use godot::prelude::*;
use tiny_keccak::{Hasher, Keccak};

#[derive(GodotClass)]
#[class(base=Node)]
pub struct BaseKeccak256 {
    #[base]
    base: Base<Node>,
}

#[godot_api]
impl BaseKeccak256 {
    #[func]
    fn hash(&self, data: GodotString) -> GodotString {
        let input = data.to_string();
        let mut hasher = Keccak::v256();
        hasher.update(input.as_bytes());
        let mut output = [0u8; 32];
        hasher.finalize(&mut output);

        let hex = output
            .iter()
            .map(|b| format!("{:02x}", b))
            .collect::<String>();
        let result = format!("0x{}", hex);
        GodotString::from(result)
    }
}

#[godot_api]
impl NodeVirtual for BaseKeccak256 {
    fn init(base: Base<Self::Base>) -> Self {
        Self { base }
    }
}
