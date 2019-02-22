pragma solidity ^0.4.0;

import "./CMCEnabled.sol";
import "./Storage.sol";

/**
* @dev Controller is a proxy that gets called from Unitarium and call storage updates.
*/
contract Controller is CMCEnabled {

    function totalSupply() isCMCEnabled("Unitarium") external view returns (uint256) {
        Storage(ContractProvider(CMC).contracts("Storage")).totalSupply();
    }

    function balanceOf(address owner) isCMCEnabled("Unitarium") external view returns (uint256) {
        Storage(ContractProvider(CMC).contracts("Storage")).balanceOf(owner);
    }

    function allowance(address owner, address spender) isCMCEnabled("Unitarium") external view returns (uint256) {
        Storage(ContractProvider(CMC).contracts("Storage")).allowance(owner, spender);
    }

    function transfer(address to, uint256 value) isCMCEnabled("Unitarium") external returns (bool) {
        Storage(ContractProvider(CMC).contracts("Storage")).transfer(to, value);
    }

    function approve(address spender, uint256 value) isCMCEnabled("Unitarium") external returns (bool) {
        Storage(ContractProvider(CMC).contracts("Storage")).approve(spender, value);
    }

    function transferFrom(address from, address to, uint256 value) isCMCEnabled("Unitarium") external returns (bool) {
        Storage(ContractProvider(CMC).contracts("Storage")).transferFrom(from, to, value);
    }

    function mint(address account, uint256 amount) isCMCEnabled("Unitarium") external view returns (bool) {
        Storage(ContractProvider(CMC).contracts("Storage")).mint(account, amount);
    }

    function addJob(address job) isCMCEnabled("Unitarium") external returns (bool) {
        Storage(ContractProvider(CMC).contracts("Storage")).addJob(job);
    }

    function getJobsFromPublisher(address _publisher) isCMCEnabled("Unitarium") external view returns (address[]) {
        Storage(ContractProvider(CMC).contracts("Storage")).getJobsFromPublisher(_publisher);
    }

    function getPublisherFromJob(address _job) isCMCEnabled("Unitarium") external view returns (address) {
        Storage(ContractProvider(CMC).contracts("Storage")).getPublisherFromJob(_job);
    }

    function getRewardsAddress() isCMCEnabled("Unitarium") external view returns (address) {
        Storage(ContractProvider(CMC).contracts("Storage")).getRewardsAddress();
    }
}