pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value : value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}

interface IERC721 {
    function safeTransferFrom(address from, address to, uint256 tokenId) external returns (bool);
}

contract LootBox is AccessControl, Pausable  {
    using SafeMath for uint256;

    enum TokenType {ERC20, ERC721}
    enum Status {None, Valid, Opened}

    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");
    bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");

    uint256 public totalNum;
    uint256 public openedNum;
    uint256 public contentNum;

    struct LootContent {
        address asset;
        TokenType tokenType;
        uint256 tokenId;
        uint256 tokenAmount;
    }

    struct LootBoxWrapper {
        uint256[] lootContentIds;
        Status status;
    }

    mapping(uint256 => LootContent) public lootContentMapping;
    mapping(uint256 => LootBoxWrapper) public lootBoxMapping;

    modifier onlyOwner() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "LootBox: NOT_OWNER_MEMBER");
        _;
    }

    modifier onlyCreator() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(CREATOR_ROLE, msg.sender), "LootBox: NOT_CREATOR_MEMBER");
        _;
    }

    constructor() public {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setRoleRule();
    }

    // Create loot in bulk
    function createLootBox(
        LootContent[][] memory contents
    ) public onlyCreator {
        for(uint256 i=0; i<contents.length; i++) {
            totalNum.add(1);
            uint256[] memory lootContentIds = new uint256[](contents[i].length);

            for(uint256 j=0; i<contents[i].length; j++) {
                contentNum.add(1);
                LootContent memory lootContent = contents[i][j];
                lootContentMapping[contentNum] = lootContent;
                if (lootContent.tokenType == TokenType.ERC20) {
                    TransferHelper.safeTransferFrom(lootContent.asset, msg.sender, address(this), lootContent.tokenAmount);
                } else {
                    require(
                        IERC721(lootContent.asset).safeTransferFrom(msg.sender, address(this), lootContent.tokenId),
                        "LootBox: TRANSFER_FROM_FAILED"
                    );
                }
                lootContentIds[j] = contentNum;
            }

            lootBoxMapping[totalNum] = LootBoxWrapper({
                lootContentIds: lootContentIds,
                status: Status.Valid
            });
        }
    }

    function _setRoleRule() internal {
        _setRoleAdmin(CREATOR_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(PAUSE_ROLE, DEFAULT_ADMIN_ROLE);
    }
}
