pragma solidity ^0.5.0;

import "../installed_contracts/zeppelin/contracts/ownership/Ownable.sol";

contract BasicBet is Ownable {
    // user A
    address payable private _userA;
    bool private _choiceA;

    // user B
    address payable private _userB;
    bool private _choiceB;

    // zero address
    address constant private ZERO_ADDRESS = 0x0000000000000000000000000000000000000000;

    // constant bet amount
    uint256 constant BET_AMOUNT = 1 ether;

    // result
    bool private _result = false;

    // bet status
    enum BetStatus {Open, Closed, Finalized}
    BetStatus public _status;
    BetStatus public constant defaultStatus = BetStatus.Open;

    /**
     *
     */
    constructor() public {
        _status = defaultStatus;
    }

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

    function addBet(bool choice) public payable onlyOpen {
        // enforce bet amount
        require(msg.value == BET_AMOUNT, "Fixed bet amount of 1 ether");
        if (_userA == ZERO_ADDRESS) {
            // place bet as userA
            _userA = msg.sender;
            _choiceA = choice;
        }
        else if (_userB == ZERO_ADDRESS)
        {
            // place bet as userB
            _userB = msg.sender;
            _choiceB = choice;
        }
        else
        {
            // both players have placed bets, close the betting
            _status = BetStatus.Closed;
        }
    }

    function finalizeEvent(bool result) public onlyOwner onlyClosed {
        _status = BetStatus.Finalized;
        _result = result;
    }

    function releaseFunds() public onlyOwner onlyFinalized {

        // refund when there is no single winner
        if (_choiceA == _choiceB) {
            _userA.transfer(BET_AMOUNT);
            _userB.transfer(BET_AMOUNT);
        }
        else
        {
            if (_choiceA == _result) {
                _userA.transfer(address(this).balance);
            }
            else
            {
                _userB.transfer(address(this).balance);
            }
        }

        // send ether
    }
}