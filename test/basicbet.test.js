const BasicBet = artifacts.require("BasicBet");

contract('BasicBet', (accounts) => {

    let basicBet;

    const betAmount = web3.utils.toWei("1", "ether");
    const owner = accounts[0];
    const userA = accounts[1];
    const userB = accounts[2];
    const userC = accounts[3];

    context('bet placing ', () => {

        beforeEach(async () => {
            
            basicBet = await BasicBet.new({
                from: owner
            });

            let currOwner = await basicBet.owner();
            assert.equal(currOwner, owner, "contract owner is not setup correctly");
        });

        // to be removed
        it('should always pass', async () => {
            let actual = true;
            let expected = true;
            assert.equal(actual, expected, "should always be true");
        });

        // bet amounts below the minimum are rejected

        // one user can place a bet

        // second user can place a bet

        // third user cannot place a bet

        // 
    });

    context('payment/refund ', () => {

        beforeEach(async () => {
        
            basicBet = await BasicBet.new({
                from: userA
            });
    
            let currOwner = await basicBet.owner();
            assert.equal(currOwner, userA, "contract owner is not setup correctly");
        });

        // to be removed
        it('should always pass', async () => {
            let actual = true;
            let expected = true;
            assert.equal(actual, expected, "should always be true");

            let currOwner = await basicBet.owner();
            assert.equal(currOwner, userA, "contract owner is not setup correctly");
        });

        // owner can finalize the bet event (declare result)

        // bet funds are returned to participants in both cases of ties

        // correct funds go to winner

        // funds do not go to looser

    });

});
