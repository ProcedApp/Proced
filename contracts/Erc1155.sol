// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract Erc1155 is ERC1155, Ownable, Pausable, ERC1155Burnable, ERC1155Supply {
    using Strings for uint256;

    mapping(address memberContract => bool) public membersContract;

    constructor() ERC1155("www.urlIncreible.com") {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public onlyOwner{
        _mint(account, id, amount, data);
    }

    function drops(address account, uint256 id, uint256 amount, bytes memory data) public {
        require(membersContract[msg.sender], "caller must be a memberContract");
        _mint(account, id, amount, data);
    }

    //todo onlyowner
    function setMemberContractState(address memberContract, bool state) public onlyOwner{
        membersContract[memberContract] = state;
    }

    function uriID(uint256 id) public view returns(string memory) {
        return string(abi.encodePacked(uri(id), id.toString()));
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}