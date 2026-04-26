#include <stdio.h>
#include "clac.h"
#include "Wifi.h"

int main() {

    printf("Hello World \n 1 + 1 = %d \n", sum(1,1));
    WIFI_Init();

    return 0;
}