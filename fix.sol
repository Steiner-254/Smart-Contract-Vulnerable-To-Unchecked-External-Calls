// Fixed Smart Contract
pragma solidity ^0.8.0;

contract Token {
    mapping(address => uint256) public balances;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function deposit(uint256 amount) external payable {
        require(msg.value == amount, "Please send the exact amount of ether");
        balances[msg.sender] += amount;
    }

    function transfer(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Not enough balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    function delegateCall(address _to, bytes memory _data) external {
        require(msg.sender == owner, "Only owner can delegate calls");

        // Check that the target address is a contract
        uint256 size;
        assembly {
            size := extcodesize(_to)
        }
        require(size > 0, "Target is not a contract");

        // Perform the delegate call
        (bool success, ) = _to.delegatecall(_data);
        require(success, "Delegate call failed");
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Not enough balance");

        // Ensure that the withdrawal is successful before updating the balance
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Withdrawal failed");

        balances[msg.sender] -= amount;
    }

    receive() external payable {}
}
