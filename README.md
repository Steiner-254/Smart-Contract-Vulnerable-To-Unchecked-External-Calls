# Smart-Contract-Vulnerable-To-Unchecked-External-Calls
Smart Contract Vulnerable To Unchecked External Calls

# Description
~ Unchecked External Calls in smart contracts refer to calls made to external contracts without proper validation, potentially leading to security vulnerabilities, reentrancy attacks, and unexpected behavior.

# vulnerable.sol
~ In this example:

1. The delegateCall function allows the owner to delegate arbitrary calls to other contracts. However, there are no checks on the contract being called or the data being passed, making it vulnerable to arbitrary code execution.

2. The withdraw function allows users to withdraw Ether from their balance. However, it uses an unchecked external call to transfer Ether to the user's address, which is a common source of vulnerabilities. If the destination address is a malicious contract, it could re-enter this contract and potentially manipulate the contract's state.

3. The call function is used for external calls, and it returns a boolean indicating the success or failure of the call. However, there are no checks on the return value, and the contract does not revert if the external call fails, making it vulnerable to unexpected failures.

# fix.sol
~ In this updated contract:

1. In the delegateCall function, we added a check to ensure that the target address _to is a contract using the extcodesize assembly function. This prevents accidental or malicious delegation to non-contract addresses.

2. In the withdraw function, we added a check to ensure that the external call for withdrawal (msg.sender.call{value: amount}("")) is successful before updating the user's balance. This prevents a failed withdrawal from leaving the contract in an inconsistent state.

~ These changes help mitigate some of the vulnerabilities in the original contract and make it safer for use. However, always keep in mind that smart contract security is a complex topic, and it's essential to conduct thorough testing and auditing before deploying any contract to a production environment.
