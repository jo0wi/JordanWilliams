# Cache Emulator — C / Linux

A C-language cache simulator that models a configurable set-associative cache with LRU replacement on memory-trace input. The simulator parses standard `lds`/`sts` (load/store) trace records on stdin, walks the cache state machine for each access, and reports hit/miss/stall statistics plus dirty evictions — useful for studying the hit-rate impact of associativity, block size, and total cache size.

> Course project for ELEE 4830 / Computer Architecture. Full design write-up: [`Cache Simulator Project.pdf`](./Cache%20Simulator%20Project.pdf).

---

## Project Structure

| File | Description |
|------|-------------|
| `cache.c` | Simulator core — argument parsing, cache state machine, statistics |
| `Makefile` | Build (`make`) and run (`make run <trace> -a ... -l ... -s ... -mp ...`) targets |
| `Cache Simulator Project.pdf` | Full project write-up with results and analysis |
| `Main flowchart.png` | High-level program flow |
| `Cache_access flowchart.png` | Per-access cache state machine |

---

## Build

```bash
make            # produces ./cache.out
```

## Run

The simulator reads gzipped trace files from stdin and accepts cache parameters as flags. The Makefile wraps both steps:

```bash
make run <tracefile> -a <assoc> -l <blksz> -s <size> -mp <mispen>
```

Direct invocation works too:

```bash
gunzip -c traces/art.trace.gz | ./cache.out -a 2 -l 32 -s 64 -mp 30
```

| Flag | Meaning | Default |
|------|---------|---------|
| `-a` | Associativity (1 = direct-mapped) | 2 |
| `-l` | Block size in bytes | 32 |
| `-s` | Cache size in KB | 64 |
| `-mp` | Miss penalty in cycles | 30 |

If `<tracefile>` is omitted, the Makefile defaults to `art`.

The miss penalty is internally adjusted by `blocksize_adder(bs)` to model the extra transfer cycles needed to fetch a larger block from memory (`+0` for 16 B, `+2` for 32 B, `+6` for 64 B, `+12` for 128 B).

---

## Output

The simulator prints per-run statistics including:

- Total instructions processed
- Total memory accesses (loads + stores)
- Load and store hits / misses
- Dirty evictions (write-back count)
- Total stall cycles attributable to cache misses

These outputs feed the design-space sweep in the project report, comparing miss rates and stall cycles across associativity / block size / total size combinations.

---

## Implementation Notes

- **Set-associative organization** — each set is an array of `cache_line` structs holding `valid`, `dirty`, `tag`, and `lru` fields.
- **LRU replacement** — the per-line `lru` counter is updated on every access; the largest counter inside a set is the eviction candidate on a miss.
- **Write-back on dirty eviction** — when a dirty line is evicted, the simulator increments the dirty-eviction count and adds the same miss penalty as a clean miss (modeling a write-allocate, write-back policy).
- **Trace format** — each line starts with `lds` (load) or `sts` (store) followed by the access address; non-data lines are skipped.
