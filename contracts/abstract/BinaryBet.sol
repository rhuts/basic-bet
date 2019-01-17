pragma solidity ^0.5.0;
/**
 * For betting games that have only two choices to bet on.
 */
contract BinaryBet {

    bool public _result = false;

    enum BetStatus {Open, Closed, Finalized}
    BetStatus public _status;

    /**
     * @return true if contract is in the open status.
     */
    function isOpen() public view returns (bool) {
        return _status == BetStatus.Open;
    }

    /**
     * @dev Throws if contract is not open to betting.
     */
    modifier onlyOpen() {
        require(isOpen(), "Betting must be in the open status.");
        _;
    }

    /**
     * @return true if contract is in the closed status.
     */
    function isClosed() public view returns (bool) {
        return _status == BetStatus.Closed;
    }

    /**
     * @dev Throws if contract is not closed to betting.
     */
    modifier onlyClosed() {
        require(isClosed(), "Betting must be in the closed status.");
        _;
    }

    /**
     * @return true if contract is in the finalized status.
     */
    function isFinalized() public view returns (bool) {
        return _status == BetStatus.Finalized;
    }

    /**
     * @dev Throws if contract is not finalized to betting.
     */
    modifier onlyFinalized() {
        require(isFinalized(), "Betting must be in the finalized status.");
        _;
    }

    /**
     * @param choice the choice the better is betting on.
     */
    function addBet(bool choice) public payable;

    /**
     * @param result the result of the betting event.
     */
    function finalizeEvent(bool result) public;

    /**
     * @dev Distribute funds to the winner(s) or provide refund(s) if there are no winners.
     */
    function releaseFunds() public;
}