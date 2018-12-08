#!/usr/bin/env bash
Rscript build.R _source/tutorial.Rmd;
jekyll build
jekyll serve
