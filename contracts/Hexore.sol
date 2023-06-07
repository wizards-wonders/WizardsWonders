pragma solidity ^0.6.0;
// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Hexore is ERC20, AccessControl {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    modifier onlyMinter() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(MINTER_ROLE, msg.sender), "Hexore: NOT_MINTER_MEMBER");
        _;
    }

    modifier onlyBurner() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(BURNER_ROLE, msg.sender), "Hexore: NOT_BURNER_MEMBER");
        _;
    }

    //constructor() public ERC20("Hexore", "XORE") {
    constructor() public ERC20("HexoreTest", "XORET") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);

        _setRoleAdmin(MINTER_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(BURNER_ROLE, DEFAULT_ADMIN_ROLE);
    }

    function mint(address to, uint256 amount) public onlyMinter {
        _mint(to, amount);
    }

    function burn(address to, uint256 amount) public onlyBurner {
        _burn(to, amount);
    }
}
