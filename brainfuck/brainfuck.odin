package brainfuck

import "core:fmt"
import "core:os"
import "core:strings"

interpret :: proc(code: []u8) {
    tape := [256]u8{}
    tape_pos: u8
    code_pos: u8

    for code_pos <= cast(u8)len(code) {
        switch code[code_pos] {
            case '>':
                if tape_pos == 255 {
                    tape_pos = 0
                } else {
                    tape_pos += 1
                }
            case '<':
                if tape_pos == 0 {
                    tape_pos = 255
                } else {
                    tape_pos -= 1
                }
            case '+':
                if tape[tape_pos] == 255 {
                    tape[tape_pos] = 0
                } else {
                    tape[tape_pos] += 1
                }
            case '-':
                if tape[tape_pos] == 0 {
                    tape[tape_pos] = 255
                } else {
                    tape[tape_pos] -= 1
                }
            case '.':
               fmt.printf("%c", tape[tape_pos])
            case ',':
                input := user_input()
                break
            case:
                continue
        }
    }
}

user_input :: proc() -> []u8 {
    buf: [256]byte
    n, err := os.read(os.stdin, buf[:])
    if err < 0 {
        error_handler("Can't read user input.")
    }
    return buf[:n]
}

error_handler :: proc(str: string) {
    fmt.eprintln("Error:\t%s", str)
}
