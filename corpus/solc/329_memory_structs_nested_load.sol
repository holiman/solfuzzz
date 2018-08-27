contract Test {
    struct S { uint8 x; uint16 y; uint z; }
    struct X { uint8 x; S s; uint8[2] a; }
    X m_x;
    function load() public returns (uint a, uint x, uint y, uint z, uint a1, uint a2) {
        m_x.x = 1;
        m_x.s.x = 2;
        m_x.s.y = 3;
        m_x.s.z = 4;
        m_x.a[0] = 5;
        m_x.a[1] = 6;
        X memory d = m_x;
        a = d.x;
        x = d.s.x;
        y = d.s.y;
        z = d.s.z;
        a1 = d.a[0];
        a2 = d.a[1];
    }
    function store() public returns (uint a, uint x, uint y, uint z, uint a1, uint a2) {
        X memory d;
        d.x = 1;
        d.s.x = 2;
        d.s.y = 3;
        d.s.z = 4;
        d.a[0] = 5;
        d.a[1] = 6;
        m_x = d;
        a = m_x.x;
        x = m_x.s.x;
        y = m_x.s.y;
        z = m_x.s.z;
        a1 = m_x.a[0];
        a2 = m_x.a[1];
    }
}
