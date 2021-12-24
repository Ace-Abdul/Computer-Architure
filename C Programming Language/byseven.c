#include <stdlib.h>
#include <stdio.h>
#include <string.h>
// Checks: typeof, long number, commas, floats

int main(int argc, char* argv[]){
    int num;
    if(argc !=2){
        printf("Please provide 0 or a positive integer.\n");
        return EXIT_SUCCESS;
    }
    int len = strlen(argv[1]);
    for(int i=0; i<len; i++){
        char c = argv[1][i];
        if (c=='.'){
            printf("Please provide 0 or a positive integer.\n");
            return EXIT_SUCCESS;
        }
    }
    if(sscanf(argv[1], "%d", &num)!=1){
        printf("Please provide 0 or one positive integer.\n");
        return EXIT_SUCCESS;
    }
    
    if(num<0){
        printf("Please provide a number greater than or equal to 0\n");
        return EXIT_SUCCESS;
    }

    for (int i=1; i<num+1; i++){
        printf("%d \n", 7*i);
    }

    return EXIT_SUCCESS;
}