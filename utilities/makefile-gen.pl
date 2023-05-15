#!/usr/bin/perl

# Generates Makefile for each benchmark in polybench
# Expects to be executed from root folder of polybench
#
# Written by Tomofumi Yuki, 11/21 2014
#

my $GEN_CONFIG = 0;
my $TARGET_DIR = ".";
my $GEN_OMP = 0;

if ($#ARGV !=0 && $#ARGV != 1) {
   printf("usage perl makefile-gen.pl output-dir [-cfg|-omp]\n");
   printf("  -cfg option generates config.mk in the output-dir.\n");
   printf("  -omp option generates [OpenMP Offload] config.mk in the output-dir.\n");
   exit(1);
}



foreach my $arg (@ARGV) {
   if ($arg =~ /-cfg/) {
      $GEN_CONFIG = 1;
   } elsif ($arg =~ /-omp/) {
      $GEN_OMP = 1;
   } elsif (!($arg =~ /^-/)) {
      $TARGET_DIR = $arg;
   }
}


my %categories = (
   'linear-algebra/blas' => 3,
   'linear-algebra/kernels' => 3,
   'linear-algebra/solvers' => 3,
   'datamining' => 2,
   'stencils' => 2,
   'medley' => 2
);

my %extra_flags = (
   'cholesky' => '-lm',
   'gramschmidt' => '-lm',
   'correlation' => '-lm'
);

foreach $key (keys %categories) {
   my $target = $TARGET_DIR.'/'.$key;
   opendir DIR, $target or die "directory $target not found.\n";
   while (my $dir = readdir DIR) {
        next if ($dir=~'^\..*');
        next if (!(-d $target.'/'.$dir));

	my $kernel = $dir;
        my $file = $target.'/'.$dir.'/Makefile';
        my $polybenchRoot = '../'x$categories{$key};
        my $configFile = $polybenchRoot.'config.mk';
        my $utilityDir = $polybenchRoot.'utilities';

        open FILE, ">$file" or die "failed to open $file.";

print FILE << "EOF";
include $configFile

EXTRA_FLAGS=$extra_flags{$kernel}

$kernel: $kernel.c $kernel.h
	\${VERBOSE} \${CC} -o $kernel $kernel.c \${CFLAGS} -I. -I$utilityDir $utilityDir/polybench.c 

clean:
	@ rm -f $kernel

EOF

        close FILE;
   }


   closedir DIR;
}

if ($GEN_CONFIG) {
open FILE, '>'.$TARGET_DIR.'/config.mk';

print FILE << "EOF";
CC=gcc
CFLAGS=-O2 -DPOLYBENCH_DUMP_ARRAYS -DPOLYBENCH_USE_C99_PROTO
EOF

close FILE;

}

if ($GEN_OMP) {
open FILE, '>'.$TARGET_DIR.'/config.mk';

print FILE << "EOF";
CC=clang
#OMPFLAGS= -target x86_64-pc-linux-gnu -fopenmp -fopenmp-targets=nvptx64-nvidia-cuda -Xopenmp-target=nvptx64-nvidia-cuda -march=sm_35
OMPFLAGS= -target x86_64-pc-linux-gnu -fopenmp -fopenmp-targets=amdgcn-amd-amdhsa -Xopenmp-target=amdgcn-amd-amdhsa -march=gfx906
CFLAGS=-O3 -DPOLYBENCH_TIME -DPOLYBENCH_USE_C99_PROTO -lm \${OMPFLAGS}
#CFLAGS += -DPOLYBENCH_DUMP_ARRAYS
EOF

close FILE;

}

