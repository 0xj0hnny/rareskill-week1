## Question:
**What problems ERC777 and ERC1363 solves. Why was ERC1363 introduced, and what issues are there with ERC777?**

Both ERC777 and ERC1363 standard are derivatives of the ERC20 standard. They are both designed to improve upon the funcationality and usability of ERC20 token. They are also backward compatible with ERC20 standard. 

## ERC777

### pros:
ERC777 resolves several limitations of the ERC20 standard. Notably, it addresses the inability for contracts to initiate token transfers and the lack of notifications when tokens are received. These issues are tackled through the introduction of the `tokenReceived` hook. In traditional ERC20 token transfers, users must execute two separate transactions, approve and transfer, before spending tokens on third-party decentralized applications (dApps). ERC777 simplifies this process by enabling users to send tokens to third-party dApps in a single transaction, thanks to the `tokenReceived` hook. To implement ERC777, a contract must register its address using ERC-1820's `setInterfaceImplementer` function.

### cons:
One significant concern with the ERC777 standard is the susceptibility to reentrancy attacks if not handled cautiously. A notable instance of this vulnerability occurred in the imBTC Uniswap pool a few years ago, resulting in fund depletion due to a reentrancy attack. This vulnerability stems from the fact that the hook in ERC777 calls an external contract, opening the door for potential exploitation. However, this risk can be minimized through various measures such as implementing reentrancy guards or adopting the check-effects-interaction design pattern. These strategies help fortify contracts against reentrancy attacks by ensuring that state changes are finalized before interacting with external contracts, thereby mitigating the risk of malicious exploitation.

## ERC1363
ERC1363 addresses a significant gap in the ERC20 standard by introducing a transfer notification mechanism through the transfer hook. Contracts seeking notification of token transfers must implement the `IERC1363Receiver` function. 

### pros:
One notable advantage of ERC1363 over ERC777 is its effective mitigation of the reentrancy problem introduced by ERC777. This is achieved by preserving the standard ERC20 functions transfer and transferFrom without alterations. Transfer hooks are invoked exclusively in functions explicitly designed for such calls, like `transferAndCall` and `transferFromAndCall`. Additionally, receivers are not required to register their addresses in the ERC-1820 registry, resulting in reduced gas costs.
