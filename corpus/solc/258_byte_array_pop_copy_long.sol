contract c {
    bytes data;
    function test() public returns (bytes memory) {
        for (uint i = 0; i < 33; i++)
            data.push(0x03);
        for (uint j = 0; j < 4; j++)
            data.pop();
        return data;
    }
}
