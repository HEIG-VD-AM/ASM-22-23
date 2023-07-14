/*
 * exo2.c - Manipulation d'opérateurs logiques
 *
 * Author(s) : Name Surname, Name Surname
 */

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#include <libleds.h>


int main(int argc, char **argv) {
    init_reg_leds();

    uint32_t mask = 0x00FFFFFF;

    uint32_t leds = get_reg_leds();

    uint32_t buf = leds & mask;

    buf = ~buf & mask;

    leds &= ~mask;

    leds |= buf;

    set_reg_leds(leds);

    return 0;
}
