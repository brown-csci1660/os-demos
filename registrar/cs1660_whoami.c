#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char ** const argv) {
  printf("UID %d, EUID: %d\n", getuid(), geteuid());
  return 0;
}
