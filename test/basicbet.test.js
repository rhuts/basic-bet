const BinaryBet = artifacts.require("BinaryBet");

contract('BinaryBet', (accounts) => {

    let binaryBet;

    const betAmount = web3.utils.toWei("1", "ether");
    const owner = accounts[0];
    const userA = accounts[1];
    const userB = accounts[2];
    const userC = accounts[3];

    // checks basic functionality with cooperative users
    context('contract at least works', () => {

        before(async () => {
            
            binaryBet = await BinaryBet.new({
                from: owner
            });

            let currOwner = await binaryBet.owner();
            assert.equal(currOwner, owner, "contract owner is not setup correctly");
        });

        it('first user places a bet', async () => {
            let firstChoice = 0;

            await binaryBet.addBet(firstChoice, {
                from: userA,
                value: betAmount
            });

            let choiceA = await binaryBet.choiceA();
            assert.equal(choiceA, firstChoice, "first user's bet choice was not successfully recorded");
        });

        it('second user places a bet', async () => {
            let secondChoice = 1;

            await binaryBet.addBet(secondChoice, {
                from: userB,
                value: betAmount
            });

            let choiceB = await binaryBet.choiceB();
            assert.equal(choiceB, secondChoice, "second user's bet choice was not successfully recorded");
        });

        it('contract holds the bet values', async () => {
            let balance = parseInt(await web3.eth.getBalance(binaryBet.address), 10);
            expect(balance).to.be.at.least(2 * betAmount, "bet values not stored");
        });

        it('can finalize the event outcome', async () => {
            let result = 0;

            await binaryBet.finalizeEvent(result, {
                from: owner
            });

            let actualResult = await binaryBet.result();
            assert.equal(actualResult, result, "actual result was not recorded");
        });

        it('funds released to winner', async () => {
            let balanceBefore = parseInt(await web3.eth.getBalance(userA), 10);
            let expectedBalance = balanceBefore + (2 * betAmount);

            await binaryBet.releaseFunds();
            
            let balanceAfter = parseInt(await web3.eth.getBalance(userA), 10);
            assert.deepEqual(balanceAfter, expectedBalance, "winner did not get their winnings");
        });
    });

    // rigorous testing of bet placing by cooperative and malicious users
    context('bet placing', () => {

        beforeEach(async () => {
            
            binaryBet = await BinaryBet.new({
                from: owner
            });

            let currOwner = await binaryBet.owner();
            assert.equal(currOwner, owner, "contract owner is not setup correctly");
        });

        // to be removed
        it('should always pass', async () => {
            let actual = true;
            let expected = true;
            assert.equal(actual, expected, "should always be true");
        });

        // bet amounts below the minimum are rejected

        // first user can place a bet

        // second user can place a bet

        // third user cannot place a bet

        // 
    });

    // rigorous testing of payment/refund
    context('payment/refund ', () => {

        beforeEach(async () => {
        
            binaryBet = await BinaryBet.new({
                from: userA
            });
    
            let currOwner = await binaryBet.owner();
            assert.equal(currOwner, userA, "contract owner is not setup correctly");
        });

        // to be removed
        it('should always pass', async () => {
            let actual = true;
            let expected = true;
            assert.equal(actual, expected, "should always be true");

            let currOwner = await binaryBet.owner();
            assert.equal(currOwner, userA, "contract owner is not setup correctly");
        });

        // owner can finalize the bet event (declare result)

        // bet funds are returned to participants in both cases of ties

        // correct funds go to winner

        // funds do not go to looser

    });

});
