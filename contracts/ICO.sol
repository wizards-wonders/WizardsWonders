pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./TransferHelper.sol";
import "hardhat/console.sol";

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract ICO is AccessControl, Pausable, ReentrancyGuard {
    using SafeMath for uint256;

    event TransferInToken(uint256 amount, uint256 totalSupply);
    event Sell(address indexed user, uint256 amount);

    bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");

    struct PriceInterval {
        uint256 intervalEnd;
        uint256 price;
    }

    uint256 public totalSupply;
    uint256 public saleTokenAmount;
    PriceInterval[] public priceInterval;
    IERC20 public token;
    IERC20 public payToken;

    modifier onlyOwner() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "ICO: NOT_OWNER_MEMBER");
        _;
    }

    constructor(IERC20 _token, IERC20 _payToken, PriceInterval[] memory _priceInterval) public {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        token = _token;
        payToken = _payToken;
        _setPriceInterval(_priceInterval);
    }

    function tokensAvailable() public view returns(uint256) {
        return token.balanceOf(address(this));
    }

    function transferInToken(uint256 _amount) public onlyOwner {
        TransferHelper.safeTransferFrom(address(token), msg.sender, address(this), _amount);
        totalSupply = totalSupply.add(_amount);
        emit TransferInToken(_amount, totalSupply);
    }

    function buyTokens(uint256 _amount) public nonReentrant payable {
        uint256 total = calcTokenPrice(saleTokenAmount, _amount);
        require(_amount <= tokensAvailable(), "ICO: NOT_ENOUGH_TOKEN");

        _pay(total);

        TransferHelper.safeTransfer(address(token), msg.sender, _amount);
        saleTokenAmount = saleTokenAmount.add(_amount);

        emit Sell(msg.sender, _amount);
    }

    function calcTokenPrice(uint256 _saleTokenAmount, uint256 _amount) public view returns(uint256) {
        uint256 total;
        uint256 startIndex = priceInterval.length-1;
        uint256 endIndex = priceInterval.length-1;
        for (uint256 i=priceInterval.length-1; i>=0; i--) {
            if (_saleTokenAmount <= priceInterval[i].intervalEnd) {
                startIndex = i;
            }
            if (_saleTokenAmount.add(_amount) <= priceInterval[i].intervalEnd) {
                endIndex = i;
            }
            if (i==0) {
                break;
            }
        }
        if (startIndex == endIndex) {
            total = _amount.mul(priceInterval[startIndex].price).div(1e18);
            return total;
        }
        for (uint256 i=startIndex; i<=endIndex; i++) {
            if (i == startIndex) {
                total = total.add(
                    priceInterval[i].intervalEnd.sub(_saleTokenAmount).mul(priceInterval[i].price).div(1e18)
                );
            } else if (i == endIndex) {
                total = total.add(
                    _saleTokenAmount.add(_amount).sub(priceInterval[i-1].intervalEnd).mul(priceInterval[i].price).div(1e18)
                );
            } else {
                total = total.add(
                    priceInterval[i].intervalEnd.sub(priceInterval[i-1].intervalEnd).mul(priceInterval[i].price).div(1e18)
                );
            }
        }
        return total;
    }

    function getPriceIntervalLength() public view returns(uint256) {
        return priceInterval.length;
    }

    function setPriceInterval(PriceInterval[] memory _priceInterval) public onlyOwner {
        _setPriceInterval(_priceInterval);
    }

    function endSale() public onlyOwner {
        uint256 amount = tokensAvailable();
        TransferHelper.safeTransfer(address(token), msg.sender, amount);

        if (address(payToken) == address(1)) {
            uint256 value = address(this).balance;
            (bool success,) = msg.sender.call{value:value}(new bytes(0));
            require(success, 'ICO: WITHDRAW_ABEY_FAILED');
        } else {
            uint256 payTokenBalance = payToken.balanceOf(address(this));
            TransferHelper.safeTransfer(address(payToken), msg.sender, payTokenBalance);
        }
    }

    function withdrawal() public onlyOwner {
        uint256 value = address(this).balance;
        (bool success,) = msg.sender.call{value:value}(new bytes(0));
        require(success, 'ICO: WITHDRAW_FAILED');
    }

    function setPayToken(IERC20 _payToken) public onlyOwner {
        payToken = _payToken;
    }

    function _setPriceInterval(PriceInterval[] memory _priceInterval) internal {
        for(uint256 i=0; i<_priceInterval.length; i++){
            priceInterval.push(_priceInterval[i]);
        }
    }

    function _pay(uint256 _amount) internal {
        if (address(payToken) == address(1)) {
            require(msg.value >= _amount, "ICO: NOT_ENOUGH_VALUE");

            uint256 remainingValue = msg.value.sub(_amount);
            if (remainingValue > uint256(0)) {
                msg.sender.transfer(remainingValue);
            }
        } else {
            TransferHelper.safeTransferFrom(address(payToken), msg.sender, address(this), _amount);
        }
    }
}
