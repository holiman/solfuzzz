contract A {
    constructor() public payable {}
    function a(address addr, uint amount) public returns (uint) {
        addr.transfer(amount);
        return address(this).balance;
    }
    function b(address addr, uint amount) public {
        addr.transfer(amount);
    }
}

contract B {
}

contract C {
    function () external payable {
        revert();
    }
}
