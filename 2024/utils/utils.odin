package utils

import "core:os"
import "core:strings"

get_puzzle :: proc() -> (puzzle: string, err: os.Error) {
	buf: [256]byte
	builder := strings.builder_make()
	for {
		n := os.read(os.stdin, buf[:]) or_return
		if n == 0 do break
		strings.write_bytes(&builder, buf[:n])
	}
	return strings.to_string(builder), nil
}
