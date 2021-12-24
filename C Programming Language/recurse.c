#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int f(int N){
    if (N==0){return 2;}
    return 3 * (N-1) + f(N-1) + 1;
}

int main(int argc, char * argv[]){
    if(argc !=2){
        printf("Please provide 0 or one positive integer.\n");
        return EXIT_SUCCESS;
    }
    
    int num;
    int len = strlen(argv[1]);

    if(sscanf(argv[1], "%d", &num)!=1){
        printf("Please provide 0 or one positive integer.\n");
        return EXIT_SUCCESS;
    }
    if(num<0){
        printf("Please provide a number greater than or equal to 0\n");
        return EXIT_SUCCESS;
    }
    for(int i=0; i<len; i++){
        char c = argv[1][i];
        if (c=='.'){
            printf("Please provide 0 or one positive integer.\n");
            return EXIT_SUCCESS;
        }
    }
    printf("%d\n",f(num));
    return EXIT_SUCCESS;
}