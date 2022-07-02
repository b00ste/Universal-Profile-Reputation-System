// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0;

import "@lukso/lsp-smart-contracts/contracts/LSP7DigitalAsset/LSP7DigitalAsset.sol";
import "@lukso/lsp-smart-contracts/contracts/LSP7DigitalAsset/ILSP7DigitalAsset.sol";

/**
 * @title ReactionToken
 * @author B00ste
 * @custom:version 0.4
 */
contract ReactionToken is LSP7DigitalAsset {

  // --- ATTRIBUTES

  /**
   * @notice This attribute stores the timestamp of the last given reaction.
   */
  mapping (address => uint) private lastTimeReactionWasGiven;

  /**
   * @notice Instance of the token, whoose holders can give rections and recieve reactions.
   */
  LSP7DigitalAsset private pinkPill;

  /**
   * @notice Instance of the token, whoose holders can recieve reactions.
   */
  ILSP7DigitalAsset private greenPill;

  /**
   * @notice Constant address of the multisig.
   */
  address constant MULTISIG = 0x6A0e62776530d9F9B73463F20e34D0f9fe5FEED1;

  /**
   * @notice The address of the UniversalProfileReputationSystem smart contract.
   */
  address private universalProfileReputationSystem;

  /**
   * @notice The number of the reaction.
   */
  uint private reactionNumber;

  // --- CONSTRUCTOR

  /**
   * @notice Creates a new LSP7 token and saves the must hold token instances and the participationToken token instance.
   *
   * @param _reactionNumber Hardcoded number that identifies a reaction. A reaction's index.
   * @param pinkPillAddress The address of the Pink Pill LSP7. This is a must have to react and recieve reactions.
   * @param greenPillAddress The address of the Pink Pill LSP7. This is a must to recieve reactions.
   * @param _name The name of this token.
   * @param _symbol The symbol of this token.
   * @param _newOwner The owner of this token.
   * @param _isNFT Boolean upon which is decided if this token is an NFT. It is hardcoded to `true`.
   */
  constructor(
    uint _reactionNumber,
    address _universalProfileReputationSystem,
    address pinkPillAddress,
    address greenPillAddress,
    string memory _name,
    string memory _symbol,
    address _newOwner,
    bool _isNFT
  ) LSP7DigitalAsset(_name, _symbol, _newOwner, _isNFT) {
    pinkPill = LSP7DigitalAsset(pinkPillAddress);
    greenPill = LSP7DigitalAsset(greenPillAddress);
    reactionNumber = _reactionNumber;
    universalProfileReputationSystem = _universalProfileReputationSystem;
  }

  // --- EVENTS

  event userReactedToWith(address universalProfileAddress, address awardedUniversalProfileAddress, uint symbolNumber);

  // --- MODIFIERS

  /**
   * @notice Verifies that the last awarded symbol timestamp is older than 24h. The verification is skipped
   * if the tokenNumber is 5 because that is the participationToken which is awarded whenever you give a reaction.
   * 
   * @param universalProfileAddress The address of the Universal Profile that is checked.
   */
  modifier reactionGiven24hAgo(address universalProfileAddress) {
    require(
      lastTimeReactionWasGiven[universalProfileAddress] + 1 days <= block.timestamp || reactionNumber == 5,
      "Universal Profile has given a symbol less than 1 day ago."
    );
    _;
  }

  /**
   * @notice Verifies that the address owns the Pink Pill.
   * 
   * @param universalProfileAddress The address of the Universal Profile that is checked.
   */
  modifier ownsPinkPill(address universalProfileAddress) {
    require(
      pinkPill.balanceOf(universalProfileAddress) >= 1,
      "Universal Profile doesn't hold any tokens."
    );
    _;
  }

  /**
   * @notice Verifies that the address owns either the Pink Pill or the Green Pill.
   * 
   * @param universalProfileAddress The address of the Universal Profile that is checked.
   */
  modifier ownsPinkOrGreenPill(address universalProfileAddress) {
    require(
      (pinkPill.balanceOf(universalProfileAddress) >= 1) ||
      (greenPill.balanceOf(universalProfileAddress) >= 1),
      "Universal Profile doesn't hold any tokens."
    );
    _;
  }

  /**
   * @notice Verifing that the `msg.sender` is the multisig address.
   * 
   * @param _address The address that is checked.
   */
  modifier senderIsMultisig(address _address) {
    require(
      _address == MULTISIG,
      "msg.sender is not the multisig address."
    );
    _;
  }

  /**
   * @notice Verifing that the `msg.sender` is `universalProfileReputationSystem`
   */
  modifier onlyUniversalProfileReputationSystem() {
    require(
      msg.sender == universalProfileReputationSystem,
      "msg.sender isnt Universal Profile Reputation System"
    );
    _;
  }

  // --- GETTERS & SETTERS

  /**
   * @notice Update the latest given reaction timestamp.
   *
   * @param universalProfileAddress The address of the Universal Profile whoose last given reaction timestamp is updated.
   */
  function _updateLastTime(address universalProfileAddress) private {
    lastTimeReactionWasGiven[universalProfileAddress] = block.timestamp;
  }

  /**
   * @notice Getter of the last given reaction timestamp.
   *
   * @param universalProfileAddress The address of the Universal Profile whoose last given reaction timestam we are getting.
   */
  function getLastTime(address universalProfileAddress) external view returns(uint) {
    return lastTimeReactionWasGiven[universalProfileAddress];
  }

  // --- GENERAL METHODS

  /**
   * @notice Give a Reaction Token to a Universal Profile and a Participation Token back.
   *
   * @param universalProfileAddress The address of the Universal Profile that gives a reaction.
   * @param awardedUniversalProfileAddress The address of the Universal profile that recieves the reaction.
   * @param amount The amount of reactions given. Hardoced to `1`.
   * @param force a
   * @param data a
   */
  function mint(
    address universalProfileAddress,
    address awardedUniversalProfileAddress,
    uint amount,
    bool force,
    bytes memory data
  )
    external
    ownsPinkPill(universalProfileAddress)
    ownsPinkOrGreenPill(awardedUniversalProfileAddress)
    reactionGiven24hAgo(universalProfileAddress)
    onlyUniversalProfileReputationSystem()
  {
    _mint(awardedUniversalProfileAddress, amount, force, data);
    _updateLastTime(universalProfileAddress);

    emit userReactedToWith(universalProfileAddress, awardedUniversalProfileAddress, reactionNumber);
  }

  /**
   * @notice Making transfer available only to multisig.
   *
   * @inheritdoc ILSP7DigitalAsset
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