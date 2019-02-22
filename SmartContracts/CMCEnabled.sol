pragma solidity ^0.4.0;

import "./ContractProvider.sol";

/**
 * Base class for every contract (DB, Controller, ALC,)
 * Once CMC address is set it cannot be changed except from within itself.
**/

contract CMCEnabled {

    address public CMC;

   /**
    * @dev Modifier for contract access control
    */
    modifier isCMCEnabled(bytes32 _name) {
        if (CMC == 0x0 && msg.sender != ContractProvider(CMC).contracts(_name)) {
            revert();
        _;
        }
    }

   /**
    * @dev Sets contracts inital registry address
    */
    function setCMCAddress(address _cMC) external {
        if (CMC != 0x0 && msg.sender != CMC) {
            revert();
        } else {
            CMC = _cMC;
        }
    }

   /**
    * @dev Changes registry address, must be called from registry itself
    */
    function changeCMCAddress(address _newCMC) external {
        require(CMC == msg.sender);
        CMC = _newCMC;
    }

   /**
    * @dev Destroys registry, must be called from registry itself
    */
    function kill() external {
        assert(msg.sender == CMC);
        selfdestruct(CMC);
    }
}