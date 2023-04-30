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
    fn to_hex_string(&self) -> GodotString {
        format!("0x{:x}", self.value).into()
    }

    #[func]
    fn add(&self, other: Gd<BaseBigNumber>) -> Gd<BaseBigNumber> {
        let other = other.bind().value;
        let result = self.value + other;
        Gd::new(BaseBigNumber { value: result })
    }

    #[func]
    fn sub(&self, other: Gd<BaseBigNumber>) -> Gd<BaseBigNumber> {
        let other = other.bind().value;
        let result = self.value - other;
        Gd::new(BaseBigNumber { value: result })
    }

    #[func]
    fn mul(&self, other: Gd<BaseBigNumber>) -> Gd<BaseBigNumber> {
        let other = other.bind().value;
        let result = self.value * other;
        Gd::new(BaseBigNumber { value: result })
    }

    #[func]
    fn div(&self, other: Gd<BaseBigNumber>) -> Gd<BaseBigNumber> {
        let other = other.bind().value;
        let result = self.value / other;
        Gd::new(BaseBigNumber { value: result })
    }

    #[func]
    fn modulo(&self, other: Gd<BaseBigNumber>) -> Gd<BaseBigNumber> {
        let other = other.bind().value;
        let result = self.value % other;
        Gd::new(BaseBigNumber { value: result })
    }

    #[func]
    fn div_mod(&self, other: Gd<BaseBigNumber>) -> Array<Gd<BaseBigNumber>> {
        let other = other.bind().value;
        let (result, remainder) = self.value.div_mod(other);
        let mut array = Array::new();
        let result = Gd::new(BaseBigNumber { value: result });
        let remainder = Gd::new(BaseBigNumber { value: remainder });
        array.push(result);
        array.push(remainder);
        array
    }

    #[func]
    fn pow(&self, other: Gd<BaseBigNumber>) -> Gd<BaseBigNumber> {
        let other = other.bind().value;
        let result = self.value.pow(other);
        Gd::new(BaseBigNumber { value: result })
    }

    #[func]
    fn shl(&self, other: Gd<BaseBigNumber>) -> Gd<BaseBigNumber> {
        let other = other.bind().value;
        let result = self.value << other;
        Gd::new(BaseBigNumber { value: result })
    }

    #[func]
    fn shr(&self, other: Gd<BaseBigNumber>) -> Gd<BaseBigNumber> {
        let other = other.bind().value;
        let result = self.value >> other;
        Gd::new(BaseBigNumber { value: result })
    }

    #[func]
    fn and(&self, other: Gd<BaseBigNumber>) -> Gd<BaseBigNumber> {
        let other = other.bind().value;
        let result = self.value & other;
        Gd::new(BaseBigNumber { value: result })
    }

    #[func]
    fn or(&self, other: Gd<BaseBigNumber>) -> Gd<BaseBigNumber> {
        let other = other.bind().value;
        let result = self.value | other;
        Gd::new(BaseBigNumber { value: result })
    }

    #[func]
    fn xor(&self, other: Gd<BaseBigNumber>) -> Gd<BaseBigNumber> {
        let other = other.bind().value;
        let result = self.value ^ other;
        Gd::new(BaseBigNumber { value: result })
    }

    #[func]
    fn eq(&self, other: Gd<BaseBigNumber>) -> bool {
        let other = other.bind().value;
        self.value == other
    }

    #[func]
    fn ne(&self, other: Gd<BaseBigNumber>) -> bool {
        let other = other.bind().value;
        self.value != other
    }

    #[func]
    fn lt(&self, other: Gd<BaseBigNumber>) -> bool {
        let other = other.bind().value;
        self.value < other
    }

    #[func]
    fn le(&self, other: Gd<BaseBigNumber>) -> bool {
        let other = other.bind().value;
        self.value <= other
    }

    #[func]
    fn gt(&self, other: Gd<BaseBigNumber>) -> bool {
        let other = other.bind().value;
        self.value > other
    }

    #[func]
    fn ge(&self, other: Gd<BaseBigNumber>) -> bool {
        let other = other.bind().value;
        self.value >= other
    }

    #[func]
    fn not(&self) -> Gd<BaseBigNumber> {
        let result = !self.value;
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
