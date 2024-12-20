// Write test for the StudentRegistry contract here
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
use starknet::{ContractAddress};
use cairo_bootcamp_3::student_registry::{
    IStudentRegistryDispatcher, IStudentRegistrySafeDispatcher, IStudentRegistryDispatcherTrait,
    IStudentRegistrySafeDispatcherTrait
};

pub mod Accounts {
    use starknet::ContractAddress;
    use core::traits::TryInto;

    pub fn zero() -> ContractAddress {
        0x0000000000000000000000000000000000000000.try_into().unwrap()
    }

    pub fn admin() -> ContractAddress {
        'admin'.try_into().unwrap()
    }

    pub fn account1() -> ContractAddress {
        'account1'.try_into().unwrap()
    }

    pub fn account2() -> ContractAddress {
        'account2'.try_into().unwrap()
    }
}

fn deploy(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let constructor_args = array![Accounts::admin().into()];
    let (contract_address, _) = contract.deploy(@constructor_args).unwrap();
    contract_address
}


#[test]
fn test_add_student() {
    let contract_address = deploy("StudentRegistry");

    let student_registry_dispatcher = IStudentRegistryDispatcher { contract_address };

    let account1 = Accounts::account1();

    student_registry_dispatcher.add_student('JK', account1, 20, 100, true);

    let student1 = student_registry_dispatcher.get_student(0);

    let (_id, name, account, age, xp, active) = student1;

    assert(name == 'JK', 'Name was not set correctly');
    assert(account == account1, 'Account was not set correctly');
    assert(age == 20, 'Age was not set correctly');
    assert(xp == 100, 'XP was not set correctly');
    assert(active == true, 'status was not set correctly');
}

#[test]
fn test_get_student() {
    let contract_address = deploy("StudentRegistry");

    let student_registry_dispatcher = IStudentRegistryDispatcher { contract_address };

    let account1 = Accounts::account1();

    student_registry_dispatcher.add_student('John', account1, 20, 100, true);

    let student1 = student_registry_dispatcher.get_student(0);

    let (_id, name, account, age, xp, active) = student1;

    assert(name == 'John', 'Name was not set correctly');
    assert(account == account1, 'Account was not set correctly');
    assert(age == 20, 'Age was not set correctly');
    assert(xp == 100, 'XP was not set correctly');
    assert(active == true, 'status was not set correctly');
}

#[test]
fn test_update_student() {
    let contract_address = deploy("StudentRegistry");

    let student_registry_dispatcher = IStudentRegistryDispatcher { contract_address };

    let account1 = Accounts::account1();

    student_registry_dispatcher.add_student('John', account1, 20, 100, true);

    let result = student_registry_dispatcher.update_student(0, 'Jane', account1, 21, 101, false);

    assert(result == true, 'Student update failed');

    let student1 = student_registry_dispatcher.get_student(0);

    let (_id, name, account, age, xp, active) = student1;

    assert(name == 'Jane', 'Name was not set correctly');
    assert(account == account1, 'Account was not set correctly');
    assert(age == 21, 'Age was not set correctly');
    assert(xp == 101, 'XP was not set correctly');
    assert(active == false, 'status was not set correctly');
}
