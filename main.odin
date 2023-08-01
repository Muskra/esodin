package main

import "core:fmt"
import "core:os"
import "brainfuck"

main :: proc() {

    file_path: string
    seen_path: bool
    arguments := os.args

    if len(arguments) == 1 {argument_help()}

    index := 0
    for ; index < len(arguments) ; index += 1 {
        if seen_path == true {break}
        if index != 0 {
            switch arguments[index] {
                case "--file":
                    if index < len(arguments)-1 {
                        file_path = arguments[index+1]
                        seen_path = true
                    } else {
                        fmt.eprintln(fmt.tprintf("error: '%s' require path.\nTry '--help' for more informations.\n", arguments[index]))
                        os.exit(1)
                    }
                case "--help":
                    argument_help()
                case:
                    argument_error(arguments[index])
            }
        }
    }
    file_scanner(file_path)
}

file_scanner :: proc(path: string) {
    bytes, ok := os.read_entire_file_from_filename(path)
    if !ok {
        fmt.eprintf("'%s': No such file or directory\nTry '--help' for more informations.\n", path)
        os.exit(1)
    }
    defer delete(bytes)
    
    // must execute brainfuck here
    brainfuck.interpret(bytes)
}

argument_help :: proc() {
    help_message := `crow [OPTION]...
crow compiler.

--file      file path for the program to read.
--help      display this help message then quit.`
    fmt.eprintln(help_message)
    os.exit(1)
}

argument_error :: proc(arg: string) {
    fmt.eprintln(fmt.tprintf("basic: invalid option %s\nTry '--help' for more informations.\n", arg))
    os.exit(1)
}
