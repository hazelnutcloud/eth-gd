use godot::prelude::*;

mod keccak256;

struct EthGd;

struct Test {
    test: u256,
}

#[gdextension]
unsafe impl ExtensionLibrary for EthGd {}
