// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title Challenge
 * @dev A contract that allows participants to commit and reveal answers, and declares a winner based on the revealed answers.
 */
contract Challenge {
    struct User {
        bytes32 commitment;
        address addressUser;
        string answer;
    }
    User[] public users;
    bool public revealPhase;
    address public winner;
    string public winningAnswer;
    address public owner;

    event AnswerRevealed(address indexed participant, string answer);
    event WinnerRevealed(address indexed winner, string winningAnswer);

    /**
     * @dev Initializes the Challenge contract.
     */
    constructor() {
        revealPhase = false;
        owner = msg.sender;
    }

    /**
     * @dev Commit function for participants to submit their hashed answers.
     * @param hash The hash of the participant's answer.
     */
    function commit(bytes32 hash) public {
        require(!revealPhase, "Commit phase is over");
        require(getUser(msg.sender) == -1, "Commitment already made");

        User memory user;
        user.commitment = hash;
        user.addressUser = msg.sender;
        users.push(user);
    }

    /**
     * @dev Reveals the participant's answer and verifies it against the commitment.
     * @param answer The actual answer to be revealed.
     */
    function reveal(string memory answer) public {
        int id = getUser(msg.sender);
        require(revealPhase, "Reveal phase has not started yet");
        require(id != -1, "No commitment found");

        bytes32 answerHash = keccak256(bytes(answer));
        require(users[uint(id)].commitment == answerHash, "Revealed answer does not match commitment");

        users[uint(id)].answer = answer;
        emit AnswerRevealed(msg.sender, answer);
    }

    /**
     * @dev Starts the reveal phase, allowing participants to reveal their answers.
     */
    function startRevealPhase() public onlyOwner {
        revealPhase = true;
    }

    /**
     * @dev Retrieves the answer of a specific participant.
     * @param participant The address of the participant.
     * @return The revealed answer of the participant.
     */
    function getAnswer(address participant) public view returns (string memory) {
        int id = getUser(participant);
        require(id != -1, "User has not revealed answer yet");
        return users[uint(id)].answer;
    }

    /**
     * @dev Reveals the winner based on the revealed answers.
     * @param secretHash The hash of the secret answer.
     */
    function revealWinner(bytes32 secretHash) public onlyOwner {
        require(revealPhase, "Reveal phase has not started yet");
        require(winner == address(0), "Winner already revealed");
        require(users.length > 0, "No commitments found to declare winner");

        for (uint i = 0; i < users.length; i++) {
            if (keccak256(bytes(users[i].answer)) == secretHash) {
                winner = users[i].addressUser;
                winningAnswer = users[i].answer;
                emit WinnerRevealed(winner, winningAnswer);
                return;
            }
        }

        revert("No winner found");
    }

    /**
     * @dev Searches for the user based on the caller address.
     * @return index of the user in the array users, or -1 if not found.
     */
    function getUser(address _address) public view returns (int) {
        for (uint i = 0; i < users.length; i++) {
            if (users[i].addressUser == _address) {
                return int(i);
            }
        }
        return -1;
    }

    /**
     * @dev Modifier to restrict access to only the contract owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }
}
