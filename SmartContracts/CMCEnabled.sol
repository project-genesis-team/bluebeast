pragma solidity ^0.4.0;

import "./ContractProvider.sol";

/**
 * Base class for every contract (DB, Controller, ALC,)
 * Once CMC address is set it cannot be changed except from within itself.
**/

contract CMCEnabled {

    address public CMC;

    modifier isCMCEnabled(bytes32 _name) {
        if (CMC == 0x0 && msg.sender != ContractProvider(CMC).contracts(_name)) {
            revert();
        _;
        }
    }

    function setCMCAddress(address _cMC) external {
        if (CMC != 0x0 && msg.sender != CMC) {
            revert();
        } else {
            CMC = _cMC;
        }
    }

    function changeCMCAddress(address _newCMC) external {
        require(CMC == msg.sender);
        CMC = _newCMC;
    }

    function kill() external {
        assert(msg.sender == CMC);
        selfdestruct(CMC);
    }
}