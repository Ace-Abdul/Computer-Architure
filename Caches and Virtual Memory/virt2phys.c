#include <stdlib.h>
#include <stdio.h>

int ln(int n) {
    int r=0;
    while (n>>=1) r++;
    return r;
}

int main(int argc, char * argv[]){
    int addressBits;                                   // In bits
    int pageSize;                                      // in bytes
    unsigned int virtualAddress;                       // In hex
    int index = 0;
    int num = 0;

    FILE * f = fopen(argv[1], "r");
    fscanf(f, "%d", &addressBits);              
    fscanf(f, "%d", &pageSize);
    sscanf(argv[2], "%x", &virtualAddress);
    int offsetBits = ln(pageSize);
    int ppn = addressBits - offsetBits;
    int physicalPages[1<<ppn];
    int vpn = virtualAddress>>offsetBits;
    int offset = virtualAddress & ((1<<offsetBits) -1);

    while(fscanf(f, "%d", &physicalPages[index])!=EOF){
        index++;
    }
    int ret = physicalPages[vpn];
    if (ret == -1){
        printf("PAGEFAULT\n");
        return EXIT_SUCCESS;
    }

    ret = ret<<offsetBits;
    ret = ret | offset;
    printf("%x", ret);

    return EXIT_SUCCESS;
}