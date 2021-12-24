#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define PI 3.14159265358979323846

/*void noded(struct pizzaStruct * node, struct pizzaStruct * target){
    node = target;
}*/
struct pizzaStruct {
    char pizName[128];
    float PizPerDol;
    struct pizzaStruct * next;
};


struct pizzaStruct * first = NULL; //first node pointing at first struct
//struct pizzaStruct * last = NULL; //last node pointing at last struct

void BubbleSort(struct pizzaStruct * StructPointer, int num);
void printList(struct pizzaStruct * first);

int main(int argc, char * argv[]){
    int num = 0;
    char name[128];                     //storing pizza name every iteration of while loop
    float diam;                         //storing diamter every iteration
    float price;                        //storing price every iteration

    FILE * fyle = fopen (argv[1],"r");

    if (fscanf(fyle,"%s", name)!=1){    //Handling Emptiness
        printf("PIZZA FILE IS EMPTY \n");
        free(first);
        return EXIT_SUCCESS;
    }

    int notDone = strcmp(name, "DONE"); // returns 0 if name == DONE 
    while(notDone){
        struct pizzaStruct * StructPointer = (struct pizzaStruct *) malloc(sizeof(struct pizzaStruct)); //Create a pointer to a new instance of pizzaStruct
        strcpy(StructPointer->pizName, name);
        float ppd;
        fscanf(fyle,"%f", &diam);
        fscanf(fyle,"%f", &price);
        float area = (PI / 4) * diam * diam; // 
        if(price == 0 || diam == 0){ ppd = 0;}
        else{ppd = area/price;}         // Pizza area per dollar
        StructPointer->PizPerDol = ppd;
        fscanf(fyle,"%s", name);
        notDone = strcmp(name, "DONE");
        //if(num==0){noded(first, &StructPointer);}
        if(num==0){                     //If first iteration
            first = StructPointer;
            first->next = NULL;
            //last = StructPointer;
        }
        else{
            //last->next = StructPointer;
            //last = StructPointer;
            BubbleSort(StructPointer, num);
        }
        num++;
    }

    
    fclose(fyle);
    printList(first);
    return EXIT_SUCCESS;
    }
    void BubbleSort(struct pizzaStruct * StructPointer, int num){
        struct pizzaStruct * current = first;
        struct pizzaStruct * preCurrent = first;
        int exec = 1;
        int numTrav = 0;
        if (first->PizPerDol < StructPointer->PizPerDol){
            StructPointer->next = first;
            first = StructPointer;
            exec = 0;
        }
        if (first->PizPerDol == StructPointer->PizPerDol && exec){
            if (strcmp(first->pizName, StructPointer->pizName)<0){
                StructPointer->next = NULL;
                first->next = StructPointer;
            }
            else{
            StructPointer->next = first;
            first = StructPointer;
            exec = 0;
            }
        }   
        
        while (current != NULL && exec){
            if(current->PizPerDol < StructPointer->PizPerDol){
                preCurrent->next = StructPointer;
                StructPointer->next = current;
                break;
            }
            if(current->next!= NULL && current->PizPerDol == StructPointer->PizPerDol){ // Line causing error(replacing ppd w/ StructPointer->PizPerDol)
                
                if (strcmp(current->next->pizName, StructPointer->pizName)>0){ // This is were Mellow is fing up
                    StructPointer->next = current->next;
                    current->next = StructPointer;
                    break;
                }
                if (strcmp(current->pizName, StructPointer->pizName)>0){
                    preCurrent->next = StructPointer;
                    StructPointer->next = current;

                    break;
                }
            }
            if(current->next==NULL && StructPointer->PizPerDol < current->PizPerDol){          //last node has lower ppd; THIS PART DOES NOT EXECUTE
                StructPointer->next = NULL;
                current->next = StructPointer;
                break;
                }
            if(current->next==NULL && StructPointer->PizPerDol == current->PizPerDol){          //last node has equal ppd
                if (strcmp(current->pizName, StructPointer->pizName)>0){
                    StructPointer->next = current;
                    preCurrent->next = StructPointer;
                    break;
                }

                else{
                    StructPointer->next = current->next;
                    current->next = StructPointer;
                    break;
                    }
                }
            preCurrent = current;
            current = current->next;
            numTrav++;
        }
}

void printList(struct pizzaStruct * first){
    struct pizzaStruct * preCurrent = first;
    struct pizzaStruct * current = first;

    while(current!=NULL){
        printf("%s %f\n", current->pizName, current->PizPerDol);
        preCurrent = current;
        current = current->next;
        free(preCurrent);
    }
}