contract C {
    function f(uint i) public returns (string memory) {
        string[4] memory x = ["This", "is", "an", "array"];
        return (x[i]);
    }
}
