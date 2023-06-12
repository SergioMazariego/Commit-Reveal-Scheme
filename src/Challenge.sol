// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title Challenge
 * @dev A contract that allows participants to commit and reveal answers, and declares a winner based on the revealed answers.
 */
contract Challenge {
    struct User {
        bytes32 commitment; // Hashed answer submitted by the participant
        address addressUser; // Address of the participant
        string answer; // Revealed answer by the participant
    }

    User[] public users; // Array to store user data
    bool public revealPhase; // Flag indicating if the reveal phase has started
    address public winner; // Address of the winner
    string public winningAnswer; // Revealed answer of the winner
    address public owner; // Address of the contract owner

    event AnswerRevealed(address indexed participant, string answer);
    event WinnerRevealed(address indexed winner, string winningAnswer);

    /**
     * @dev Initializes the Challenge contract.
     */
    constructor() {
        revealPhase = false; // Set reveal phase to false initially
        owner = msg.sender; // Set the contract owner as the deployer of the contract
    }

    /**
     * @dev Commit function for participants to submit their hashed answers.
     * @param hash The hash of the participant's answer.
     */
    function commit(bytes32 hash) public {
        require(!revealPhase, "Commit phase is over"); // Check if the commit phase is still ongoing
        require(getUser(msg.sender) == -1, "Commitment already made"); // Check if the user has not already made a commitment

        User memory user;
        user.commitment = hash; // Set the commitment hash for the user
        user.addressUser = msg.sender; // Set the user's address
        users.push(user); // Add the user to the users array
    }

    /**
     * @dev Reveals the participant's answer and verifies it against the commitment.
     * @param answer The actual answer to be revealed.
     */
    function reveal(string memory answer) public {
        require(revealPhase, "Reveal phase has not started yet"); // Check if the reveal phase has started
        int256 id = getUser(msg.sender); // Get the user's index based on the caller address
        require(id != -1, "No commitment found"); // Check if the user has made a commitment

        bytes32 answerHash = keccak256(bytes(answer)); // Hash the provided answer
        require(users[uint256(id)].commitment == answerHash, "Revealed answer does not match commitment"); // Check if the revealed answer matches the commitment

        users[uint256(id)].answer = answer; // Store the revealed answer for the user
        emit AnswerRevealed(msg.sender, answer); // Emit an event to indicate the answer has been revealed
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
        int256 id = int256(getUser(participant)); // Get the index of the participant in the users array
        require(bytes(users[uint256(id)].answer).length > 0, "User has not revealed answer yet"); // Check if the participant has revealed their answer
        return users[uint256(id)].answer; // Return the revealed answer of the participant
    }

    /**
     * @dev Reveals the winner based on the revealed answers.
     * @param secretHash The hash of the secret answer.
     */
    function revealWinner(bytes32 secretHash) public onlyOwner {
        require(revealPhase, "Reveal phase has not started yet"); // Check if the reveal phase has started
        require(winner == address(0), "Winner already revealed"); // Check if the winner has already been revealed
        require(users.length > 0, "No commitments found to declare winner"); // Check if there are commitments to declare a winner

        for (uint256 i = 0; i < users.length; i++) {
            // Iterate through the users array
            if (keccak256(bytes(users[i].answer)) == secretHash) {
                // Check if the hashed answer matches the secretHash
                winner = users[i].addressUser; // Set the winner address
                winningAnswer = users[i].answer; // Set the winning answer
                emit WinnerRevealed(winner, winningAnswer); // Emit an event to indicate the winner has been revealed
                return; // Exit the function
            }
        }
        revert("No winner found"); // Revert if no winner is found
    }

    /**
     * @dev Searches for the user based on the caller address.
     * @return index of the user in the array users, or -1 if not found.
     */
    function getUser(address _address) public view returns (int256) {
        for (uint256 i = 0; i < users.length; i++) {
            // Iterate through the users array
            if (users[i].addressUser == _address) {
                // Check if the address matches
                return int256(i); // Return the index of the user
            }
        }
        return -1; // Return -1 if the user is not found
    }

    /**
     * @dev Modifier to restrict access to only the contract owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }
}
