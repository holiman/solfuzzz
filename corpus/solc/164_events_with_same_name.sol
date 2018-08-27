contract ClientReceipt {
    event Deposit();
    event Deposit(address _addr);
    event Deposit(address _addr, uint _amount);
    function deposit() public returns (uint) {
        emit Deposit();
        return 1;
    }
    function deposit(address _addr) public returns (uint) {
        emit Deposit(_addr);
        return 1;
    }
    function deposit(address _addr, uint _amount) public returns (uint) {
        emit Deposit(_addr, _amount);
        return 1;
    }
}
