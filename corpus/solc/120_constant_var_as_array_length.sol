contract C {
    uint constant LEN = 3;
    uint[LEN] public a;

    constructor(uint[LEN] memory _a) public {
        a = _a;
    }
}
