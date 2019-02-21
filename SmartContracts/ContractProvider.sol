pragma solidity ^0.4.0;

interface ContractProvider {
    function contracts(bytes32 _name) external returns (address);
}