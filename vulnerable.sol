// Vulnerable Smart Contract
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

        // Vulnerable external call, no checks are performed.
        (bool success, ) = _to.call(_data);
        require(success, "Delegate call failed");
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Not enough balance");

        // Vulnerable external call, no checks are performed.
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Withdrawal failed");

        balances[msg.sender] -= amount;
    }

    receive() external payable {}
}
