// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface ITOKEN {
    event AddMinter(address indexed _minter);
    event RemoveMinter(address indexed _minter);
    event AddTrader(address indexed _trader);
    event RemoveTrader(address indexed _trader);
    

    function mint(address account, uint256 amount) external;

    function addMinter(address _minter) external;
    function removeMinter(address _minter) external;


}

contract USDTTest is ITOKEN, ERC20 {
    

    mapping(address => bool) public minters;

    constructor(uint256 _initialSupply) public ERC20("USDTTest", "USDTTest"){
        _mint(msg.sender, _initialSupply);
    }

    function mint(address account, uint256 amount) public override {
        require(minters[msg.sender], "!minter");

        _mint(account, amount);
    }

    function addMinter(address _minter) external override  {
        require(_minter != address(0), "ZERO_ADDRESS");

        minters[_minter] = true;
        emit AddMinter(_minter);
    }

    function removeMinter(address _minter) external override  {
        require(_minter != address(0), "ZERO_ADDRESS");

        minters[_minter] = false;
        emit RemoveMinter(_minter);
    }



    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        
        return ERC20.transfer(to, amount);
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        
        return ERC20.transferFrom(from, to, amount);
    }
    
    function burn(address account,uint256 amount)public {
        _burn(account,amount);
    }
}