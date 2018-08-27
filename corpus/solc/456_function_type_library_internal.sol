library Utils {
    function reduce(uint[] memory array, function(uint, uint) internal returns (uint) f, uint init) internal returns (uint) {
        for (uint i = 0; i < array.length; i++) {
            init = f(array[i], init);
        }
        return init;
    }
    function sum(uint a, uint b) internal returns (uint) {
        return a + b;
    }
}
contract C {
    function f(uint[] memory x) public returns (uint) {
        return Utils.reduce(x, Utils.sum, 0);
    }
}
