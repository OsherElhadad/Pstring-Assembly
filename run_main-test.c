#include <stdio.h>
#include "pstring.h"

void run_main() {

	Pstring p1;
	Pstring p2;
	int len;
	int opt;

	// initialize first pstring
	scanf("%d", &len);
	scanf("%s", p1.str);
	p1.len = len;

	// initialize second pstring
	scanf("%d", &len);
	scanf("%s", p2.str);
	p2.len = len;

	// select which function to run
	scanf("%d", &opt);
	run_func(opt, &p1, &p2);

}
