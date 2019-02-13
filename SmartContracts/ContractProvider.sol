
pragma solidity 0.5.0;


interface ContractProvider {
    function contracts(bytes32 _name) external returns (address);
}