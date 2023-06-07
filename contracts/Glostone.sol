pragma solidity ^0.6.0;
// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract Glostone is ERC20, AccessControl, Pausable {

    uint256 public constant MAX_SUPPLY = 1e10 * 1e18;

    modifier onlyOwner() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Glostone: NOT_OWNER_MEMBER");
        _;
    }

    //constructor() public ERC20("Glostone", "GLO") {
    constructor() public ERC20("GlostoneTest", "GLOT") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);

        _mint(msg.sender, MAX_SUPPLY);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function transfer(address recipient, uint256 amount) public override whenNotPaused returns (bool) {
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override whenNotPaused returns (bool) {
        return super.transferFrom(sender, recipient, amount);
    }
}
