use ethereum_types::U256;
use godot::prelude::*;
use std::str::FromStr;

#[derive(GodotClass)]
#[class(base=RefCounted)]
struct BaseBigNumber {
    value: U256,
}

#[godot_api]
impl BaseBigNumber {
    #[func]
    fn from_dec_string(&mut self, data: GodotString) {
        let input = data.to_string();
        let value = U256::from_dec_str(&input).unwrap();

        self.value = value;
    }

    #[func]
    fn from_hex_string(&mut self, data: GodotString) {
        let input = data.to_string();
        let value = U256::from_str(&input).unwrap();

        self.value = value;
    }

    #[func]
    fn to_dec_string(&self) -> GodotString {
        self.value.to_string().into()
    }

    #[func]
    fn add(&self, other: Gd<BaseBigNumber>) -> Gd<BaseBigNumber> {
        let other = other.bind().value;
        let result = self.value + other;
        Gd::new(BaseBigNumber { value: result })
    }
}

#[godot_api]
impl RefCountedVirtual for BaseBigNumber {
    fn init(_base: Base<Self::Base>) -> Self {
        Self {
            value: U256::zero(),
        }
    }
}
