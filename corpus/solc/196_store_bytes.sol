contract C {
    function save() public returns (uint r) {
        r = 23;
        savedData = msg.data;
        r = 24;
    }
    bytes savedData;
}
