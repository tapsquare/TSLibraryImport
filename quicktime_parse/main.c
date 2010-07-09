#include <stdio.h>
#include <arpa/inet.h>

int main () {
  FILE* f = fopen("test.mov", "r");
  uint32_t atom_size;
  char buf[5];
  buf[4] = '\0';
  int numAtoms = 5;
  while (numAtoms--) {
    fread((void*)&atom_size, 4, 1, f);
    atom_size = ntohl(atom_size);
    fread(buf, 4, 1, f);
    if (strcmp(buf, "mdat") == 0) {
      uint32_t i = 0;
      for (; i < atom_size; i+=4) {
        fread(buf, 4, 1, f);
        fwrite(buf, 4, 1, stdout);
      }
      return;
    }
    fseek(f, atom_size, SEEK_CUR);  
    if(atom_size == 0)
      break;
  }
  fclose(f);
}
