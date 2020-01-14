#include <unistd.h>
#include "py/mpconfig.h"

/*
 * Core UART functions to implement for a port
 */

#if MICROPY_MIN_USE_RX_CPU
#define TDR0 0x00088243
#define SSR0 0x00088244
#define RDR0 0x00088245
#define SSR_TDRE (1 << 7)
#define SSR_RDRF (1 << 6)
#endif

// Receive single character
int mp_hal_stdin_rx_chr(void) {
    unsigned char c = 0;
#if MICROPY_MIN_USE_STDOUT
    int r = read(0, &c, 1);
    (void)r;
#elif MICROPY_MIN_USE_RX_CPU
    // wait for RDRF
    while ((*(volatile unsigned char *)SSR0 & SSR_RDRF) == 0) {
    }
    c = *(volatile unsigned char *)RDR0;
#endif
    return c;
}

// Send string of given length
void mp_hal_stdout_tx_strn(const char *str, mp_uint_t len) {
#if MICROPY_MIN_USE_STDOUT
    int r = write(1, str, len);
    (void)r;
#elif MICROPY_MIN_USE_RX_CPU
    while (len--) {
        // wait for TDRE
	while ((*(volatile unsigned char *)SSR0 & SSR_TDRE) == 0) {
	}
        *(volatile unsigned char *)TDR0 = *str++;
    }
#endif
}
