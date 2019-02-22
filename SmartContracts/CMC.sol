pragma solidity ^0.4.0;

import "./CMCEnabled.sol";
import "./Tools/Ownable.sol";

contract CMC is Ownable {

    mapping (bytes32 => address) public contracts;

   /**
    * @dev Adds contract to register
    */
    function addContract(bytes32 _name, address _address) external onlyOwner {
        CMCEnabled cmcEnabled = CMCEnabled(_address);
        cmcEnabled.setCMCAddress(address(this));
        contracts[_name] = _address;
    }

   /**
    * @dev Get contract from register
    */
    function getContract(bytes32 _name) external view returns (address) {
        return contracts[_name];
    }

    /**
    * @dev Remove contract from register
    */
    function removeContract(bytes32 _name) external onlyOwner returns (bool) {
        require(contracts[_name] != 0x0);
        CMCEnabled cmcEnabled = CMCEnabled(contracts[_name]);
        cmcEnabled.kill();
        contracts[_name] = 0x0;
    }

    /**
    * @dev Point contract to another registry
    */
    function changeContractCMC(bytes32 _name, address _newCMC) external onlyOwner {
        CMCEnabled cmcEnabled = CMCEnabled(contracts[_name]);
        cmcEnabled.changeCMCAddress(_newCMC);
    }
}