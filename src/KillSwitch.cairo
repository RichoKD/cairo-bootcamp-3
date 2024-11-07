
use starknet::ContractAddress;

#[starknet::interface]
pub trait IKillSwitch<T> {
    fn get_current_owner(self: @T) -> ContractAddress;

    fn set_is_on(ref self: T, _is_on: bool);

    fn get_is_on(self: @T) -> bool;
}

#[starknet::contract]
pub mod KillSwitch {
    use core::num::traits::Zero;
    use starknet::{ContractAddress, get_caller_address};


    #[storage]
    struct Storage {
        owner: ContractAddress,
        is_on: bool
    }

    #[constructor]
    fn constructor(ref self: ContractState, _owner: ContractAddress) {
        // validation to check if owner is valid address and 0 address
        assert(self.is_zero_address(_owner) == false, '0 address');
        self.owner.write(_owner);
    }

    #[abi(embed_v0)]
    impl KillSwitchImpl of super::IKillSwitch<ContractState> {
        fn get_current_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }

        fn set_is_on(ref self: ContractState, _is_on: bool) {
            self.is_on.write(_is_on);
        }

        fn get_is_on(self: @ContractState) -> bool {
            self.is_on.read()
        }
    }


    #[generate_trait]
    impl Private of PrivateTrait {
        fn only_owner(self: @ContractState) {
            // get function caller
            let caller: ContractAddress = get_caller_address();

            // get owner of CounterV2 contract
            let current_owner: ContractAddress = self.owner.read();

            // assertion logic
            assert(caller == current_owner, 'caller not owner');
        }


        fn is_zero_address(self: @ContractState, account: ContractAddress) -> bool {
            if account.is_zero() {
                return true;
            }
            return false;
        }
    }


}