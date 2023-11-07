def test_initial_state(token, owner):
    """
    Test inital state of the contract.
    """
    # Check the token meta matches the deployment 
    # token.method_name() has access to all the methods in the smart contract.
    assert token.name() == "Akashi ID"
    assert token.symbol() == "AID"
    assert token.decimals() == 18

    # Check of intial state of authorization
    assert token.owner() == owner
    
    # Check intial balance of tokens
    assert token.totalSupply() == 0
    assert token.balanceOf(owner) == 0
