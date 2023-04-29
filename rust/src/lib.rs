use godot::prelude::*;

mod big_number;
mod keccak256;

struct EthGd;

#[gdextension]
unsafe impl ExtensionLibrary for EthGd {}
