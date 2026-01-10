# Cache Emulator

A C-based cache simulator that models a set-associative cache with LRU replacement policy. This project demonstrates computer architecture concepts by simulating cache behavior on memory traces.

## Features

- Configurable cache parameters: associativity, block size, cache size, miss penalty
- Supports memory trace input via stdin (compressed with gzip)
- Calculates and reports cache statistics: hits, misses, stall cycles, dirty evictions
- LRU (Least Recently Used) replacement policy
- Set-associative cache organization

## Technologies Used

- C programming language
- Standard libraries: stdio, stdlib, string, math
- Makefile for build automation
- Gzip for trace file decompression

## Build Instructions

To compile the cache simulator:

```bash
make
```

This will generate the executable `cache.out`.

## Usage

The simulator reads memory traces from stdin and accepts command-line arguments for cache configuration.

### Basic Usage

```bash
gunzip -c <tracefile.gz> | ./cache.out -a <associativity> -l <blocksize> -s <cachesize_kb> -mp <miss_penalty>
```

### Parameters

- `-a <assoc>`: Cache associativity (default: 2)
- `-l <blksz>`: Block size in bytes (default: 32)
- `-s <size>`: Cache size in KB (default: 64)
- `-mp <mispen>`: Miss penalty in cycles (default: 30)

### Makefile Run Command

The Makefile provides a convenient way to run the simulator:

```bash
make run <tracefile> -a <assoc> -l <blksz> -s <size> -mp <mispen>
```

If no tracefile is specified, it defaults to 'art'.

## Output

The simulator outputs cache performance statistics including:
- Total instructions processed
- Memory accesses
- Load/store hits and misses
- Dirty evictions
- Total stall cycles due to cache misses

## Project Structure

- `cache.c`: Main simulator implementation
- `Makefile`: Build and run automation
- `Cache Simulator Project.pdf`: Detailed project documentation
- Flowchart images: Visual representation of cache access and main program flow

## Learning Outcomes

This project demonstrates:
- Cache memory organization and operation
- LRU replacement algorithm implementation
- Memory trace analysis
- Performance metrics calculation
- Command-line argument parsing in C