#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct dataBlock {
    int myState;
    int myTag;
    char byteData[1024];
};

int ln2(int n) {
    int r=0;
    while (n>>=1) r++;
    return r;
}
int ones(int N){ return (1<<N) -1;}


int main(int argc, char * argv[]){
    int cacheSize;                          // In kilobytes
    int ways;                               // Associativity
    int blockSize;                          // In bytes
    int size = 1<<24;
    //char  memory [size];                   // 16 MB
    // for(int i=0; i<(1<<24); i++){ memory[i] = 0;}
    unsigned int address;
    int editSize;
    char inst[6];
    //char store[6] = "store";
    char store[6] = "store";
    char * memory = (char *) malloc( 1<<24 * sizeof(char));
    for(int i=0; i<(1<<24); i++){
        memory[i] = 0;
    }
    int t=0;

    
    FILE * f = fopen(argv[1], "r");
    sscanf(argv[2],"%d",&cacheSize);
    cacheSize = 1 << (ln2(cacheSize)+10);
    sscanf(argv[3],"%d",&ways);
    sscanf(argv[4],"%d",&blockSize);

    int blockOffsetBits = ln2(blockSize);
    int sets = cacheSize/blockSize/ways;
    int indexBits = ln2(sets);

    struct dataBlock ** cache = (struct dataBlock ** ) malloc(sets * sizeof(struct dataBlock *)); 

    
    for (int r = 0; r < sets; r++){
        cache[r] = (struct dataBlock *) malloc(ways * sizeof(struct dataBlock ));
    }
    
    //printf("HI %d",sets);
    for(int n = 0; n<sets ; n++){
        for(int i = 0; i < ways; i++){
            struct dataBlock block;
            block.myState = 0;
            block.myTag = 0;
            
            for(int n = 0; n < 1024 ; n++){ block.byteData[n] = 0;}
            cache[n][i] = block;
        }
    }
    
    
    while(fscanf(f, "%s", inst)!=EOF){
        fscanf(f, "%x", &address);
        fscanf(f, "%x", &editSize);

        int blockStart = (address>>blockOffsetBits) * blockSize;
        int blockOffset = address & ones(blockOffsetBits);
        int index = (address>>blockOffsetBits) & ones(indexBits);
        int tag = address>>(indexBits+blockOffsetBits);
        

        if(inst[0]=='s'){
            int editCache = 0;
            int way = -1;
            for(int n = 0; n<ways; n++){
                int crnTag = cache[index][n].myTag;
                int state = cache[index][n].myState;
                if(state== 1 && crnTag== tag){
                    editCache = 1;  // hit in cache
                    way = n;
                    break;
                }
            }
            if (editCache) {printf("%s 0x%x hit ", inst, address); }
            else { printf("%s 0x%x miss ", inst, address); }
            for(int n = 0; n < editSize; n++){ 
                fscanf(f, "%2hhx", &memory[address+n]);
            }

            if (editCache){
                for(int n = blockOffset; n < blockOffset+editSize; n++) {
                    cache[index][way].byteData[n] = memory[address+n-blockOffset];
                }
                struct dataBlock copy = cache[index][way];
                for(int x = way; x<ways-1; x++){
                        cache[index][x] = cache[index][x+1];
                }
                cache[index][ways-1] = copy;
            }
            // for(int frame=0; frame<sets; frame++){
            //     int cacheAddress = cache[index][frame];
            //     int cacheTag = cacheAddress>>(indexBits+blockOffsetBits);
            //     if(cacheTag == tag){hitORmiss = 'h';}
            // }
        }

        if(inst[0] == 'l'){   // Load instruction
            int goMemory = 1;
            int way=-1;
            for(int n = 0; n<ways; n++){
                int crnTag = cache[index][n].myTag;
                int state = cache[index][n].myState;
                if(state== 1 && crnTag== tag){
                    goMemory=0;
                    way = n;
                    break;
                }
            }
            if (goMemory==0){
                struct dataBlock copy = cache[index][way];
                for(int x = way; x<ways-1; x++){
                        cache[index][x] = cache[index][x+1];
                }
                cache[index][ways-1]= copy;
            }
            
            //struct dataBlock * block = (struct dataBlock *) malloc(sizeof(struct dataBlock));
            if (goMemory){

                for(int p = 0; p<ways-1; p++) {   cache[index][p] = cache[index][p+1];    }
                struct dataBlock b;

                b.myState = 1;
                b.myTag = tag;

                for(int n = 0; n < blockSize; n++) {b.byteData[n] = memory[address-blockOffset+n]; }
                // cache[index][ways-1]->myState = neew->myState;
                //cache[index][ways-1]->myTag = neew->myTag;

                // for(int n = 0; n < 1024 ; n++){ cache[index][ways-1]->byteData[n] = neew->byteData[n];}
                cache[index][ways-1] = b;
                t++;

            }
            

            if (goMemory) { printf("%s 0x%x miss ", inst, address); }
            else { printf("%s 0x%x hit ", inst, address); }

            for(int n = blockOffset; n < blockOffset+editSize; n++) {
                printf("%02hhx",cache[index][ways-1].byteData[n]);    
                }
            }
            printf("\n");
    }
    

    return EXIT_SUCCESS;
}