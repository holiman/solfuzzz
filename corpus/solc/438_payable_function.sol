contract C {
    uint public a;
    function f() payable public returns (uint) {
        return msg.value;
    }
    function() external payable {
        a = msg.value + 1;
    }
}
