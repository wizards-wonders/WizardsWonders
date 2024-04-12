pragma solidity ^0.6.0;
// SPDX-License-Identifier: MIT

interface IWizardsWonders {
    enum RarityType {None, Boring, Fancy, SuperFancy}
    enum carType {None, CoreSet, Commander, Wonder, ActionCard, Unit}

    function safeTransferFrom(address from, address to, uint256 tokenId) external returns (bool);
    function safeMint(
        address to_, 
        string memory  tokenHash_,
        string memory Series_,
        string memory Type_,
        string memory Rarity_,
        string memory Faction_,
        uint256  PointValue_,
        bool OP_
        ) external;

    function ownerOf(string memory tokenHash_) external view returns(address);
    function transferFrom(address from_, address to_, string memory tokenHash_) external ;
}