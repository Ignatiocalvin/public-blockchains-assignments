// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Easy creation of ERC20 tokens.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Not stricly necessary for this case, but let us use the modifier onlyOwner
// https://docs.openzeppelin.com/contracts/5.x/api/access#Ownable
import "@openzeppelin/contracts/access/Ownable.sol";

// This allows for granular control on who can execute the methods (e.g., 
// the validator); however it might fail with our validator contract!
// https://docs.openzeppelin.com/contracts/5.x/api/access#AccessControl
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

// import "hardhat/console.sol";

// Import BaseAssignment.sol to inherit functions such as isValidator()
import "../BaseAssignment.sol";

contract CensorableToken is ERC20, Ownable, BaseAssignment, AccessControl {

    // Add state variables and events here.
    mapping(address => bool) public isBlacklisted;
    // Emits an event shows us how many times the blacklisted function has been called
    event Blacklisted(address indexed account);
    // Emits an event shows us how many times the unblacklisted function has been called
    event UnBlacklisted(address indexed account);

    // Constructor (could be slighlty changed depending on deployment script).
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply, address _initialOwner)
        BaseAssignment(0xc4b72e5999E2634f4b835599cE0CBA6bE5Ad3155) 
        ERC20(_name, _symbol)
        Ownable(_initialOwner)
    {
        // Mint N > 10 tokens for the contract owner and 10 tokens for the validator
        _mint(_initialOwner, _initialSupply * 10**18); // Mint initial tokens for the owner that we supply on the constructor
        _mint(0xc4b72e5999E2634f4b835599cE0CBA6bE5Ad3155, 10 * 10**18); // Mint 10 tokens for the validator
       
        // Give the validator an allowance over the tokens of the owner equal to token currently held by owner.
        // This is a simple way to allow the validator to transfer tokens on behalf of the owner.
        // Hint: use the `approve` method from the ERC20 standard.
        // See: https://docs.openzeppelin.com/contracts/5.x/api/token/erc20#IERC20-approve-address-uint256-
        approve(0xc4b72e5999E2634f4b835599cE0CBA6bE5Ad3155, balanceOf(_initialOwner));

    }


    // Function to blacklist an address
    function blacklistAddress(address _account) public  {
       
       // Note: if AccessControl fails the validation on the (not)UniMa Dapp
       // you can use a simpler approach, requiring that msg.sender is 
       // either the owner or the validator.
       // Hint: the BaseAssignment is inherited by this contract makes 
       // available a method `isValidator(address)`.
         // See: https://docs.openzeppelin.com/contracts/5.x/api/access#AccessControl
        require(isValidator(msg.sender) || msg.sender == owner(), "Caller is not an Owner or Validator");
        // Blacklistings are stored in mapping(address => bool) isBlacklisted.
        isBlacklisted[_account] = true;
    }

    // Function to remove an address from the blacklist
    function unblacklistAddress(address _account) public  {
        require(isValidator(msg.sender) || msg.sender == owner(), "Caller is not an Owner or Validator");
        // Blacklistings are stored in mapping(address => bool) isBlacklisted.
        isBlacklisted[_account] = false;
    }

    // Override the transfer function to include the blacklist check
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(!isBlacklisted[msg.sender], "Sender is blacklisted");
        require(!isBlacklisted[recipient], "Recipient is blacklisted");
        // goes to the original transfer function from ERC20
        return super.transfer(recipient, amount);
    }

    
    // There are multiple approaches here. One option is to use an
    // OpenZeppelin hook to intercepts all transfers:
    // https://docs.openzeppelin.com/contracts/5.x/api/token/erc20#ERC20

    // This can also help:
    // https://blog.openzeppelin.com/introducing-openzeppelin-contracts-5.0
}
