// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0;

import "@lukso/lsp-smart-contracts/contracts/LSP7DigitalAsset/LSP7DigitalAsset.sol";

contract SymbolAward is LSP7DigitalAsset {

  // --- ATTRIBUTES

  /**
   * @notice This attribute stores the timestamp of the last awarded symbol.
   */
  mapping (address => uint) private lastTimeSymbolWasGiven;

  /**
   * @notice Instance of the token, whoose holders can give symbols.
   */
  LSP7DigitalAsset private mustHoldToken;

  /**
   * @notice Constant address of the multisig.
   */
  address constant MULTISIG = 0x6A0e62776530d9F9B73463F20e34D0f9fe5FEED1;

  // --- CONSTRUCTOR

  /**
   * @notice Creates a new LSP7 token and saves the must hold token instance.
   */
  constructor(
    address LSP7Address,
    string memory _name,
    string memory _symbol,
    address _newOwner,
    bool _isNFT
  ) LSP7DigitalAsset(_name, _symbol, _newOwner, _isNFT) {
    mustHoldToken = LSP7DigitalAsset(LSP7Address);
  }

  // --- MODIFIERS

  /**
   * @notice Verifies that the last awarded symbol timestamp is older than 24h.
   */
  modifier symbolGiven24hAgo(address universalProfileAddress) {
    require(
      lastTimeSymbolWasGiven[universalProfileAddress] + 1 days <= block.timestamp,
      "Universal Profile has given a symbol less than 1 day ago."
    );
    _;
  }

  /**
   * @notice Verifies that the address owns the `token`.
   */
  modifier ownsToken(address universalProfileAddress) {
    require(
      mustHoldToken.balanceOf(universalProfileAddress) >= 1,
      "Universal Profile doesn't hold any tokens."
    );
    _;
  }

  /**
   * @notice Verifing that the `msg.sender` is the multisig address.
   */
  modifier senderIsMultisig(address _address) {
    require(
      _address == MULTISIG,
      "msg.sender is not the multisig address."
    );
    _;
  }

  // --- GETTERS & SETTERS

  /**
   * @notice Update the latest awarded symbol timestamp.
   *
   * @param universalProfileAddress The address of the Universal Profile whoose last awarded symbol timestamp is updated.
   */
  function _updateLastTime(address universalProfileAddress) private {
    lastTimeSymbolWasGiven[universalProfileAddress] = block.timestamp;
  }

  /**
   * @notice Getter of the last awarded symbol timestamp.
   *
   * @param universalProfileAddress The address of the Universal Profile whoose last awarded symbol timestam we are getting.
   */
  function getLastTime(address universalProfileAddress) external view returns(uint) {
    return lastTimeSymbolWasGiven[universalProfileAddress];
  }

  // --- GENERAL METHODS

  /**
   * @notice Award a symbol reputation token to a Universal Profile.
   */
  function mint(
    address universalProfileAddress,
    address awardedUniversalProfileAddress,
    uint amount,
    bool force,
    bytes memory data
  )
    public
    ownsToken(universalProfileAddress)
    symbolGiven24hAgo(universalProfileAddress)
  {
    _mint(awardedUniversalProfileAddress, amount, force, data);
  }

  /**
   * @notice Making transfer available only to multisig.
   */
  function transfer(
        address from,
        address to,
        uint256 amount,
        bool force,
        bytes memory data
    ) public virtual override senderIsMultisig(msg.sender) {
      _transfer(from, to, amount, force, data);
    }

}