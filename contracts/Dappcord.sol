// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Dappcord is ERC721 {
    struct Channel {
        uint id;
        string name;
        uint cost;
    }
    address public owner;
    uint public totalChannels;
    uint public totalSupply;
    mapping(uint => Channel) public channels;
    mapping(uint => mapping(address => bool)) public hasJoined;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not owner");
        _;
    }

    // why memory cost is not there?
    function createChannel(string memory _name, uint _cost) public onlyOwner {
        totalChannels++;
        channels[totalChannels] = Channel(totalChannels, _name, _cost);
    }

    function getChnnel(uint id) public view returns (Channel memory) {
        return channels[id];
    }

    function mint(uint id) public payable {
        hasJoined[id][msg.sender] = true;
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
    }

    function withdraw() public onlyOwner {
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }
}
