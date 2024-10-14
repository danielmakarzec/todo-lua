local function testUnicode()
    print("Unicode test:")
    print("Box drawing characters:")
    print(utf8.char(0x250F) .. utf8.char(0x2501) .. utf8.char(0x2513))
    print(utf8.char(0x2503) .. " " .. utf8.char(0x2503))
    print(utf8.char(0x2517) .. utf8.char(0x2501) .. utf8.char(0x251B))
    print("Alternate box:")
    print("╔═╗")
    print("║ ║")
    print("╚═╝")
    print("Unicode string length test:")
    local str = "Hello, 世界"
    print("String:", str)
    print("Byte length:", #str)
    print("UTF-8 length:", utf8.len(str))
    print("First character:", utf8.char(utf8.codepoint(str, 1, 1)))
    io.write("Press Enter to continue...")
    io.read()
end

testUnicode()