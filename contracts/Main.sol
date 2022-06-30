//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
//import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Main is Ownable {
    using SafeERC20 for IERC20;
    string private greeting;
    IERC20 public iris;
    IERC20 public xhrms;
    event Convert(address user, uint amount);
    constructor(address _iris, address _xhrms) {
        iris = IERC20(_iris);
        xhrms = IERC20(_xhrms);
    }
    function withdrawTokens(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
        IERC20(_tokenAddress).safeTransfer(address(msg.sender), _tokenAmount);
    }
    function convert(uint256 amount) external {
        iris.safeTransferFrom(address(msg.sender), address(0x000000000000000000000000000000000000dEaD), amount);
        xhrms.safeTransfer(address(msg.sender), amount);
        emit Convert(msg.sender, amount);
    }
}
