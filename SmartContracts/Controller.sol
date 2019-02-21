pragma solidity ^0.4.0;

import "./CMCEnabled.sol";
import "./Storage.sol";


contract Controller is CMCEnabled {

    function totalSupply() isCMCEnabled("UserEntry") external view returns (uint256) {
        Storage(ContractProvider(CMC).contracts("Storage")).totalSupply();
    }

    function balanceOf(address owner) isCMCEnabled("UserEntry") external view returns (uint256) {
        Storage(ContractProvider(CMC).contracts("Storage")).balanceOf(owner);
    }

    function allowance(address owner, address spender) isCMCEnabled("UserEntry") external view returns (uint256) {
        Storage(ContractProvider(CMC).contracts("Storage")).allowance(owner, spender);
    }

    function transfer(address to, uint256 value) isCMCEnabled("UserEntry") external returns (bool) {
        Storage(ContractProvider(CMC).contracts("Storage")).transfer(to, value);
    }

    function approve(address spender, uint256 value) isCMCEnabled("UserEntry") external returns (bool) {
        Storage(ContractProvider(CMC).contracts("Storage")).approve(spender, value);
    }

    function transferFrom(address from, address to, uint256 value) isCMCEnabled("UserEntry") external returns (bool) {
        Storage(ContractProvider(CMC).contracts("Storage")).transferFrom(from, to, value);
    }

    function mint(address account, uint256 amount) isCMCEnabled("UserEntry") external view returns (bool) {
        Storage(ContractProvider(CMC).contracts("Storage")).mint(account, amount);
    }

    function addJob(address job) isCMCEnabled("UserEntry") external returns (bool) {
        Storage(ContractProvider(CMC).contracts("Storage")).addJob(job);
    }

    function getJobsFromPublisher(address _publisher) isCMCEnabled("UserEntry") external view returns (address[]) {
        Storage(ContractProvider(CMC).contracts("Storage")).getJobsFromPublisher(_publisher);
    }

    function getPublisherFromJob(address _job) isCMCEnabled("UserEntry") external view returns (address) {
        Storage(ContractProvider(CMC).contracts("Storage")).getPublisherFromJob(_job);
    }

    function getRewardsAddress() isCMCEnabled("UserEntry") external view returns (address) {
        Storage(ContractProvider(CMC).contracts("Storage")).getRewardsAddress();
    }
}