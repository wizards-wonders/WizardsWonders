pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import "./TransferHelper.sol";
import "./interface/IWizardsWonders";

contract LootBoxSetting is AccessControl{

    bytes32 public constant SETTING_ROLE = keccak256("SETTER_ROLE");

    []

    enum carType {None, Commander, Wonder, ActionCard,Unit}

    struct tokenInfo{
        uint256 _tokenID
        string   tokenHash_;
        string  Series_;
        string  Type_;
        string  Rarity_;
        string  Faction_;
        uint256  PointValue_;
        bool OP_;
    }

    modifier onlySetter() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(SETTING_ROLE, msg.sender), "LootBoxSetting: NOT_SETTER");
        _;
    }

    constructor() public {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }



    

}