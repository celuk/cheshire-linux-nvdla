#include <stdio.h>
#include <math.h>


/* 1. Custom Memory Allocator (replaces malloc) 
   We use a static memory pool since we cannot ask the OS for heap memory 
   without stdlib/system-specific headers. 
   Allocating 64MB buffer for this example.
*/
#define MEM_POOL_SIZE (1024 * 1024 * 64)
static char g_memory_pool[MEM_POOL_SIZE];
static size_t g_pool_index = 0;

void* my_malloc(size_t size) {
    /* Align memory to 8 bytes for float/double performance */
    size_t alignment = 8;
    size_t remainder = g_pool_index % alignment;
    
    if (remainder != 0) {
        g_pool_index += (alignment - remainder);
    }

    if (g_pool_index + size > MEM_POOL_SIZE) {
        printf("Error: Custom memory allocator ran out of memory.\n");
        return NULL;
    }

    void* ptr = &g_memory_pool[g_pool_index];
    g_pool_index += size;
    return ptr;
}

/* 2. Custom String to Integer (replaces atoi) */
int my_atoi(const char *str) {
    int res = 0;
    while (*str >= '0' && *str <= '9') {
        res = res * 10 + (*str - '0');
        str++;
    }
    return res;
}

/* 3. Custom String Comparison (replaces strncmp logic for arguments) */
int is_arg_inverse(const char *str) {
    /* Checks if string starts with "-i" */
    return (str[0] == '-' && str[1] == 'i');
}

/* =============================================================
 * Main Program
 * =============================================================
 */

static unsigned lcg = 1;
unsigned myrand(void) {
    lcg = lcg * 1103515245 + 12345;
    return lcg;
}

int main(int argc, char *argv[]) {
    unsigned MAXSIZE;
    unsigned MAXWAVES;
    unsigned i, j;
    float *RealIn;
    float *ImagIn;
    float *RealOut;
    float *ImagOut;
    float *coeff;
    float *amp;
    int invfft = 0;

    if (argc < 3) {
        printf("Usage: fft <waves> <length> -i\n");
        printf("-i performs an inverse fft\n");
        printf("make <waves> random sinusoids");
        printf("<length> is the number of samples\n");
        return 0;
    }
    else if (argc == 4) {
        /* Replaced !strncmp(argv[3],"-i",2) */
        invfft = is_arg_inverse(argv[3]);
    }

    /* Replaced atoi */
    MAXSIZE = my_atoi(argv[2]);
    MAXWAVES = my_atoi(argv[1]);

    if (MAXSIZE == 0) {
        printf("Error: Size cannot be 0\n");
        return 1;
    }

    /* Replaced malloc with my_malloc */
    RealIn = (float*)my_malloc(sizeof(float) * MAXSIZE);
    ImagIn = (float*)my_malloc(sizeof(float) * MAXSIZE);
    RealOut = (float*)my_malloc(sizeof(float) * MAXSIZE);
    ImagOut = (float*)my_malloc(sizeof(float) * MAXSIZE);
    coeff = (float*)my_malloc(sizeof(float) * MAXWAVES);
    amp = (float*)my_malloc(sizeof(float) * MAXWAVES);

    if (!RealIn || !ImagIn || !RealOut || !ImagOut || !coeff || !amp) {
        return 1; /* Allocation failed */
    }

    /* Makes MAXWAVES waves of random amplitude and period */
    for (i = 0; i < MAXWAVES; i++) {
        coeff[i] = myrand() % 1000;
        amp[i] = myrand() % 1000;
    }
    
    for (i = 0; i < MAXSIZE; i++) {
        RealIn[i] = 0;
        for (j = 0; j < MAXWAVES; j++) {
            /* randomly select sin or cos */
            if (myrand() % 2) {
                RealIn[i] += coeff[j] * cos(amp[j] * i);
            } else {
                RealIn[i] += coeff[j] * sin(amp[j] * i);
            }
            ImagIn[i] = 0;
        }
    }

    /* External call to fft_float */
    fft_float(MAXSIZE, invfft, RealIn, ImagIn, RealOut, ImagOut);

    printf("RealOut:\n");
    for (i = 0; i < MAXSIZE; i++)
        printf("%f \t", RealOut[i]);
    printf("\n");

    printf("ImagOut:\n");
    for (i = 0; i < MAXSIZE; i++)
        printf("%f \t", ImagOut[i]);
    printf("\n");

    return 0;
}

