// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Challenge.sol";

contract ChallengeTest is Test {
    Challenge public challenge;

    event AnswerRevealed(address indexed participant, string answer);
    event WinnerRevealed(address indexed winner, string winningAnswer);
    function setUp() public {
        challenge = new Challenge();
    }

    function testCommitAnswer() public {
        // Commit an answer using the commit function.
        challenge.commit(keccak256(abi.encodePacked("test1")));
        //Verify that the commitment is recorded correctly by checking the user's commitment in the users array.
    }

    function testRevealAnswer() public {
        // Start the reveal phase using the startRevealPhase function

        // User reveal an answer using the reveal function.

        // Verify that the revealed answer matches the commitment hash and is recorded correctly in the users array.
    }

    function testGetAnswer() public {
        // Get the answer of a participant using the getAnswer function.

        // Verify that the returned answer matches the revealed answer of the participant.
    }

    function testRevealWinner() public {
        // Commit challenge with correct answer
        vm.prank(address(2));
        challenge.commit(keccak256(abi.encodePacked("correct answer")));
        // Start the reveal phase
        challenge.startRevealPhase();
        // Verify that the winner and the winning answer are recorded correctly.
        vm.expectEmit();
        emit AnswerRevealed(address(2), "correct answer");
        // Reveal the winner using the revealWinner function with a valid secret hash.
        vm.prank(address(2));
        challenge.reveal("correct answer");
    }

    function testRevealWinnerWithoutStartingPhase() public {
        // Attempt to reveal the winner using the revealWinner function before starting the reveal phase.
        vm.expectRevert("Reveal phase has not started yet");
        challenge.reveal("test");
        // Verify that the function reverts with the appropriate error message.
    }

    function testRevealWinnerWithoutCommits() public {
        // Start the reveal phase using the startRevealPhase function.
        challenge.startRevealPhase();
        // Verify that the function reverts with the appropriate error message.
        vm.expectRevert("No commitments found to declare winner");
        // Attempt to reveal the winner using the revealWinner function when no commitments exist.
        challenge.revealWinner(keccak256(abi.encodePacked("test1")));
    }

    function testRevealWinnerIncorrectSecretHash() public {
        // Start the reveal phase using the startRevealPhase function.

        // Reveal an answer using the reveal function.

        // Attempt to reveal the winner using the revealWinner function with an incorrect secret hash.

        //  Verify that the function reverts with the appropriate error message.
    }

    function testRevealWinnerMultipleTimes() public {
        //  Start the reveal phase using the startRevealPhase function.

        //  Reveal an answer using the reveal function.

        //  Reveal the winner using the revealWinner function.

        //  Attempt to reveal the winner again.

        //  Verify that the function reverts with the appropriate error message.
    }

    function testCommitAfterRevealPhaseStarted() public {
        //  Start the reveal phase using the startRevealPhase function.

        //  Attempt to commit an answer using the commit function.

        //  Verify that the function reverts with the appropriate error message.
    }

    function testStartRevealPhase() public {
        //  Attempt to start the reveal phase using a non-owner account.

        //  Verify that the function reverts with the appropriate error message.
    }
}
