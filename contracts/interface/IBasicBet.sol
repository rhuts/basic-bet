pragma solidity ^0.5.0;

/**
 * Interface describing the basic features required for a betting contract.
 *
 * Contracts implementing this interface must expose their status:
 *      isOpen()                            returns true if bets may be placed
 *      isClosed()                          returns true if bets cannot be placed and the event outcome can be set
 *      isFinalized()                       returns true if won/lost funds can be distributed to the winners/losers
 *
 * Contracts implementing this interface must also have the following features:
 *      addBet(uint256 choice)              place a bet on a choice and send the bet amout in value
 *      finalizeEvent(uint256 result)       set the outcome of the betting event
 *      releaseFunds()                      release the funds to the winners/losers
 */
interface IBasicBet {
    function isOpen() external view returns (bool);
    function isClosed() external view returns (bool);
    function isFinalized() external view returns (bool);
    function addBet(uint256 choice) external payable;
    function finalizeEvent(uint256 result) external;
    function releaseFunds() external;
}