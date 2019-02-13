pragma solidity 0.5.0;

import "./CMCEnabled.sol";
import "./Ownable.sol";


contract CMC is Ownable {
    mapping (bytes32 => address) public contracts;

    function addContract(bytes32 _name, address _address) external onlyOwner {
        CMCEnabled cmcEnabled = CMCEnabled(_address);
        cmcEnabled.setCMCAddress(address(this));
        contracts[_name] = _address;
    }

    function getContract(bytes32 _name) external view returns (address) {
        return contracts[_name];
    }

    function removeContract(bytes32 _name) external onlyOwner returns (bool) {
        require(contracts[_name] != 0x0);
        CMCEnabled cmcEnabled = CMCEnabled(contracts[_name]);
        cmcEnabled.kill();
        contracts[_name] = 0x0;
    }

    function changeContractCMC(bytes32 _name, address _newCMC) external onlyOwner {
        CMCEnabled cmcEnabled = CMCEnabled(contracts[_name]);
        cmcEnabled.changeCMCAddress(_newCMC);
    }
}