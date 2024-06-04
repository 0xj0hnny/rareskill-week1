### Question:
**Why does the SafeERC20 program exist and when should it be used?**

 SafeERC20 is a wrapper for ERC20 operations. SafeERC20 is better than normal ERC20 standard is that the SafeERC20 ensure of normal ERC20 calls by checking the boolean value return from ERC20 operations and revert transaction if fail. In addition, it introduces a few additional helper functions to incase / decrease allowance. It helps to mitigate front-running attack that is possible with ERC20's approve() function. 