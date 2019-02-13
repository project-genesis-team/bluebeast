pragma solidity 0.5.0;

import "./ContractProvider.sol";

/**
 * Base class for every contract (DB, Controller, ALC,)
 * Once CMC address is set it cannot be changed except from within itself.
**/

contract CMCEnabled {

    address public cMC;

    modifier isCMCEnabled(bytes32 _name) {
        if (cMC == 0x0 && msg.sender != ContractProvider(cMC).contracts(_name)) revert();
        _;
    }

    function setCMCAddress(address _cMC) external {
        if (cMC != 0x0 && msg.sender != cMC) {
            revert();
        } else {
            cMC = _cMC;
        }
    }

    function changeCMCAddress(address _newCMC) external {
        require(cMC == msg.sender);
        cMC = _newCMC;
    }

    function kill() external {
        assert(msg.sender == cMC);
        selfdestruct(cMC);
    }
}