package esodin

import "core:fmt"
import "core:os"

Tape_size :: 256
Byte_limit :: 256

interpret :: proc(command: []u8) {//, command_pos: ^int) {
    tape: [Tape_size]int
    tape_pos: int
    begin_loop_pos: int
    after_loop_pos: int
    command_pos: int

    for ; command_pos < len(command) ; command_pos += 1 {
        switch command[command_pos] {
            case '+':
                increment(&tape[tape_pos], Byte_limit)
            case '-':
                decrement(&tape[tape_pos], Byte_limit)
            case '<':
                decrement(&tape_pos, Tape_size)
            case '>':
                increment(&tape_pos, Tape_size)
            case ',':
                input := user_input()
                for i in input {
                    tape[tape_pos] = int(i)
                    if tape_pos < Byte_limit-1 {
                        tape_pos += 1
                    } else {
                        tape_pos = 0
                    }
                }
            case '.':
                fmt.print(tape[tape_pos])
            case '$':
                for value, index in tape {
                    fmt.println(index,"->", value)
                }
            case '[':
                begin_loop_pos = command_pos + 1
            case ']':
                if tape[tape_pos] != 0 {
                    after_loop_pos = command_pos + 1
                    command_pos = begin_loop_pos
                } else {
                    command_pos = after_loop_pos
                }
        }
    }
}

increment :: proc(value: ^int, limit: int) {
    if value^ == limit-1 {
        value^ = 0
    } else {
        value^ += 1
    }
}

decrement :: proc(value: ^int, limit: int) {
    if value^ == 0 {
        value^ = limit-1
    } else {
        value^ -= 1
    }
}

user_input :: proc() -> []u8 {
    buf: [256]byte
    n, err := os.read(os.stdin, buf[:])
    if err < 0 {
        error_handler("Can't read Input !")
    }
    return buf[:n]
}

error_handler :: proc(str: string) {
    fmt.eprintln("Error:\t%s", str)
}
