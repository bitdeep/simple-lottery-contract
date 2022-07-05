//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
//import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Main is Ownable {
    using SafeERC20 for IERC20;
    uint public price = 1 ether;
    uint public lottery = 1;
    uint public triggerIndex;
    uint public triggerMax = 10;
    uint public ticket;
    address public lastWinnerAddress;
    uint public lastWinnerTicket;
    uint public lastWinnerTime;
    uint public lastWinnerPremium;
    mapping(uint => uint[]) public ticketsByLottery;
    mapping(uint => address) public userByTicket;
    mapping(uint => mapping(address => uint[])) public ticketsByUser;
    address FEE_RECIPIENT;
    constructor() {
        FEE_RECIPIENT = msg.sender;
    }
    function withdrawTokens(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
        IERC20(_tokenAddress).safeTransfer(address(msg.sender), _tokenAmount);
    }

    function setFeeRecipient(address to) public onlyOwner {
        FEE_RECIPIENT = to;
    }

    function setTriggerMax(uint v) public onlyOwner {
        triggerMax = v;
    }

    function setPrice(uint v) public onlyOwner {
        price = v;
    }

    event OnBuy(address user, uint lottery, uint ticket);

    function buy(uint256 total) external payable {
        require(msg.value >= total * price, "invalid amount set");
        for (uint i = 0; i < total; i ++) {
            ticketsByLottery[lottery].push(ticket);
            ticketsByUser[lottery][msg.sender].push(ticket);
            userByTicket[ticket] = msg.sender;
            triggerIndex++;
            emit OnBuy(msg.sender, lottery, ticket);
            ticket++;
        }
        trigger();
    }

    event OnTrigger(address winner, uint premium, uint ticket, uint lottery);

    function trigger() public {
        if (triggerIndex < triggerMax) {
            return;
        }
        _trigger();
    }

    function adminTrigger() public onlyOwner {
        _trigger();
    }

    function _trigger() internal {
        triggerIndex = 0;

        (uint _previousBlockNumber, bytes32 _previousBlockHash) = moreRand();
        uint total = ticketsByLottery[lottery].length;
        uint256 _mod = total - 1;
        uint256 _randomNumber;
        bytes32 _structHash = keccak256(abi.encode(msg.sender, block.difficulty, gasleft(),
            block.timestamp, _previousBlockNumber, _previousBlockHash));
        _randomNumber = uint256(_structHash);
        assembly {_randomNumber := mod(_randomNumber, _mod)}
        lastWinnerAddress = userByTicket[_randomNumber];
        lastWinnerTicket = _randomNumber;
        lastWinnerTime = block.timestamp;

        uint value = address(this).balance;
        uint fee = value / 10;
        lastWinnerPremium = value - fee;

        lastWinnerAddress.call{value : lastWinnerPremium}("");
        FEE_RECIPIENT.call{value : fee}("");

        emit OnTrigger(lastWinnerAddress, lastWinnerPremium, lastWinnerTicket, lottery);

        lottery++;
    }

    function moreRand() public view returns (uint, bytes32) {
        uint _previousBlockNumber;
        bytes32 _previousBlockHash;
        _previousBlockNumber = uint(block.number - 1);
        _previousBlockHash = bytes32(blockhash(_previousBlockNumber));
        return (_previousBlockNumber, _previousBlockHash);
    }

    function getTicketsByUser(uint lottery, address user) public view returns (uint[] memory) {
        return ticketsByUser[lottery][user];
    }

}
