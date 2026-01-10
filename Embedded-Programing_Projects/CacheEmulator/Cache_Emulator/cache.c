// to run with makefile: 
// make -- run tracefilename -s 64 -a 2 -l 32 -mp 30 (fill in with desired parameters or leave blank for defaults)

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

// default cache parameters
int associativity   = 2; 
int blocksize_bytes = 32; 
int cachesize_kb    = 64; 
int miss_penalty    = 30; 

// usage message
void print_usage() {
  printf("Usage: gunzip -c <tracefile> | ./cache -a <assoc> -l <blksz> -s <size> -mp <mispen>\n");
  printf("  <tracefile>: The memory trace file\n");
  printf("  -a <assoc>: The associativity of the cache\n");
  printf("  -l <blksz>: The blocksize (in bytes) of the cache\n");
  printf("  -s <size>: The size (in KB) of the cache\n");
  printf("  -mp <mispen>: The miss penalty (in cycles) of a miss\n");
  exit(0);
}

// blocksize adder for miss penalty calculation
int blocksize_adder(int bs) {
  if (bs == 16)  return 0;
  if (bs == 32)  return 2;
  if (bs == 64)  return 6;
  if (bs == 128) return 12;
  return 0;
}

// cache line structure
typedef struct {
  int valid;
  int dirty;
  unsigned long tag;
  unsigned long lru;
} CacheLine;

 
CacheLine **cache = NULL; // cache[set][way] pointers

int num_sets = 0;
int offset_bits = 0;
int index_bits = 0;
unsigned long lru_clock = 0;

// initializing stats
unsigned long long instructions = 0;
unsigned long long mem_accesses = 0;
unsigned long long load_hits = 0,  load_misses = 0;
unsigned long long store_hits = 0, store_misses = 0;
unsigned long long dirty_evictions = 0;
unsigned long long stall_cycles = 0;

// initialize cache structure
void initialize_cache() {

  int total_bytes = cachesize_kb * 1024; // KB to bytes
  num_sets = total_bytes / (blocksize_bytes * associativity); // sets = size / (blocksize * assoc)

  if (num_sets <= 0) {
    printf("Error: invalid cache geometry.\n");
    exit(1);
  }

  // calculate offset and index bits needed
  offset_bits = (int)round(log2(blocksize_bytes)); 
  index_bits  = (int)round(log2(num_sets));

  
  cache = malloc(num_sets * sizeof(CacheLine*)); //allocate cache[set][way] structure
  if (!cache) { perror("malloc"); exit(1); } // ensure malloc worked

  for (int s = 0; s < num_sets; s++) {
    cache[s] = malloc(associativity * sizeof(CacheLine));
    if (!cache[s]) { perror("malloc"); exit(1); } // ensure malloc worked for each set

    // initialize each cache line
    for (int w = 0; w < associativity; w++) {
      cache[s][w].valid = 0;
      cache[s][w].dirty = 0;
      cache[s][w].tag   = 0;
      cache[s][w].lru   = 0;
    }
  }
}

// get tag and index from address
unsigned long get_tag(unsigned long addr) {
  return addr >> (offset_bits + index_bits);
}

int get_index(unsigned long addr) {
  return (addr >> offset_bits) & (num_sets - 1);
}


void access_cache(unsigned long addr, int is_store) {

  int set_i = get_index(addr);
  unsigned long tag = get_tag(addr);

  CacheLine *set = cache[set_i];
  int eff_mp = miss_penalty + blocksize_adder(blocksize_bytes);

  // check for hits
  for (int w = 0; w < associativity; w++) {
    if (set[w].valid && set[w].tag == tag) {

      // hit
      if (is_store) {
        store_hits++;
        set[w].dirty = 1;
      } else {
        load_hits++;
      }

      set[w].lru = ++lru_clock;
      return;
    }
  }

  // miss
  if (is_store)
      store_misses++;
  else
      load_misses++;

  stall_cycles += eff_mp;

  // find line to evict
  int victim = -1;

  // first look for invalid line
  for (int w = 0; w < associativity; w++) {
    if (!set[w].valid) {
      victim = w;
      break;
    }
  }

  // then use LRU if none found
  if (victim == -1) {
    unsigned long best_lru = (unsigned long)-1;
    for (int w = 0; w < associativity; w++) {
      if (set[w].lru < best_lru) {
        best_lru = set[w].lru;
        victim = w;
      }
    }
  }

  // dirty eviction
  if (set[victim].valid && set[victim].dirty) {
    stall_cycles += 2;
    dirty_evictions++;
  }

  // fill in the victim line
  set[victim].valid = 1;
  set[victim].dirty = is_store ? 1 : 0;
  set[victim].tag   = tag;
  set[victim].lru   = ++lru_clock;
}


int main(int argc, char *argv[]) {

  long address;
  int loadstore, icount;
  char marker;

  int j = 1;
  while (j < argc) {
    if (strcmp("-a", argv[j]) == 0) { 
      j++; 
      if (j>=argc) 
        print_usage(); 
      associativity = atoi(argv[j]); 
      j++; 
    }
    else if (strcmp("-l", argv[j]) == 0) { 
      j++; 
      if (j>=argc) 
        print_usage(); 
      blocksize_bytes = atoi(argv[j]); 
      j++; 
    }
    else if (strcmp("-s", argv[j]) == 0) { 
      j++; 
      if (j>=argc) 
        print_usage(); 
      cachesize_kb = atoi(argv[j]); 
      j++; 
    }
    else if (strcmp("-mp", argv[j]) == 0){ 
      j++; 
      if (j>=argc) 
        print_usage(); 
      miss_penalty = atoi(argv[j]); 
      j++; 
    }
    else print_usage();
  }

  printf("Cache parameters:\n");
  printf("Cache Size (KB)\t\t\t%d\n", cachesize_kb);
  printf("Cache Associativity\t\t%d\n", associativity);
  printf("Cache Block Size (bytes)\t%d\n", blocksize_bytes);
  printf("Miss penalty (cyc)\t\t%d\n\n", miss_penalty);

  initialize_cache();

  // read trace
  while (scanf("%c %d %lx %d\n", &marker, &loadstore, &address, &icount) != EOF) {
    mem_accesses++;
    instructions += icount;
    access_cache((unsigned long)address, loadstore);
  }

  // calculate final stats
  unsigned long long total_misses = load_misses + store_misses;
  unsigned long long loads = load_hits + load_misses;
  unsigned long long total_cycles = instructions + stall_cycles;

  double overall_miss_rate = (double)total_misses / mem_accesses;
  double read_miss_rate    = (double)load_misses / loads;
  double mem_cpi           = (double)stall_cycles / instructions;
  double total_cpi         = 1.0 + mem_cpi;
  double amat              = (double)stall_cycles / mem_accesses;

  printf("Simulation results:\n");
  printf("\texecution time %llu cycles\n", total_cycles);
  printf("\tinstructions %llu\n", instructions);
  printf("\tmemory accesses %llu\n", mem_accesses);
  printf("\toverall miss rate %.2f\n", overall_miss_rate);
  printf("\tread miss rate %.2f\n", read_miss_rate);
  printf("\tmemory CPI %.2f\n", mem_cpi);
  printf("\ttotal CPI %.2f\n", total_cpi);
  printf("\taverage memory access time %.2f cycles\n", amat);
  printf("dirty evictions %llu\n", dirty_evictions);
  printf("load_misses %llu\n", load_misses);
  printf("store_misses %llu\n", store_misses);
  printf("load_hits %llu\n", load_hits);
  printf("store_hits %llu\n", store_hits);

}
