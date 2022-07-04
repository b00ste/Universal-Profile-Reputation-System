// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@lukso/lsp-smart-contracts/contracts/LSP7DigitalAsset/ILSP7DigitalAsset.sol";
import "@erc725/smart-contracts/contracts/interfaces/IERC725Y.sol";
import "./ReactionToken.sol";

/**
 * @title UniversalProfileReputationSystem
 * @author B00ste
 * @custom:version 0.6
 */
contract UniversalProfileReputationSystem {

  // Defining the address set.
  using EnumerableSet for EnumerableSet.AddressSet;

  // --- ATTRIBUTES

  /**
   * @notice This attribute stores the timestamp of the last given reaction.
   */
  mapping (address => uint) private lastTimeReactionWasGiven;

  /**
   * @notice Instance of the token, whoose holders can give reactions.
   */
  ILSP7DigitalAsset private pinkPill;

  /**
   * @notice Instance of the token, whoose holders can give reactions.
   */
  ILSP7DigitalAsset private greenPill;

  /**
   * @notice Ctreating 5 instances of reaction tokens to be awarded as reputation.
   */
  ReactionToken reaction1;
  ReactionToken reaction2;
  ReactionToken reaction3;
  ReactionToken reaction4;
  ReactionToken reaction5;
  ReactionToken participationReaction;

  /**
   * @notice This array holds the 6 reaction instances that can be given to an Universal Profile.
   */
  ReactionToken[6] private reactions;

  /**
   * @notice The constructor saves a instance of the token at a certain address and creates 5 reaction tokens that will be awarded further.
   */
  constructor(address pinkPillAddress, address greenPillAddress) {
    pinkPill = ILSP7DigitalAsset(pinkPillAddress);
    greenPill = ILSP7DigitalAsset(greenPillAddress);

    // Reaction Token initaited.
    reaction1 = new ReactionToken(
      0,
      address(this),
      pinkPillAddress,
      greenPillAddress,
      unicode"😡",
      unicode"😡",
      msg.sender,
      true
    );
    reaction2 = new ReactionToken(
      1,
      address(this),
      pinkPillAddress,
      greenPillAddress,
      unicode"👎",
      unicode"👎",
      msg.sender,
      true
    );
    reaction3 = new ReactionToken(
      2,
      address(this),
      pinkPillAddress,
      greenPillAddress,
      unicode"👍",
      unicode"👍",
      msg.sender,
      true
    );
    reaction4 = new ReactionToken(
      3,
      address(this),
      pinkPillAddress,
      greenPillAddress,
      unicode"👏",
      unicode"👏",
      msg.sender,
      true
    );
    reaction5 = new ReactionToken(
      4,
      address(this),
      pinkPillAddress,
      greenPillAddress,
      unicode"💚",
      unicode"💚",
      msg.sender,
      true
    );

    //6th reaction awarded back for reacting. Tracks individuals participation.
    participationReaction = new ReactionToken(
      5,
      address(this),
      pinkPillAddress,
      greenPillAddress,
      unicode"🎟",
      unicode"🎟",
      msg.sender,
      true
    );
    reactions = [reaction1, reaction2, reaction3, reaction4, reaction5, participationReaction];
  }

  // --- MODIFIERS

  /**
   * @notice Verifies that the last awarded symbol timestamp is older than 24h. The verification is skipped
   * if the tokenNumber is 5 because that is the participationToken which is awarded whenever you give a reaction.
   * 
   * @param universalProfileAddress The address of the Universal Profile that is checked.
   */
  modifier reactionGiven24hAgo(address universalProfileAddress) {
    require(
      lastTimeReactionWasGiven[universalProfileAddress] + 1 days <= block.timestamp,
      "Universal Profile has given a symbol less than 1 day ago."
    );
    _;
  }

  /**
   * @notice Verifies that the given number is 0, 1, 2, 3 or 4.
   */
  modifier reactionNumberExists(uint number) {
    require(
      number >= 0 && number <= 4,
      "The provided number has no symbol to represent."
    );
    _;
  }

  /**
   * @notice Custom method for verifying if `msg.sender` has CALL and STATICCALL rights for the Universal Profile.
   */
  function verifyController(address universalProfileAddress) internal view returns(bool) {
    bytes memory key = bytes.concat(
      bytes6(keccak256("AddressPermissions")),
      bytes4(keccak256("Permissions")),
      bytes2(0),
      bytes20(msg.sender)
    );
    bytes memory res = IERC725Y(universalProfileAddress).getData(bytes32(key));

    uint16 full = uint16(bytes2(bytes.concat(res[30], res[31])));

    if ((full & (1 << 4)) + (full & (1 << 5)) == 48) {
      return true;
    }
    else {
      return false;
    }
  }

  /**
   * @notice Verify that the msg.sender is the Univerasal Profile address or one of its controller address with the necessary permissions.
   */
  modifier msgSenderOwnsUniversalProfile(address universalProfileAddress) {
    require(
      msg.sender == universalProfileAddress || verifyController(universalProfileAddress),
      "The msg.sender doesn't have the necessary rights."
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

  /**
   * @notice Getter for the array of reactions.
   */
  function getReactions() external view returns(address[5] memory) {
    return [address(reactions[0]), address(reactions[1]), address(reactions[2]), address(reactions[3]), address(reactions[4])];
  }

  /**
   * @notice Sends a Reaction token to a Universal profile.
   *
   * @param universalProfileAddress The address of the Universal Profile who will give a reaction.
   * @param awardedUniversalProfileAddress The address of the Universal profile that will be given a reaction.
   * @param reactionNumber The index number of the reaction.
   */
  function _giveReaction(
    address universalProfileAddress,
    address awardedUniversalProfileAddress,
    uint reactionNumber
  ) private {
    bytes memory data = bytes.concat(
      bytes4(keccak256('ReactionToken:')),
      bytes2(abi.encodePacked(reactionNumber)),
      bytes20(awardedUniversalProfileAddress),
      bytes20(universalProfileAddress)
    );
    reactions[reactionNumber].mint(universalProfileAddress, awardedUniversalProfileAddress, 1, false, data);
  }

  /**
   * @notice Sends a participation token to a Universal profile.
   *
   * @param universalProfileAddress The address of the Universal Profile who will recieve the Participation Token.
   * @param awardedUniversalProfileAddress The address of the Universal profile that will give the Participation token.
   */
  function _awardParticipationToken(
    address universalProfileAddress,
    address awardedUniversalProfileAddress
  ) private {
    bytes memory data = bytes.concat(
      bytes4(keccak256('ParticipationToken:')),
      bytes2(abi.encodePacked(uint256(5))),
      bytes20(awardedUniversalProfileAddress),
      bytes20(universalProfileAddress)
    );
    participationReaction.mint(awardedUniversalProfileAddress, universalProfileAddress, 1, false, data);
  }

  /**
   * @notice Getter for the number of reactions of the same type given.
   *
   * @param universalProfileAddress The address of the Universal Profile whoose number of the same type of reactions we will get.
   * @param reactionNumber The index number of the reaction.
   */
  function getNumberOfReactionsRecieved(address universalProfileAddress, uint reactionNumber) external view returns(uint256) {
    return reactions[reactionNumber].balanceOf(universalProfileAddress);
  }

  /**
   * @notice Getter for the number of participation tokens awarded.
   *
   * @param universalProfileAddress The address of the Universal Profile whoose number of the same type of reactions we will get.
   */
  function getNumberOfParticipationTokens(address universalProfileAddress) external view returns(uint256) {
    return participationReaction.balanceOf(universalProfileAddress);
  }

  // --- GENERAL METHODS

  /**
   * @notice Give a reaction to a Universal Profile.
   *
   * @param universalProfileAddress The address of the Universal Profile that gives a reaction.
   * @param awardedUniversalProfileAddress The address of the Universal Profile that will recieve the reaction.
   * @param reactionNumber The index number of the reaction.
   */
  function react(
    address universalProfileAddress,
    address awardedUniversalProfileAddress,
    uint reactionNumber
  )
    external
    reactionNumberExists(reactionNumber)
    msgSenderOwnsUniversalProfile(universalProfileAddress)
    reactionGiven24hAgo(universalProfileAddress)
  {
    _giveReaction(universalProfileAddress, awardedUniversalProfileAddress, reactionNumber);
    _awardParticipationToken(awardedUniversalProfileAddress, universalProfileAddress);
    _updateLastTime(universalProfileAddress);
  }

}