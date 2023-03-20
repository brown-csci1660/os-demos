/*
 * Wrapper script to run reg.sh with setuid
 */
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char ** const argv) {
  setuid(1001);

  // Execute shell script
  execvp("/home/registrar/reg.sh", argv);

  return 0;
}
