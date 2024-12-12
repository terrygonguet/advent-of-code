package utils

import "base:runtime"
import "core:fmt"
import "core:mem"
import "core:os"
import "core:slice"
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

tracking_init :: proc(allocator := context.allocator) -> mem.Tracking_Allocator {
	tracking: mem.Tracking_Allocator
	mem.tracking_allocator_init(&tracking, allocator)
	return tracking
}

tracking_cleanup :: proc(tracking: ^mem.Tracking_Allocator) {
	for _, leak in tracking.allocation_map {
		fmt.printf("%v leaked %m\n", leak.location, leak.size)
	}
	for bad_free in tracking.bad_free_array {
		fmt.printf("%v allocation %p was freed badly\n", bad_free.location, bad_free.memory)
	}
	mem.tracking_allocator_destroy(tracking)
}

@(require_results)
linear_search_ctx :: proc(
	data: $S/[]$T,
	ctx: $C,
	f: proc(item: T, ctx: C) -> bool,
) -> (
	idx: int,
	ok: bool,
) {
	for x, i in data {
		if f(x, ctx) {
			return i, true
		}
	}
	return -1, false
}

@(require_results)
map_ctx :: proc(
	data: $S/[]$T,
	ctx: $C,
	f: proc(item: T, ctx: C) -> $U,
	allocator := context.allocator,
) -> (
	result: []U,
	err: runtime.Allocator_Error,
) #optional_allocator_error {
	result = make([]U, len(data), allocator) or_return
	for value, i in data {
		result[i] = f(value, ctx)
	}
	return
}

@(require_results)
map_ok :: proc(
	data: $S/[]$T,
	f: proc(item: T) -> (r: $U, ok: bool),
	allocator := context.allocator,
) -> (
	result: []U,
	err: runtime.Allocator_Error,
) #optional_allocator_error {
	r := make([dynamic]U, 0, len(data), allocator) or_return
	for value, i in data {
		if item, ok := f(value); ok {
			append_elem(&r, item)
		}
	}
	return r[:], nil
}

@(require_results)
filter_ctx :: proc(
	data: $S/[]$T,
	ctx: $C,
	f: proc(item: T, ctx: C) -> bool,
	allocator := context.allocator,
) -> (
	result: []T,
	err: runtime.Allocator_Error,
) #optional_allocator_error {
	r = make([dynamic]U, 0, len(data), allocator) or_return
	for value, i in data {
		if f(value, ctx) do append_elem(&r, value)
	}
	return r[:], nil
}

@(require_results)
reduce_ctx :: proc(
	data: $S/[]$T,
	intializer: $U,
	ctx: $C,
	f: proc(acc: U, item: T, ctx: C) -> U,
) -> U {
	acc := initializer
	for value in data {
		acc = f(acc, value, ctx)
	}
	return acc
}
