pragma solidity 0.5.0;

import "./CMCEnabled.sol";

import "./Controller.sol";
/**
* INCLUDES:
* CMCEnabled.sol
* Ownable.sol
* ContractProvider.sol
* Permission modifier for entrypoint (UserEntry)
**/


contract UserInput is CMCEnabled {

    function setX(uint _x) external {
        Controller(ContractProvider(CMC).contracts("Controller")).setX(_x);
    }
}