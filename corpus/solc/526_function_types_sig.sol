contract C {
    uint public x;
    function f() public pure returns (bytes4) {
        return this.f.selector;
    }
    function g() public returns (bytes4) {
        function () pure external returns (bytes4) fun = this.f;
        return fun.selector;
    }
    function h() public returns (bytes4) {
        function () pure external returns (bytes4) fun = this.f;
        return fun.selector;
    }
    function i() public pure returns (bytes4) {
        return this.x.selector;
    }
}
