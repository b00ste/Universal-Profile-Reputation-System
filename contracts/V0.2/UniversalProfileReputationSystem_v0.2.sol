// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@lukso/lsp-smart-contracts/contracts/LSP7DigitalAsset/ILSP7DigitalAsset.sol";
import "./ReactionToken.sol";

/**
 * @title UniversalProfileReputationSystem
 * @author B00ste
 * @custom:version 0.3
 */
contract UniversalProfileReputationSystem {

  // Defining the address set.
  using EnumerableSet for EnumerableSet.AddressSet;

  // --- ATTRIBUTES

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
   * @notice This array holds the 5 reaction instances that can be given to an Universal Profile.
   */
  ReactionToken[5] private reactions = [reaction1, reaction2, reaction3, reaction4, reaction5];

  /**
   * @notice The constructor saves a instance of the token at a certain address and creates 5 reaction tokens that will be awarded further.
   */
  constructor(address pinkPillAddress, address greenPillAddress) {
    pinkPill = ILSP7DigitalAsset(pinkPillAddress);
    greenPill = ILSP7DigitalAsset(greenPillAddress);

    //6th reaction awarded back for reacting. Tracks individuals participation.
    participationReaction = new ReactionToken(
      5,
      address(0),
      pinkPillAddress,
      greenPillAddress,
      unicode"🎟",
      unicode"🎟",
      msg.sender,
      true
    );

    // Reaction Token initaited.
    reaction1 = new ReactionToken(
      0,
      address(participationReaction),
      pinkPillAddress,
      greenPillAddress,
      unicode"😡",
      unicode"😡",
      msg.sender,
      true
    );
    reaction2 = new ReactionToken(
      1,
      address(participationReaction),
      pinkPillAddress,
      greenPillAddress,
      unicode"👎",
      unicode"👎",
      msg.sender,
      true
    );
    reaction3 = new ReactionToken(
      2,
      address(participationReaction),
      pinkPillAddress,
      greenPillAddress,
      unicode"👍",
      unicode"👍",
      msg.sender,
      true
    );
    reaction4 = new ReactionToken(
      3,
      address(participationReaction),
      pinkPillAddress,
      greenPillAddress,
      unicode"👏",
      unicode"👏",
      msg.sender,
      true
    );
    reaction5 = new ReactionToken(
      4,
      address(participationReaction),
      pinkPillAddress,
      greenPillAddress,
      unicode"💚",
      unicode"💚",
      msg.sender,
      true
    );
  }

  // --- MODIFIERS

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

  // --- GETTERS & SETTERS

  /**
   * @notice Getter for the array of reactions.
   */
  function getReactions() external view returns(address[5] memory) {
    return [address(reactions[0]), address(reactions[1]), address(reactions[2]), address(reactions[3]), address(reactions[4])];
  }

  /**
   * @notice Increases the number of reactions of the same type given.
   *
   * @param universalProfileAddress The address of the Universal Profile who will give a reaction.
   * @param awardedUniversalProfileAddress The address of the Universal profile that will be given a reaction.
   * @param reactionNumber The index number of the reaction.
   */
  function _awardSymbol(
    address universalProfileAddress,
    address awardedUniversalProfileAddress,
    uint reactionNumber
  ) private {
    reactions[reactionNumber].mint(universalProfileAddress, awardedUniversalProfileAddress, 1, true, "");
  }

  /**
   * @notice Getter for the number of reactions of the same type given.
   *
   * @param universalProfileAddress The address of the Universal Profile whoose number of the same type of reactions we will get.
   * @param reactionNumber The index number of the reaction.
   */
  function getNumberOfSymbolsRecieved(address universalProfileAddress, uint reactionNumber) external view returns(uint256) {
    return reactions[reactionNumber].balanceOf(universalProfileAddress);
  }

  // --- GENERAL METHODS

  /**
   * @notice Give a reaction to a Universal Profile.
   *
   * @param universalProfileAddress The address of the Universal Profile that gives a reaction.
   * @param awardedUniversalProfileAddress The address of the Universal Profile that will recieve the reaction.
   * @param reactionNumber The index number of the reaction.
   */
  function awardSymbol(
    address universalProfileAddress,
    address awardedUniversalProfileAddress,
    uint reactionNumber
  )
    external
    reactionNumberExists(reactionNumber)
  {
    _awardSymbol(universalProfileAddress, awardedUniversalProfileAddress, symbolNumber);
  }

}