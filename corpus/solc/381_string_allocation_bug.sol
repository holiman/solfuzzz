contract Sample
{
    struct s { uint16 x; uint16 y; string a; string b;}
    s[2] public p;
    constructor() public {
        s memory m;
        m.x = 0xbbbb;
        m.y = 0xcccc;
        m.a = "hello";
        m.b = "world";
        p[0] = m;
    }
}
