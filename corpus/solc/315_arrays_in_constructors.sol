contract Base {
    uint public m_x;
    address[] m_s;
    constructor(uint x, address[] memory s) public {
        m_x = x;
        m_s = s;
    }
    function part(uint i) public returns (address) {
        return m_s[i];
    }
}
contract Main is Base {
    constructor(address[] memory s, uint x) Base(x, f(s)) public {}
    function f(address[] memory s) public returns (address[] memory) {
        return s;
    }
}
contract Creator {
    function f(uint x, address[] memory s) public returns (uint r, address ch) {
        Main c = new Main(s, x);
        r = c.m_x();
        ch = c.part(x);
    }
}
